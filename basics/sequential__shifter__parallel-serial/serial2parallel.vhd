-- serial to parallel converter
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SERIAL2PARALLEL IS
GENERIC(NBITS : NATURAL := 4);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; IN_TICK : IN STD_LOGIC -- input tick to control the conversion from other device
    ; DIN : IN STD_LOGIC
    ; LOAD : OUT STD_LOGIC -- use it as tick, to load data immediately, e.g. from FIFO
    ; DONE : OUT STD_LOGIC -- use it as tick, if data is obtained after one clock cycle e.g. from generators
    ; DOUT : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
);
END SERIAL2PARALLEL;

ARCHITECTURE SERIAL2PARALLEL_ARCH OF SERIAL2PARALLEL IS
    TYPE STATE IS (STATE_IDLE, STATE_STORE0, STATE_STORE1);
    SIGNAL STATE_REG, STATE_NEXT : STATE;
    SIGNAL Y_REG, Y_NEXT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);
    SIGNAL I_REG, I_NEXT : NATURAL RANGE 0 TO NBITS;

BEGIN

    -- output port connection
    DOUT <= Y_NEXT WHEN I_REG = NBITS - 1;

    -- update registers
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            I_REG <= 0;
            Y_REG <= (OTHERS => '0');
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            I_REG <= I_NEXT;
            Y_REG <= Y_NEXT;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    -- update states
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            STATE_REG <= STATE_IDLE;
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            STATE_REG <= STATE_NEXT;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    -- output data calculation
    PROCESS(CLK, DIN, STATE_NEXT, Y_NEXT, I_NEXT, STATE_REG, Y_REG, I_REG)
    BEGIN
        Y_NEXT <= Y_REG;
        CASE STATE_REG IS
            WHEN STATE_IDLE =>
                I_NEXT <= 0;
                LOAD <= '1';
                DONE <= '0';

                -- this loop is used to load the data immediately into the registers
                IF (IN_TICK = '1' AND DIN = '0') THEN -- i.e. if first value is '0' -> store0
                    STATE_NEXT <= STATE_STORE0;
                ELSIF (IN_TICK = '1' AND DIN = '1') THEN -- i.e. if first value is '1' -> store1
                    STATE_NEXT <= STATE_STORE1;
                ELSE
                    STATE_NEXT <= STATE_IDLE;
                END IF;

            WHEN STATE_STORE0 => -- input data is '0'
                I_NEXT <= I_REG + 1;
                Y_NEXT(I_REG) <= '0';
                LOAD <= '0';
                DONE <= '0';
                IF (I_REG = NBITS - 1) THEN
                    STATE_NEXT <= STATE_IDLE;
                    DONE <= '1';
                ELSIF (DIN = '1') THEN
                    STATE_NEXT <= STATE_STORE1;
                ELSE
                    STATE_NEXT <= STATE_STORE0;
                END IF;

            WHEN STATE_STORE1 => -- input data is '1'
                I_NEXT <= I_REG + 1;
                Y_NEXT(I_REG) <= '1';
                LOAD <= '0';
                DONE <= '0';
                IF (I_REG = NBITS - 1) THEN
                    STATE_NEXT <= STATE_IDLE;
                    DONE <= '1';
                ELSIF (DIN = '0') THEN
                    STATE_NEXT <= STATE_STORE0;
                ELSE
                    STATE_NEXT <= STATE_STORE1;
                END IF;
        END CASE;
    END PROCESS;
END SERIAL2PARALLEL_ARCH;

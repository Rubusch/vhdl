-- parallel to serial converter
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PARALLEL2SERIAL IS
GENERIC(NBITS : INTEGER := 8);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; DATA_IN : IN STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) -- parallel data
    ; DATA_OUT : OUT STD_LOGIC -- serial data
    ; EMPTY_TICK : OUT STD_LOGIC -- 1 = emtpy, to control other devices
);
END PARALLEL2SERIAL;

ARCHITECTURE PARALLEL2SERIAL_ARCH OF PARALLEL2SERIAL IS
    TYPE OPERATION_TYPE IS (STATE_IDLE, STATE_CONVERT, STATE_DONE);
    SIGNAL STATE_REG, STATE_NEXT : OPERATION_TYPE;
    SIGNAL DATA_REG, DATA_NEXT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL COUNT_REG, COUNT_NEXT : UNSIGNED(NBITS-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

    -- connect output port
    DATA_OUT <= DATA_REG(0);

    -- current register values
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            COUNT_REG <= (OTHERS => '0');
            STATE_REG <= STATE_IDLE;
            DATA_REG <= (OTHERS => '0');
        ELSIF (CLK'EVENT AND CLK = '1' AND RST /= '1') THEN
            COUNT_REG <= COUNT_NEXT;
            STATE_REG <= STATE_NEXT;
            DATA_REG <= DATA_NEXT;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    -- next value in the register
    -- note: in a matter of style, output data calculation and next values in the register might also happen separately
    PROCESS(DATA_IN, STATE_REG, COUNT_REG, DATA_REG)
    BEGIN
        EMPTY_TICK <= '0';

        COUNT_NEXT <= COUNT_REG;
        STATE_NEXT <= STATE_REG;
        DATA_NEXT <= DATA_REG;

        CASE STATE_REG IS
            WHEN STATE_IDLE =>
                COUNT_NEXT <= COUNT_REG + 1; -- TODO CHECK IF THIS WORKS OUT
                STATE_NEXT <= STATE_CONVERT;
                DATA_NEXT <= DATA_IN;
                EMPTY_TICK <= '1';

            WHEN STATE_CONVERT =>
                COUNT_NEXT <= COUNT_REG + 1;
                IF (NBITS = COUNT_REG) THEN
                    -- NOTE NBITS is used here, not NBITS-1
                    -- This clocked shifter needs one clock cycle to transfer the converted data (i.e. parallel data) to the next device
                    -- Therefore it cannot update the current value immediately after the conversion. Hence COUNT_REG = NBITS is used instead of COUNT_REG = NBITS-1
                    -- One extra bit is appended at the end, and will be omitted as it will not read the last value.
                    -- Also, DATA_NEXT is not defined here, as its last bit is not read, thus the value of DATA_NEXT at NBITS will be the same as NBITS-1
                    STATE_NEXT <= STATE_DONE;
                ELSE
                    -- shift right and prepend zero
                    DATA_NEXT <= '0' & DATA_REG(NBITS-1 DOWNTO 1);
                END IF;

            WHEN STATE_DONE =>
                COUNT_NEXT <= (OTHERS => '0');
                STATE_NEXT <= STATE_IDLE;
        END CASE;
    END PROCESS;
END PARALLEL2SERIAL_ARCH;

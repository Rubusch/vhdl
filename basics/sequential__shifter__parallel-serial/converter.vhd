-- top level connection between serial and parallel converters
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK; -- TODO: TEST

ENTITY CONVERTER IS
GENERIC(MODULO : INTEGER := 11 -- count up to modulo
    ; NBITS : INTEGER := 4     -- n bits needed to count up to modulo
);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; DATA_IN : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
    ; DATA_OUT : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
);
END CONVERTER;

ARCHITECTURE CONVERTER_ARCH OF CONVERTER IS
    SIGNAL COUNT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);
    SIGNAL DOUT : STD_LOGIC := '0';
    SIGNAL EMPTY_TICK : STD_LOGIC := '0';
    SIGNAL NOT_EMPTY_TICK : STD_LOGIC := '0';

BEGIN

    -- register is not empty i.e. read data on this tick
    NOT_EMPTY_TICK <= NOT EMPTY_TICK;

    -- generate COUNT on DATA_OUT
    DATA_IN <= COUNT;

    -- parallel to serial conversion
    P2S_UNIT : ENTITY WORK.PARALLEL2SERIAL
        GENERIC MAP (NBITS => NBITS)
        PORT MAP (CLK => CLK, RST => RST, DATA_IN => COUNT, DATA_OUT => DOUT, EMPTY_TICK => EMPTY_TICK);

    -- serial to parallel conversion
    S2P_UNIT : ENTITY WORK.SERIAL2PARALLEL
        GENERIC MAP (NBITS => NBITS)
        PORT MAP (CLK => CLK, RST => RST, DIN => DOUT, DOUT => DATA_OUT, IN_TICK => NOT_EMPTY_TICK);

    -- mod counter to generate data (i.e. COUNT) for transmission
    FSMCOUNTER_UNIT : ENTITY WORK.FSMCOUNTER
        GENERIC MAP (MODULO => MODULO, NBITS => NBITS)
        PORT MAP (CLK => EMPTY_TICK, RST => RST, COUNT => COUNT);

END CONVERTER_ARCH;

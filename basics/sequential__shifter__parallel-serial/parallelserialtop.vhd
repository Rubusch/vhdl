-- top level connection between serial and parallel converters
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK; -- TODO: TEST

ENTITY PARALLELSERIALTOP IS
GENERIC(MODULO : INTEGER := 11 -- count up to modulo
    ; NBITS : INTEGER := 4     -- n bits needed to count up to modulo
);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; DATA_IN : IN STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
    ; DATA_OUT : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
);
END PARALLELSERIALTOP;

ARCHITECTURE PARALLELSERIALTOP_ARCH OF PARALLELSERIALTOP IS
    SIGNAL COUNT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);
    SIGNAL DOUT : STD_LOGIC := '0';
    SIGNAL E_TICK : STD_LOGIC := '0';
    SIGNAL NOT_E_TICK : STD_LOGIC := '0';

BEGIN

-- TODO

END PARALLELSERIALTOP_ARCH;

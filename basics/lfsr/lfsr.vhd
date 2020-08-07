-- lfsr (linear feedback shift register)
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY LFSR IS
GENERIC( NBITS : INTEGER := 3);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; Q : OUT STD_LOGIC_VECTOR(NBITS - 1 DOWNTO 0)
);

ARCHITECTURE LFSR_ARCH OF LFSR IS
    -- TODO
BEGIN
    -- TODO
END LFSR_ARCH;

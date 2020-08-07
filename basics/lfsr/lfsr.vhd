-- lfsr (linear feedback shift register)
--
-- P = x^3 + x^2 + 1
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY LFSR IS
GENERIC( NBITS : INTEGER := 3);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; Q : OUT STD_LOGIC_VECTOR(NBITS DOWNTO 0)
);

ARCHITECTURE LFSR_ARCH OF LFSR IS
    SIGNAL R_REG : STD_LOGIC_VECTOR(NBITS DOWNTO 0);
    SIGNAL R_NEXT : STD_LOGIC_VECTOR(NBITS DOWNTO 0);
    SIGNAL FEEDBACK_VALUE : STD_LOGIC; -- based on feedback polynomial

BEGIN

    -- TODO
END LFSR_ARCH;

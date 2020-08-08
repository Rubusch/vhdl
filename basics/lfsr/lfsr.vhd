-- lfsr (linear feedback shift register)
--
-- feedback polynomial:
-- P = x^3 + x^2 + 1
--
-- maximum length:
-- 2^3 - 1 = 7
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

    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            R_REG(0) <= '1'; -- SEED: "...000001"
            R_REG(NBITS DOWNTO 1) <= (OTHERS => '0');
        ELSIF (CLK'EVENT AND CLK = '1' AND RST /= '1') THEN
            R_REG <= R_NEXT;
        END IF;
    END PROCESS;

    -- NBITS = 3
    FEEDBACK_VALUE <= R_REG(3) XOR R_REG(2) XOR R_REG(0);

    -- NBITS = 4
--    FEEDBACK_VALUE <= R_REG(4) XOR R_REG(3) XOR R_REG(0);

    -- NBITS = 5, maximum length = 28, not 31
--    FEEDBACK_VALUE <= R_REG(5) XOR R_REG(3) XOR R_REG(0);

    -- NBITS = 9
--    FEEDBACK_VALUE <= R_REG(9) XOR R_REG(5) XOR R_REG(0);

    R_NEXT <= FEEDBACK_VALUE & R_REG(NBITS DOWNTO 1);

    Q <= R_REG;
END LFSR_ARCH;

--
--          +------------+
--  A(1..0) |            |    Q
-- ---------|            |------
--  B(1..0) | COMPARATOR |
-- ---------|            |
--          +------------+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY COMPARATOR IS
PORT( A : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    ; B : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    ; Q : OUT STD_LOGIC
    );
END ENTITY COMPARATOR;

ARCHITECTURE COMPARATOR_ARCH OF COMPARATOR IS
BEGIN
    -- A ?=? B, COMPARE TWO 2-BIT INPUTS
    Q <= (A(0) XOR B(0)) NOR (A(1) XOR B(1));
END ARCHITECTURE COMPARATOR_ARCH;

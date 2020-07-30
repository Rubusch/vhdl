--
--          +---------+
--  D(7..0) |         | S(7..0)
-- ---------| 1-BIT   |---------
--          | SHIFTER |
--          |         |
--          +---------+
--  C            |
-- --------------+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SHIFTER IS
PORT( D : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
    ; C : IN STD_LOGIC
    ; S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END ENTITY SHIFTER;

ARCHITECTURE SHIFTER_ARCH OF SHIFTER IS
BEGIN
    S(0) <= NOT C AND D(1);
    S(1) <= (D(0) AND C) OR (NOT C AND D(2));
    S(2) <= (D(1) AND C) OR (NOT C AND D(3));
    S(3) <= (D(2) AND C) OR (NOT C AND D(4));
    S(4) <= (D(3) AND C) OR (NOT C AND D(5));
    S(5) <= (D(4) AND C) OR (NOT C AND D(6));
    S(6) <= (D(5) AND C) OR (NOT C AND D(7));
    S(7) <= D(6) AND C;
END ARCHITECTURE SHIFTER_ARCH;

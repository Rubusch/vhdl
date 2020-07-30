--
--       +---------+
--  A    | DECODER | D(7..0)
-- ------|         |---------
--  B    |         |
-- ------|         |
--  C    |         |
-- ------|         |
--       +---------+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DECODER_ENT IS
PORT( A : IN STD_LOGIC
    ; B : IN STD_LOGIC
    ; C : IN STD_LOGIC
    ; D : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END ENTITY DECODER_ENT;

ARCHITECTURE DECODER_ARCH OF DECODER_ENT IS

BEGIN
    D(0) <= NOT A AND NOT B AND NOT C;
    D(1) <= NOT A AND NOT B AND C;
    D(2) <= NOT A AND B AND NOT C;
    D(3) <= NOT A AND B AND C;
    D(4) <= A AND NOT B AND NOT C;
    D(5) <= A AND NOT B AND C;
    D(6) <= A AND B AND NOT C;
    D(7) <= A AND B AND C;
END ARCHITECTURE DECODER_ARCH;

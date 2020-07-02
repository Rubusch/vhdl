--
--         +------------+
--  A      | 1-BIT      |  SUM
-- --------| HALF-ADDER |-------
--  B      |            |
-- --------|            |
--         +------------+
--                |       CARRY
--                +-------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY HALFADDER_ENT IS
PORT( A, B : IN STD_LOGIC
	; SUM, CARRY : OUT STD_LOGIC
);
END ENTITY HALFADDER_ENT;

ARCHITECTURE HALFADDER_ARCH OF HALFADDER_ENT IS
BEGIN
    -- KEYS ARE USING NEGATIVE LOGIC
    SUM <= NOT (A XOR B);
    CARRY <= NOT (A AND B);
END ARCHITECTURE HALFADDER_ARCH;

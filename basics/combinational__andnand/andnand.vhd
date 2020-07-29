--
--               +---+
--  A --------+--| & |
--         +--|--|   |------ Q
--         |  |  +---+
--         |  |
--         |  |  +---+
--         |  +--| & |o----- QBAR
--  B -----+-----|   |
--               +---+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ANDNAND IS
PORT( A    : IN STD_LOGIC
    ; B    : IN STD_LOGIC
    ; Q    : OUT STD_LOGIC
    ; QBAR : OUT STD_LOGIC
);
END ENTITY ANDNAND;

ARCHITECTURE ANDNAND_ARCH of ANDNAND IS
BEGIN
    Q    <= A AND B;
    QBAR <= A NAND B;
END ARCHITECTURE ANDNAND_ARCH;


-- 1-BIT ARITHMETIC-LOGICAL-UNIT (ALU)
--
--  CARRY_IN
-- ---------------------+
--                      |
--         +--------------------------+
--  INVA   |                          |
-- --------|             LOGICAL      |  OUTPUT
--  A      |                          |-------------
-- --------| I           ARITHMETIC   |
--  ENA    | N                        |
-- --------| P                        |
--  B      | U                        |
-- --------| T                        |
--  ENB    |                          |
-- --------|                          |
--         |                          |
--         |                          |
--  F0     |                          |
-- --------| SELECT LOGICAL OR        |
--  F1     | ARITHMETICAL OPERATION   |
-- --------|                          |
--         +--------------------------+
--                      |                CARRY_OUT
--                      +---------------------------
--
--
-- NB: PIN ASSIGNMENT FOR MY DE1:
-- 
-- A            - KEY[0]
-- B            - KEY[1]
--
-- ENA          - SW[0]
-- ENB          - SW[1]
-- INVA         - SW[2]
-- CARRY_IN     - SW[3]
--
-- F[0]         - SW[8]
-- F[1]         - SW[9]
--
-- OUTPUT       - LED[0]
-- CARRY_OUT    - LED[1]
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD;

ENTITY ALU_ENT IS
PORT( INVA : IN STD_LOGIC
    ; A : IN STD_LOGIC
    ; ENA : IN STD_LOGIC
    ; B : IN STD_LOGIC
    ; ENB : IN STD_LOGIC
    ; F : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    ; CARRY_IN : IN STD_LOGIC
    ; CARRY_OUT : OUT STD_LOGIC
    ; OUTPUT : OUT STD_LOGIC
);
END ENTITY ALU_ENT;

ARCHITECTURE ALU_ARCH OF ALU_ENT IS
-- TODO
BEGIN
-- TODO
END ARCHITECTURE ALU_ARCH;

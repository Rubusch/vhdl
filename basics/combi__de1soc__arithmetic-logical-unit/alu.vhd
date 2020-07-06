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
-- NB: SETUP FOR MY DE1 SHALL BE AS FOLLOWS
-- 
-- A, B ARE KEYS
-- ENA, ENB, INVA, CARRY_IN ARE THE FIRST SWITCHES
-- F[0,1] ARE THE LAST SWITCHES
-- OUTPUT IS LED[0]
-- CARRY_OUT IS LED[1]

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

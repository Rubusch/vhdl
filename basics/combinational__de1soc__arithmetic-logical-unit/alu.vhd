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
--                            CARRY_OUT | OUTPUT
-- ----------------------------------------------------------------
--                                | LED1| LED0|
--  | SW9 | SW8 | ... | SW3 | SW2 | SW1 | SW0 | ... | KEY1 | KEY0 |
-- ----------------------------------------------------------------
--   F[1]  F[0]    CARRY_IN  INVA   ENB   ENA          B      A
--
--
-- LOGIC
--
--  A | B |ENA|ENB|INV|CRY|F0 |F1 ||CRY|OUT
--    |   |   |   | A |IN |   |   ||OUT|   
-- K0 |K1 |SW0|SW1|SW2|
-- ========================================
--  0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 || 0 | 0
--  0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 || 0 | 0
--  0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 ||   |
-- (...)
--
-- NOTE: THIS DEMO IS NOT SUFFICIENTLY TESTED!


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
    COMPONENT FULLADDER_ENT
    PORT( A : IN STD_LOGIC
        ; B : IN STD_LOGIC
        ; CARRY_IN : IN STD_LOGIC
        ; CARRY_OUT : OUT STD_LOGIC
        ; SUM : OUT STD_LOGIC
        ; SEL : IN STD_LOGIC
    );
    END COMPONENT;

    COMPONENT LOGICAL_ENT
    PORT( A : IN STD_LOGIC
        ; B : IN STD_LOGIC
        ; SELECT_AND : IN STD_LOGIC
        ; SELECT_OR : IN STD_LOGIC
        ; SELECT_NOT : IN STD_LOGIC
        ; OUTPUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT DECODER_ENT
    PORT( F : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; SEL : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
    END COMPONENT;

    SIGNAL SEL_TMP : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL A_TMP : STD_LOGIC;
    SIGNAL B_TMP : STD_LOGIC;
    SIGNAL LOGICAL_OUT_TMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ADDER_OUT_TMP : STD_LOGIC;

BEGIN

    A_TMP <= INVA XOR (ENA AND (NOT A)); -- REMEMBER: A IS A KEY, AND KEYS FOLLOW NEGATIVE LOGIC ON DE1
    B_TMP <= ENB AND (NOT B); -- REMEMBER: B IS A KEY, AND KEYS FOLLOW NEGATIVE LOGIC ON DE1

    D1 : DECODER_ENT PORT MAP(F, SEL_TMP);

    LU : LOGICAL_ENT PORT MAP(A_TMP, B_TMP, SEL_TMP(3), SEL_TMP(2), SEL_TMP(1), LOGICAL_OUT_TMP);
    FA : FULLADDER_ENT PORT MAP(A_TMP, B_TMP, CARRY_IN, CARRY_OUT, ADDER_OUT_TMP, SEL_TMP(0));

    OUTPUT <= LOGICAL_OUT_TMP(0) OR LOGICAL_OUT_TMP(1) OR LOGICAL_OUT_TMP(2) OR ADDER_OUT_TMP;    

END ARCHITECTURE ALU_ARCH;

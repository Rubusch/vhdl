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
-- please, have a look into the <BOARD>_pin-assignment.csv
--
-- LOGIC
-- please, find a testbench with corresponding tb_input.csv
--
-- NOTE: THIS DEMO IS NOT SUFFICIENTLY TESTED!


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD;

ENTITY ALU IS
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
END ENTITY ALU;

ARCHITECTURE ALU_ARCH OF ALU IS
    COMPONENT FULLADDER
    PORT( A : IN STD_LOGIC
        ; B : IN STD_LOGIC
        ; CARRY_IN : IN STD_LOGIC
        ; CARRY_OUT : OUT STD_LOGIC
        ; SUM : OUT STD_LOGIC
        ; SEL : IN STD_LOGIC
    );
    END COMPONENT;

    COMPONENT LOGICAL
    PORT( A : IN STD_LOGIC
        ; B : IN STD_LOGIC
        ; SELECT_AND : IN STD_LOGIC
        ; SELECT_OR : IN STD_LOGIC
        ; SELECT_NOT : IN STD_LOGIC
        ; OUTPUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT DECODER
    PORT( F : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; SEL : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
    END COMPONENT;

    SIGNAL SEL_TMP : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL A_TMP : STD_LOGIC := '0';
    SIGNAL B_TMP : STD_LOGIC := '0';
    SIGNAL LOGICAL_OUT_TMP : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ADDER_OUT_TMP : STD_LOGIC := '0';

BEGIN

    A_TMP <= INVA XOR (ENA AND A);
    B_TMP <= ENB AND B;

    D1 : DECODER
        PORT MAP(F => F, SEL => SEL_TMP);

    LU : LOGICAL
        PORT MAP(A => A_TMP, B => B_TMP, SELECT_AND => SEL_TMP(3), SELECT_OR => SEL_TMP(2), SELECT_NOT => SEL_TMP(1), OUTPUT => LOGICAL_OUT_TMP);

    FA : FULLADDER
        PORT MAP(A => A_TMP, B => B_TMP, CARRY_IN => CARRY_IN, CARRY_OUT => CARRY_OUT, SUM => ADDER_OUT_TMP, SEL => SEL_TMP(0));

    OUTPUT <= LOGICAL_OUT_TMP(0) OR LOGICAL_OUT_TMP(1) OR LOGICAL_OUT_TMP(2) OR ADDER_OUT_TMP;    

END ARCHITECTURE ALU_ARCH;

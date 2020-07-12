--
--  CARRY_IN
-- -------------+
--              |
--         +------------+
--  A      | 1-BIT      |  SUM
-- --------| HALF-ADDER |-------
--  B      |            |
-- --------|            |
--         +------------+
--                |   CARRY_OUT
--                +-------------
--
--
--  A | B |CARRY|| SUM |CARRY
--    |   | IN  ||     | OUT
-- ==============================
--  0 | 0 | 0   ||   0 |  0
--  0 | 0 | 1   ||   1 |  0
--  0 | 1 | 0   ||   1 |  0
--  0 | 1 | 1   ||   0 |  1
--  1 | 0 | 0   ||   1 |  0
--  1 | 0 | 1   ||   0 |  1
--  1 | 1 | 0   ||   0 |  1
--  1 | 1 | 1   ||   1 |  1

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FULLADDER_ENT IS
PORT( A : IN STD_LOGIC
    ; B : IN STD_LOGIC
    ; CARRY_IN : IN STD_LOGIC
    ; SUM : OUT STD_LOGIC
    ; CARRY_OUT : OUT STD_LOGIC
);
END ENTITY FULLADDER_ENT;

-- NB: INCLUDED ENTITIES FROM OTHER FILES DON'T NEED ANY FURTHER INSTRUCTION IN VHDL
-- JUST ADD THE FILES TO THE PROJECT AND USE THE ENTITIES
ARCHITECTURE FULLADDER_ARCH OF FULLADDER_ENT IS
    COMPONENT HALFADDER_ENT
    PORT( A : IN STD_LOGIC
        ; B : IN STD_LOGIC
        ; SUM : OUT STD_LOGIC
        ; CARRY : OUT STD_LOGIC
    );
    END COMPONENT;
    SIGNAL CARRY_FIRST_TMP : STD_LOGIC;
    SIGNAL CARRY_SECOND_TMP : STD_LOGIC;
    SIGNAL SUM_TMP : STD_LOGIC;

BEGIN
-- WHEN USING THE FULLADDER AS A COMPONENT, SET CARRY_IN TO 0 FOR THE FIRST ITERATION

--    HA1 : HALFADDER_ENT PORT MAP(A, B, SUM_TMP, CARRY_FIRST_TMP); -- TODO change positional assignment here
--    HA2 : HALFADDER_ENT PORT MAP(CARRY_IN, SUM_TMP, SUM, CARRY_SECOND_TMP); -- TODO change positional assignment here

    HA1 : HALFADDER_ENT PORT MAP(
        A => A,
        B => B,
        SUM => SUM_TMP,
        CARRY => CARRY_FIRST_TMP);

    HA2 : HALFADDER_ENT PORT MAP(
        A => CARRY_IN,
        B => SUM_TMP,
        SUM => SUM,
        CARRY => CARRY_SECOND_TMP);

    CARRY_OUT <= CARRY_FIRST_TMP OR CARRY_SECOND_TMP;

END ARCHITECTURE FULLADDER_ARCH;

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

ENTITY FULLADDER IS
PORT( A : IN STD_LOGIC
    ; B : IN STD_LOGIC
    ; CARRY_IN : IN STD_LOGIC
    ; SUM : OUT STD_LOGIC
    ; CARRY_OUT : OUT STD_LOGIC
);
END ENTITY FULLADDER;

-- NB: INCLUDED ENTITIES FROM OTHER FILES DON'T NEED ANY FURTHER INSTRUCTION IN VHDL
-- JUST ADD THE FILES TO THE PROJECT AND USE THE ENTITIES
ARCHITECTURE FULLADDER_ARCH OF FULLADDER IS
    COMPONENT HALFADDER
    PORT( A : IN STD_LOGIC
        ; B : IN STD_LOGIC
        ; SUM : OUT STD_LOGIC
        ; CARRY : OUT STD_LOGIC
    );
    END COMPONENT;
    SIGNAL CARRY_OUT_FIRST : STD_LOGIC;
    SIGNAL CARRY_OUT_SECOND : STD_LOGIC;
    SIGNAL SUM_TMP : STD_LOGIC;

BEGIN
-- WHEN USING THE FULLADDER AS A COMPONENT, SET CARRY_IN TO 0 FOR THE FIRST ITERATION

    HA1 : HALFADDER
        PORT MAP(A => A, B => B, SUM => SUM_TMP, CARRY => CARRY_OUT_FIRST);

    HA2 : HALFADDER
        PORT MAP(A => CARRY_IN, B => SUM_TMP, SUM => SUM, CARRY => CARRY_OUT_SECOND);

    CARRY_OUT <= CARRY_OUT_FIRST OR CARRY_OUT_SECOND;

END ARCHITECTURE FULLADDER_ARCH;

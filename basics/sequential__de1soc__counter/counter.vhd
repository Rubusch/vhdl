-- 
--         +-----------+
--  CLK    |           | VAL(9..0)
-- --------|>          |------------
--  ENA    |  COUNTER  |
-- --------|           |
--         |           |
--         +-----------+
--  RST          |
-- --------------+
--
-- THE COUNTER DISPLAYS A SELECTION OF DIGITS OF A 32-BIT COUNTER VIA LEDS
-- ENABLE THE COUNTER VIA SW0
-- RESET THE LEDS VIA KEY0

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY COUNTER_ENT IS
PORT( CLK, ENA, RST : IN STD_LOGIC
    ; VAL           : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000"
    );
END ENTITY COUNTER_ENT;

ARCHITECTURE COUNTER_ARCH OF COUNTER_ENT IS
    SIGNAL COUNTER : UNSIGNED(31 DOWNTO 0) := x"00000000";
	ALIAS SELECTION IS COUNTER(25 DOWNTO 16);
BEGIN
    P1 : PROCESS(RST, CLK)
    BEGIN
        IF (RST = '0') THEN
            VAL <= "0000000000"; -- IN ORDER TO AVOID LATCHES
            COUNTER <= X"00000000";
        ELSIF (CLK'EVENT) AND (CLK = '1') THEN
            IF (ENA = '1') THEN
                COUNTER <= COUNTER + 1;
                VAL <= STD_LOGIC_VECTOR(SELECTION);                
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE COUNTER_ARCH;

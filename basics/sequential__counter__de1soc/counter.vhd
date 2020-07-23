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

ENTITY COUNTER IS
GENERIC( NBITS : INTEGER := 10 );
PORT( CLK, ENA, RST : IN STD_LOGIC
    ; COUNT : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0')
);
END ENTITY COUNTER;

ARCHITECTURE COUNTER_ARCH OF COUNTER IS
--    SIGNAL COUNTER : UNSIGNED(31 DOWNTO 0) := X"00000000";
--    ALIAS SELECTION IS COUNTER(25 DOWNTO 16);
    SIGNAL COUNT_REG, COUNT_NEXT : UNSIGNED(NBITS-1 DOWNTO 0);

BEGIN

    P1 : PROCESS(RST, CLK)
    BEGIN
        IF (RST = '1') THEN
--            COUNT <= (OTHERS => '0'); -- IN ORDER TO AVOID LATCHES
--            COUNT_NEXT <= (OTHERS => '0');
            COUNT_REG <= (OTHERS => '0');
--            COUNTER <= (OTHERS => '0');
        ELSIF (CLK'EVENT) AND (CLK = '1') THEN
            IF (ENA = '1') THEN
                COUNT_REG <= COUNT_NEXT;
--                COUNTER <= COUNTER_NEXT;
--                COUNT <= STD_LOGIC_VECTOR(SELECTION);
            ELSE
                COUNT_REG <= COUNT_REG;
            END IF;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    COUNT_NEXT <= COUNT_REG + 1;
    
    COUNT <= STD_LOGIC_VECTOR(COUNT_REG);

END ARCHITECTURE COUNTER_ARCH;

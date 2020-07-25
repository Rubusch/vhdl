-- 
--  D[7..0]  +------------+  Q[7..0]
-- ----------|            |---------->
--  CLK      |  8-bit     |
-- ----------|>           |
--  ENA      | D register |
-- ----------|            |
--           +------------+
--  RST            |
-- ----------------+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DREGISTER_ENT IS
PORT( CLK, ENA, RST : IN STD_LOGIC;
      D             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      Q             : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) );
END ENTITY DREGISTER_ENT;

ARCHITECTURE DREGISTER_ARCH OF DREGISTER_ENT IS

BEGIN
    P1 : PROCESS(RST, CLK)
    BEGIN
        IF (RST = '0') THEN
-- SYNC ASYNC RESET EVENTS
--            Q <= X"00";
            Q <= (OTHERS => '0');
        ELSIF (CLK'EVENT) AND (CLK = '1') THEN
-- ALTERNATIVELY (ALTERA):
--  ELSIF RISING_EDGE(CLK) THEN
            IF (ENA = '1') THEN
                Q <= D;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE DREGISTER_ARCH;

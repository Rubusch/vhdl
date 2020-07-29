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

ENTITY DREGISTER IS
GENERIC( NBITS : INTEGER := 8 );
PORT( CLK, ENA, RST : IN STD_LOGIC;
      D : IN STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);
      Q : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) );
END ENTITY DREGISTER;

ARCHITECTURE DREGISTER_ARCH OF DREGISTER IS

BEGIN
    P1 : PROCESS(RST, CLK)
    BEGIN
        IF (RST = '1') THEN
            Q <= (OTHERS => '0');
        ELSIF (CLK'EVENT) AND (CLK = '1') THEN
            IF (ENA = '1') THEN
                Q <= D;
            END IF;
        ELSE
            NULL;
        END IF;
    END PROCESS;
END ARCHITECTURE DREGISTER_ARCH;

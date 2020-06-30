--                                                                                                                      
--  A[3..0] +----------+
--  --------| QUAD     | C[3..0]
--  B[3..0] | 2-INPUT  |-------->
--  --------| MUX      |
--          +----------+
--              A
--              |
--  SEL --------+
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY QUADMUX_ENT IS
PORT( A   IN : STD_LOGIC_VECTOR(3 DOWNTO 0)
	; B   IN : STD_LOGIC_VECTOR(3 DOWNTO 0)
	; SEL IN : STD_LOGIC
	; C  OUT : STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END ENTITY QUADMUX_ENT;

ARCHITECTURE QUADMUX_ARCH OF QUADMUX_ENT IS

BEGIN
	C <= A WHEN SEL = '0' ELSE B;

--	WITH SEL SELECT
--	C <= A WHEN '0',
--		 B WHEN OTHERS;
END ARCHITECTURE QUADMUX_ARCH;

--
--             +-------------+
-- data[3..0]  | seven       | seg[6..0]
-- ------/---->| seg display |---/--->
--             | controller  |
--             +-------------+
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SEVENSEG_ENT IS
PORT( DATA : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	SEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END ENTITY SEVENSEG_ENT;

ARCHITECTURE SEVENSEG_ARCH OF SEVENSEG_ENT IS
BEGIN
	WITH DATA SELECT
		SEG <= "1000000" WHEN "0000",  -- 00
			   "1111001" WHEN "0001",  -- 01
			   "0100100" WHEN "0010",  -- 02
			   "0110000" WHEN "0011",  -- 03
			   "0011001" WHEN "0100",  -- 04
			   "0010010" WHEN "0101",  -- 05
			   "0000010" WHEN "0110",  -- 06
			   "1111000" WHEN "0111",  -- 07
			   "0000000" WHEN "1000",  -- 08
			   "0010000" WHEN "1001",  -- 09
			   "0001000" WHEN "1010",  -- A (10)
			   "0000011" WHEN "1011",  -- B (11)
			   "1000110" WHEN "1100",  -- C (12)
			   "0100001" WHEN "1101",  -- D (13)
			   "0000110" WHEN "1110",  -- E (14)
			   "0001110" WHEN "1111",  -- F (15)
			   "0000110" WHEN OTHERS;  -- 0
END ARCHITECTURE SEVENSEG_ARCH;

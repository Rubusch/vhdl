-- counter adaptation for DE1SoC Board
-- (visual verification)
--
-- Author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DE1SOC_COUNTER IS
GENERIC( NBITS : INTEGER := 32
    ; NLEDS : INTEGER := 10 ); -- setup 32 bit counter
PORT( CLK_50, SW, KEY : IN STD_LOGIC
    ; LEDR : OUT STD_LOGIC_VECTOR(NLEDS-1 DOWNTO 0) := (OTHERS => '0')
);
END DE1SOC_COUNTER;

ARCHITECTURE HW OF DE1SOC_COUNTER IS
    SIGNAL RST : STD_LOGIC;
    SIGNAL COUNT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0');
    ALIAS SELECTION IS COUNT(25 DOWNTO 16); -- filter 10 bit out of 32 bit counter

BEGIN

    COUNTER_UNIT : ENTITY WORK.COUNTER
        GENERIC MAP (NBITS => NBITS)
        PORT MAP (CLK => CLK_50, ENA => SW, RST => RST, COUNT => COUNT);

    -- on the de1soc the key pressed is '0', default is '1'
    RST <= NOT KEY;

    -- wire a filtered selection of the output to the leds
    LEDR <= STD_LOGIC_VECTOR(SELECTION);
END HW;


-- counter adaptation for DE1SoC Board
-- (visual verification)
--
-- Author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY COUNTER_DE1SOC IS
GENERIC( NBITS : INTEGER := 16 );
PORT( CLK_50, SW, KEY : IN STD_LOGIC
    ; LEDR : OUT STD_LOGIC_VECTOR(NBITS-1-6 DOWNTO 0) := (OTHERS => '0')
);
END COUNTER_DE1SOC;

ARCHITECTURE HW OF COUNTER_DE1SOC IS
    SIGNAL RST : STD_LOGIC;
    SIGNAL COUNT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0');
    --(31 DOWNTO 0) := X"00000000";
    ALIAS SELECTION IS COUNT(15 DOWNTO 6);

BEGIN

    COUNTER_UNIT : ENTITY WORK.COUNTER
        GENERIC MAP (NBITS => NBITS)
        PORT MAP (CLK => CLK_50, ENA => SW, RST => RST, COUNT => COUNT);

    -- on the de1soc the key pressed is '0', default is '1'
    RST <= NOT KEY;

    -- wire a filtered selection of the output to the leds
    LEDR <= STD_LOGIC_VECTOR(SELECTION);
END HW;


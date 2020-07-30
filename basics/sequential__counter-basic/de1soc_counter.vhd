-- hw adaptation for DE1SoC Board
-- (visual verification)
--
-- Author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DE1SOC_COUNTER IS
GENERIC( NBITS : INTEGER := 32
    ; NLEDS : INTEGER := 10 ); -- setup 32 bit counter
PORT( CLK_50 : IN STD_LOGIC
    ; SW_ENA : IN STD_LOGIC
    ; KEY_RST : IN STD_LOGIC
    ; LED_COUNT : OUT STD_LOGIC_VECTOR(NLEDS-1 DOWNTO 0) := (OTHERS => '0')
);
END DE1SOC_COUNTER;

ARCHITECTURE DE1SOC OF DE1SOC_COUNTER IS
    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL ENA : STD_LOGIC := '0';
    SIGNAL RST : STD_LOGIC := '0';
    SIGNAL COUNT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0');
    ALIAS SELECTION IS COUNT(25 DOWNTO 16); -- filter 10 bit out of 32 bit counter

BEGIN

    COUNTER_UNIT : ENTITY WORK.COUNTER
        GENERIC MAP (NBITS => NBITS)
        PORT MAP (CLK => CLK, ENA => ENA, RST => RST, COUNT => COUNT);

    CLK <= CLK_40
    ENA <= SW_ENA;
    -- on the de1soc the key pressed is '0', default is '1'
    RST <= NOT KEY_RST;

    -- wire a filtered selection of the output to the leds
    LED_COUNT <= STD_LOGIC_VECTOR(SELECTION);
END DE1SOC;


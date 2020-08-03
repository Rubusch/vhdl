-- tb: mealy and more state machines, edge detector example
--
-- author: Lothar Rubusch (pls, find original in Meher Krishna Patel's Edge Detector Example)
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DE1SOC_MEALYANDMOORE IS
PORT( CLK50 : IN STD_LOGIC
    ; SW : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    ; LED : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END DE1SOC_MEALYANDMOORE;

ARCHITECTURE DE1SOC OF DE1SOC_MEALYANDMOORE IS
    SIGNAL CLK_PULSE : STD_LOGIC := '0';

BEGIN

    CLOCK_UNIT : ENTITY WORK.CLOCKSCALER
        GENERIC MAP (MODULO => 50000000, NBITS => 26)
        PORT MAP (CLK => CLK50, RST => RST, PULSE => CLK_PULSE);

    MEALYANDMOORE_UNIT : ENTITY WORK.MEALYANDMOORE
        PORT MAP (CLK => CLK_PULSE, RST => RST, LEVEL => SW(1), MOORE_TICK => LED(0), MEALY_TICK => LED(1));
END DE1SOC;

-- DE1SOC hw adapter
--
-- author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DE1SOC_CLOCKSCALER IS
PORT( CLK50 : IN STD_LOGIC
    ; KEY_RST : IN STD_LOGIC
    ; LED_PULSE : OUT STD_LOGIC
);
END DE1SOC_CLOCKSCALER;

ARCHITECTURE DE1SOC OF DE1SOC_CLOCKSCALER IS
    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL RST : STD_LOGIC := '0';
    SIGNAL PULSE : STD_LOGIC := '0';

BEGIN

    CLOCKSCALER_UNIT : ENTITY WORK.CLOCKSCALER
--        GENERIC MAP (NBITS => 4, MODULO => 16) -- this will show a glimming led, while the 'orig setting', 1 pulse in 0.1 s shows a dark led (too short)
        PORT MAP (CLK => CLK, RST => RST, PULSE => PULSE);

    -- IN
    CLK <= CLK50;
    RST <= NOT KEY_RST;

    -- OUT
    LED_PULSE <= PULSE;
END DE1SOC;

-- de1soc: hw adaptation for serial parallel converter via shifter
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK; -- TODO needed?

ENTITY DE1SOC_CONVERTER IS
GENERIC( NBITS : INTEGER := 4
);
PORT( CLK50 : IN STD_LOGIC
    ; KEY_RST : IN STD_LOGIC
    ; LED_DATA_IN : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
    ; LED_DATA_OUT : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
);
END DE1SOC_CONVERTER;

ARCHITECTURE DE1SOC OF DE1SOC_CONVERTER IS
    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL RST : STD_LOGIC := '0';

BEGIN

    RST <= NOT KEY_RST;

    -- parallel and serial conversion
    CONVERTER_UNIT : ENTITY WORK.CONVERTER
        GENERIC MAP (MODULO => 7, NBITS => NBITS)
        PORT MAP (CLK => CLK, RST => RST, DATA_IN => LED_DATA_IN, DATA_OUT => LED_DATA_OUT);

    -- clock tick to see outputs on LEDs
    CLOCKSCALER_UNIT : ENTITY WORK.CLOCKSCALER
        GENERIC MAP (MODULO => 5000000, NBITS => 23)
        PORT MAP (CLK => CLK50, RST => RST, PULSE => CLK);
END DE1SOC;

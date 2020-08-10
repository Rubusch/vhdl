-- de1soc: hw adaptation for ROM - block ROM demo (active high)
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DE1SOC_BLOCKROM IS
PORT( SW : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    ; HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    ; LED : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END DE1SOC_BLOCKROM;

ARCHITECTURE DE1SOC OF DE1SOC_BLOCKROM IS
    -- signal to store received data, so that it can be displayed on
    -- two devices i.e. seven seg display and LEDs
    SIGNAL DATA : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    BLOCKROM_UNIT : ENTITY WORK.BLOCKROM
        PORT MAP (ADDR => SW, DATA => DATA);

    HEX0 <= DATA;
    LED <= DATA;
END DE1SOC;

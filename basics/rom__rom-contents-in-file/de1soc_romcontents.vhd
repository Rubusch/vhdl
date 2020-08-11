-- de1soc: hw adater for block ROM using .mif file
--
-- NOTE: THIS CODE IS ALTERA SPECIFIC
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DE1SOC_ROMCONTENTS IS
GENERIC(ADDR_BITS : INTEGER := 4        -- requred bits to store ADDR_WIDTH number of elements
    ; DATA_WIDTH : INTEGER := 7       -- each element has DATA_WIDTH number of bits
);
PORT( SW_ADDR : IN STD_LOGIC_VECTOR(ADDR_BITS-1 DOWNTO 0)
    ; HEX : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
    ; LED : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
);
END DE1SOC_ROMCONTENTS;

ARCHITECTURE DE1SOC OF DE1SOC_ROMCONTENTS IS
    -- signal to store and receive data, so that it can be displayed on
    -- two devices i.e. seven segdisplays or LEDs
    SIGNAL DATA : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

    ROM_UNIT : ENTITY ROM
        PORT MAP (ADDR => SW_ADDR, DATA => DATA);
END DE1SOC;

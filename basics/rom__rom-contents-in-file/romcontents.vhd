-- ROM - block ROM using .mif file
--
-- NOTE: THIS CODE IS ALTERA SPECIFIC
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ROMCONTENTS IS
GENERIC( ADDR_WIDTH : INTEGER := 16   -- store 16 elements
    ; ADDR_BITS : INTEGER := 4        -- requred bits to store ADDR_WIDTH number of elements
    ; DATA_WIDTH : INTEGER := 7       -- each element has DATA_WIDTH number of bits
);
PORT( ADDR : IN STD_LOGIC_VECTOR(ADDR_BITS-1 DOWNTO 0)
    ; DATA : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
);
END ROMCONTENTS;

ARCHITECTURE ROMCONTENTS_ARCH OF ROMCONTENTS IS
    TYPE ROM_TYPE : IS ARRAY(ADDR_WIDTH-1 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    SIGNAL ROM : ROM_TYPE;

    -- NOTE: RAM_INIT_FILE is not the user-defined name (but the attribute name)
    ATTRIBUTE RAM_INIT_FILE : STRING;

    -- romcontents.mif is the relative address with respect to project directory
    -- suppose ".mif" file is saved in folder "ROM", then use "ROM/romcontents.mif"
    ATTRIBUTE RAM_INIT_FILE OF ROM : SIGNAL IS "romcontents.mif";

BEGIN

    DATA <= ROM(TO_INTEGER(UNSIGNED(ADDR)));
END ROMCONTENTS_ARCH;

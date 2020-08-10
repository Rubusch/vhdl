-- ROM - block ROM demo (active high)
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY LOGICCELLSROM IS
GENERIC( ADDR_WIDTH : INTEGER := 16  -- store 16 elements
    ; ADDR_BITS : INTEGER := 4       -- required bits to store 16 elements
    ; DATA_WIDTH : INTEGER := 7      -- each element has 7 bits
);
PORT( ADDR : IN STD_LOGIC_VECTOR(ADDR_BITS-1 DOWNTO 0)
    ; DATA : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
);
END LOGICCELLSROM;

ARCHITECTURE LOGICCELLSROM_ARCH OF LOGICCELLSROM IS
    TYPE ROM_TYPE IS ARRAY(0 TO ADDR_WIDTH-1) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    CONSTANT SEVENSEG_ROM : ROM_TYPE := ( "1000000" -- 00
        , "1111001"                               -- 01
        , "0100100"                               -- 02
        , "0110000"                               -- 03
        , "0011001"                               -- 04
        , "0010010"                               -- 05
        , "0000010"                               -- 06
        , "1111000"                               -- 07
        , "0000000"                               -- 08
        , "0010000"                               -- 09
        , "0001000"                               -- A (10)
        , "0000011"                               -- B (11)
        , "1000110"                               -- C (12)
        , "0100001"                               -- D (13)
        , "0000110"                               -- E (14)
        , "0001110"                               -- F (15)
        , "0000110"                               -- 0
    );

BEGIN

    DATA <= SEVENSEG_ROM(TO_INTEGER(UNSIGNED(ADDR)));
END LOGICCELLSROM_ARCH;

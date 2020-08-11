-- vga sync
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY VGASYNC IS
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; HSYNC : OUT STD_LOGIC
    ; VSYNC : OUT STD_LOGIC
    ; VIDEO_ON : OUT STD_LOGIC
    ; VGA_CLK : OUT STD_LOGIC
    ; PIXEL_X : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    ; PIXEL_Y : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
);
END VGASYNC;

ARCHITECTURE VGASYNC_ARCH OF VGASYNC IS
    -- vga 640 x 480
    CONSTANT HD : INTEGER := 640; -- horizontal display area
    CONSTANT VD : INTEGER := 480; -- vertical display area

    -- 
BEGIN

END VGASYNC_ARCH;

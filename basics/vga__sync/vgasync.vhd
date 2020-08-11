-- vga sync
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY VGASYNC IS
GENERIC( PIXEL_WIDTH : INTEGER := 10 );
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; HSYNC : OUT STD_LOGIC
    ; VSYNC : OUT STD_LOGIC
    ; VIDEO_ON : OUT STD_LOGIC
    ; VGA_CLK : OUT STD_LOGIC
    ; PIXEL_X : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
    ; PIXEL_Y : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
);
END VGASYNC;

ARCHITECTURE VGASYNC_ARCH OF VGASYNC IS
    -- vga 640 x 480
    CONSTANT HD : INTEGER := 640; -- horizontal display area
    CONSTANT VD : INTEGER := 480; -- vertical display area

    -- horizontal and vertical retraces
    CONSTANT HR : INTEGER := 100; -- horizontal retrace
    CONSTANT VR : INTEGER := 10;  -- vertical retrace

    -- 25 MHz VGA clock
    SIGNAL VGA_TICK : STD_LOGIC;

    -- pixel location
    SIGNAL H_PIXEL : UNSIGNED(PIXEL_WIDTH-1 DOWNTO 0);
    SIGNAL H_PIXEL_NEXT : UNSIGNED(PIXEL_WIDTH-1 DOWNTO 0);
    SIGNAL V_PIXEL : UNSIGNED(PIXEL_WIDTH-1 DOWNTO 0);
    SIGNAL V_PIXEL_NEXT : UNSIGNED(PIXEL_WIDTH-1 DOWNTO 0);

    -- store location of screen-ends for retracing operation
    SIGNAL H_END : STD_LOGIC;
    SIGNAL V_END : STD_LOGIC;

BEGIN

    -- 25 MHz clock for VGA operations
    CLOCK_25MHZ_UNIT : ENTITY WORK.CLOCKSCALER
        GENERIC MAP (MODULO => 2, NBITS => 2)
        PORT MAP (CLK => CLK, RST => RST, PULSE => VGA_TICK);

    -- reset pixel location
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            V_PIXEL <= (OTHERS => '0');
            H_PIXEL <= (OTHERS => '0');
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            V_PIXEL <= V_PIXEL_NEXT;
            H_PIXEL <= H_PIXEL_NEXT;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    -- TODO
END VGASYNC_ARCH;

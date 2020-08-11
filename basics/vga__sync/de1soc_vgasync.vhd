-- de1soc: hw adapter for vga sync
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DE1SOC_VGASYNC IS
GENERIC( PIXEL_WIDTH : INTEGER := 10 );
PORT( CLK50 : IN STD_LOGIC
    ; KEY_RST : IN STD_LOGIC
    ; SW : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
    ; VGA_CLK : OUT STD_LOGIC
    ; VGA_BLANK : OUT STD_LOGIC
    ; VGA_HS : OUT STD_LOGIC
    ; VGA_VS : OUT STD_LOGIC
    ; VGA_R : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
    ; VGA_G : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
    ; VGA_B : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
);
END DE1SOC_VGASYNC;

ARCHITECTURE DE1SOC OF DE1SOC_VGASYNC IS
    SIGNAL RGB_REG : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL VIDEO_ON : STD_LOGIC := '0';
    SIGNAL RST : STD_LOGIC := '0';

BEGIN

    RST <= NOT KEY_RST;

    -- set VGA_BLANK to 1
    VGA_BLANK <= '1';

    -- instantiate SYNC_VGA for synchronization
    VGASYNC_UNIT : ENTITY WORK.VGASYNC
        PORT MAP (CLK => CLK50, RST => RST, HSYNC => VGA_HS, VSYNC => VGA_VS, VIDEO_ON => VIDEO_ON, VGA_CLK => VGA_CLK, PIXEL_X => OPEN);

    -- read, switch and store in RGB_REG
    PROCESS(CLK50, RST)
    BEGIN
        IF (RST = '1') THEN
            RGB_REG <= (OTHERS => '0');
        ELSE
            RGB_REG <= SW;
        END IF;
    END PROCESS;

    -- send MSB of RGB_REG to all the 10 bits of VGA_R
    -- repeat it for VGA_G and VGA_B with RGB_REG(1) and RGB_REG(0) respectively
    VGA_R <= (OTHERS => RGB_REG(2)) WHEN VIDEO_ON = '1' ELSE (OTHERS => '0');
    VGA_G <= (OTHERS => RGB_REG(1)) WHEN VIDEO_ON = '1' ELSE (OTHERS => '0');
    VGA_B <= (OTHERS => RGB_REG(0)) WHEN VIDEO_ON = '1' ELSE (OTHERS => '0');

END DE1SOC;

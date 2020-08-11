-- testscreen: display four squares of different color on the screen
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DE1SOC_TESTSCREEN IS
GENERIC( PIXEL_WIDTH : INTEGER := 10 );
PORT( CLK50 : IN STD_LOGIC
    ; KEY_RST : IN STD_LOGIC
    ; VGA_CLK : OUT STD_LOGIC
    ; VGA_BLANK_N : OUT STD_LOGIC
    ; VGA_HS : OUT STD_LOGIC
    ; VGA_VS : OUT STD_LOGIC
    ; VGA_R : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
    ; VGA_G : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
    ; VGA_B : OUT STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0)
);
END DE1SOC_TESTSCREEN;

ARCHITECTURE DE1SOC OF DE1SOC_TESTSCREEN IS
    SIGNAL RGB_REG : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL VIDEO_ON : STD_LOGIC := '0';
    SIGNAL PIXEL_X : STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PIXEL_Y : STD_LOGIC_VECTOR(PIXEL_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PIX_X : INTEGER := 0;
    SIGNAL PIX_Y : INTEGER := 0;
    SIGNAL RST : STD_LOGIC := '0';
    SIGNAL CLK : STD_LOGIC := '0';

BEGIN

    CLK <= CLK50;
    RST <= NOT KEY_RST;

    -- set VGA_BLANK to 1
    VGA_BLANK <= '1';

    -- VGASYNC for synchronization
    VGASYNC_UNIT : ENTITY WORK.VGASYNC
        PORT MAP (CLK => CLK
        , RST => RST
        , HSYNC => VGA_HS
        , VSYNC => VGA_VS
        , VIDEO_ON => VIDEO_ON
        , VGA_CLK => VGA_CLK
        , PIXEL_X => PIXEL_X
        , PIXEL_Y => PIXEL_Y);

    PIX_X <= TO_INTEGER(UNSIGNED(PIXEL_X));
    PIX_Y <= TO_INTEGER(UNSIGNED(PIXEL_Y));

    PROCESS(CLK)
    BEGIN
        IF (VIDEO_ON = '1') THEN
            -- divide VGA screen i.e. 640x480 in four equal parts, and display different colors in each
            -- 640 / 2 == 320
            -- 480 / 2 == 240

            IF (PIX_X < 320 AND PIX_Y < 240) THEN
                -- red color
                VGA_R <= (OTHERS => '1');
                VGA_G <= (OTHERS => '0');
                VGA_B <= (OTHERS => '0');

            ELSIF (PIX_X >= 320 AND PIX_Y < 240) THEN
                -- green color
                VGA_R <= (OTHERS => '0');
                VGA_G <= (OTHERS => '1');
                VGA_B <= (OTHERS => '0');

            ELSIF (PIX_X > 320 AND PIX_Y >= 240) THEN
                -- blue color
                VGA_R <= (OTHERS => '0');
                VGA_G <= (OTHERS => '0');
                VGA_B <= (OTHERS => '1');

            ELSE
                -- yellow color
                VGA_R <= (OTHERS => '1');
                VGA_G <= (OTHERS => '1');
                VGA_B <= (OTHERS => '1');
            END IF;
        ELSE
            VGA_R <= (OTHERS => '0');
            VGA_G <= (OTHERS => '0');
            VGA_B <= (OTHERS => '0');
        END IF;
    END PROCESS;

END DE1SOC;

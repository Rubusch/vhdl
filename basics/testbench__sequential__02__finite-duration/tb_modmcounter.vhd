-- TB_MODMCOUNTER.VHD
-- finite duration

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL; -- requrie for STD_LOGIC, etc.

ENTITY TB_MODMCOUNTER IS
END TB_MODMCOUNTER;

ARCHITECTURE TB OF TB_MODMCOUNTER IS
    CONSTANT M : INTEGER := 3; -- count up to 2
    CONSTANT N : INTEGER := 4;
    CONSTANT T : TIME := 20 NS;

    SIGNAL CLK, RESET : STD_LOGIC; -- input
    SIGNAL COMPLETE_TICK : STD_LOGIC; -- output
    SIGNAL COUNT : STD_LOGIC_VECTOR(N-1 DOWNTO 0); -- output

    CONSTANT NUM_OF_CLOCKS : INTEGER := 30;
    SIGNAL I : INTEGER := 0; -- loop variable
    FILE OUTPUT_BUF : TEXT; -- TEXT is a reserved word

BEGIN

    MODMCOUNTER_UNIT : ENTITY WORK.MODMCOUNTER
        GENERIC MAP (M => M, N => N)
        PORT MAP (CLK => CLK, RESET => RESET, COMPLETE_TICK => COMPLETE_TICK, COUNT => COUNT);

    -- reset = 1 for first clock cycle, then 0
    RESET <= '1', '0' AFTER T/2;

    -- continuous clock
    PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR T/2;
        CLK <= '1';
        WAIT FOR T/2;

        -- store 30 samples in file
        IF (I = NUM_OF_CLOCKS) THEN
            FILE_CLOSE(OUTPUT_BUF);
            WAIT;
        ELSE
            I <= I + 1;
        END IF;
    END PROCESS;

    -- save data in file : path is relative
    FILE_OPEN(OUTPUT_BUF, "../../tb_results.csv", WRITE_MODE);

    PROCESS(CLK)
        VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE; -- LINE is reserved
    BEGIN
        IF(CLK'EVENT AND CLK = '1' AND RESET /= '1') THEN -- avoid reset data
            -- comment below 'if statement' to avoid header in saved file
            IF (I = 0) THEN
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("CLOCK_TICK,COUNT"));
                WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
            END IF;

            WRITE(WRITE_COL_TO_OUTPUT_BUF, COMPLETE_TICK);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));

            -- note that SIGNED / UNSIGNED values cannot be saved in file,
            -- therefore convert to INTEGER or STD_LOGIC_VECTOR

            -- the following line saves the COUNT in INTEGER format
            WRITE(WRITE_COL_TO_OUTPUT_BUF, TO_INTEGER(UNSIGNED(COUNT)));
            WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
        END IF;
    END PROCESS;
END TB;

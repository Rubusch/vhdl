--
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY TB_DFLIPFLOP IS
END TB_DFLIPFLOP;

ARCHITECTURE TB OF TB_DFLIPFLOP IS
    CONSTANT T : TIME := 20 NS;

    SIGNAL CLK, RST : STD_LOGIC;
    SIGNAL D : STD_LOGIC := '0';
    SIGNAL Q : STD_LOGIC := '0';
    SIGNAL Q_EXPECTED : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0111111100";

    CONSTANT NUM_OF_CLOCKS : INTEGER := 30;
    SIGNAL I : INTEGER := 0;
    FILE OUTPUT_BUF : TEXT;

BEGIN

    DFLIPFLOP_UNIT : ENTITY WORK.DFLIPFLOP
        PORT MAP (CLK => CLK, RST => RST, D => D, Q => Q);

    RST <= '1', '0' AFTER T/2;

    -- continuous clock
    PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR T/2;
        CLK <= '1';
        WAIT FOR T/2;
        IF (I = NUM_OF_CLOCKS) THEN
            FILE_CLOSE(OUTPUT_BUF);
            WAIT;
        ELSE
            I <= I + 1;
        END IF;

        -- testcase: now change content
        IF (I = 7) THEN
            D <= '0';
        ELSE
            D <= '1';
        END IF;
    END PROCESS;

    FILE_OPEN(OUTPUT_BUF, "../../tb_result.csv", WRITE_MODE);

    PROCESS(CLK)
        VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE;
    BEGIN
        IF (CLK'EVENT AND CLK = '1' AND RST /= '1') THEN
            IF (I = 0) THEN
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("D,Q,Q_EXPECTED"));
                WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
            END IF;
            WRITE(WRITE_COL_TO_OUTPUT_BUF, D);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, Q);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, Q_EXPECTED(I));
            WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
        END IF;
    END PROCESS;
END TB;

-- testbench: counter (with enable)
--
-- Author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY TB_COUNTER IS
END TB_COUNTER;

ARCHITECTURE TB OF TB_COUNTER IS
    CONSTANT T : TIME := 20 NS;
    CONSTANT NBITS : INTEGER := 10;
    CONSTANT NCLKS : INTEGER := 30;
    SIGNAL I : INTEGER := 0;

    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL RST : STD_LOGIC := '0';
    SIGNAL ENA : STD_LOGIC := '0';
    SIGNAL COUNT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0');

    FILE OUTPUT_BUF : TEXT;

BEGIN

    COUNTER_UNIT : ENTITY WORK.COUNTER
        GENERIC MAP (NBITS => NBITS)
        PORT MAP (CLK => CLK, ENA => ENA, RST => RST, COUNT => COUNT);

    PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR T/2;
        CLK <= '1';
        WAIT FOR T/2;
        IF (I = NCLKS) THEN
            FILE_CLOSE(OUTPUT_BUF);
            WAIT;
        ELSE
            I <= I + 1;
        END IF;

        -- testcase: enable
        IF (I >= 3 AND I < 7) THEN
            ENA <= '0';
        ELSE
            ENA <= '1';
        END IF;
    END PROCESS;

    RST <= '1', '0' AFTER T/2;

    FILE_OPEN(OUTPUT_BUF, "../../tb_results.csv", WRITE_MODE);

    PROCESS(CLK)
        VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE;
    BEGIN
        IF (CLK'EVENT AND CLK = '1' AND RST /= '1') THEN
            IF (I = 0) THEN
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("RST,ENA,COUNT"));
                WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
            END IF;
            WRITE(WRITE_COL_TO_OUTPUT_BUF, RST);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, ENA);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, COUNT);
            WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
        END IF;
    END PROCESS;
END TB;

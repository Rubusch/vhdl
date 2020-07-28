-- testbench: fsm
--
-- author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY TB_FSM IS
END TB_FSM;

ARCHITECTURE TB OF TB_FSM IS
    CONSTANT T : TIME := 20 NS;
    CONSTANT NCLK : INTEGER := 30;
    SIGNAL I : INTEGER := 0;

    FILE OUTPUT_BUF : TEXT;

    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL RST : STD_LOGIC := '0';
    SIGNAL KEY : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL LED : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

BEGIN
    FSM_UNIT : ENTITY WORK.FSM
        PORT MAP (CLK => CLK, RST => RST, KEY => KEY, LED => LED);

    PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR T/2;
        CLK <= '1';
        WAIT FOR T/2;
        IF (I = NCLK) THEN
            FILE_CLOSE(OUTPUT_BUF);
            WAIT;
        ELSE
            I <= I + 1;
        END IF;

        IF (I = 2) THEN
            KEY <= "001";
        ELSIF (I = 4) THEN
            KEY <= "010";
        ELSIF (I = 6) THEN
            KEY <= "100";
        ELSE
            KEY <= "000";
        END IF;
    END PROCESS;

    RST <= '1', '0' AFTER T/2;

    FILE_OPEN(OUTPUT_BUF, "../../tb_result.csv", WRITE_MODE);

    PROCESS(CLK)
        VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE;
    BEGIN
        IF (CLK'EVENT AND CLK = '1' AND RST /= '1') THEN
            IF (I = 0) THEN
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("RST,KEY,LED"));
                WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
            END IF;
            WRITE(WRITE_COL_TO_OUTPUT_BUF, RST);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, KEY);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, LED);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
        END IF;
    END PROCESS;
END TB;

-- testbench for d-flipflop demo with ENA and QBAR
--
-- author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY TB_DREGISTER IS
END TB_DREGISTER;

ARCHITECTURE TB OF TB_DREGISTER IS
    CONSTANT T : TIME := 20 NS;
    CONSTANT NUM_OF_CLOCKS : INTEGER := 30;
    SIGNAL I : INTEGER := 0;

    FILE OUTPUT_BUF : TEXT;

    CONSTANT NBITS : INTEGER := 8;
    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL ENA : STD_LOGIC := '0';
    SIGNAL RST : STD_LOGIC := '0';
    SIGNAL D : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Q : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Q_EXPECT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0) := (others => '0');

BEGIN

    DREGISTER_UNIT : ENTITY WORK.DREGISTER
        GENERIC MAP (NBITS => NBITS)
        PORT MAP (CLK => CLK, ENA => ENA, RST => RST, D => D, Q => Q);

    RST <= '1', '0' AFTER T/2;

    -- continues clock
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

        -- test: ENA
        IF (I < 5) THEN
            ENA <= '0';
        ELSE
            ENA <= '1';
        END IF;

        -- test: input, D
        IF (I < 7) THEN
            D <= "00000000";
        ELSE
            D <= "11111111";
        END IF;
        IF (I > 7) THEN -- NB: for verification (I>7) is the opposite of (I<7), i.e. the equals case (I=7) is consumed by the delayed init
            Q_EXPECT <= "11111111";
        END IF;
    END PROCESS;

    FILE_OPEN(OUTPUT_BUF, "../../tb_results.csv", WRITE_MODE);

    PROCESS(CLK)
        VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE;
    BEGIN
        IF (CLK'EVENT AND CLK = '1' AND RST /= '1') THEN
            IF (I = 0) THEN
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("ENA,RST,D,Q,Q_EXPECT"));
                WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
            END IF;
            WRITE(WRITE_COL_TO_OUTPUT_BUF, ENA);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, RST);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, D);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, Q);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, Q_EXPECT);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
        END IF;
    END PROCESS;
END TB;

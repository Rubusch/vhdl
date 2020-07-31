-- HALFADDER_TB.VHD

-- Features included in this code are
    -- inputs are read from csv file, which stores the desired outputs as well
    -- outputs are written to csv file
    -- actual output and calculated outputs are compared
    -- Error message is displayed in the file
    -- header line is skipped while reading the csv file

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL; -- read/write STD_LOGIC, etc.

ENTITY TB_HALFADDER IS
END TB_HALFADDER;

ARCHITECTURE TB OF TB_HALFADDER IS
    SIGNAL A, B : STD_LOGIC;
    SIGNAL SUM_ACTUAL, CARRY_ACTUAL : STD_LOGIC;
    SIGNAL SUM, CARRY : STD_LOGIC; -- generated results by half-adder

    -- buffer for storing data for i/o
    FILE INPUT_BUF : TEXT;
    FILE OUTPUT_BUF : TEXT;

BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY WORK.HALFADDER
        PORT MAP (A => A, B=> B, SUM => SUM, CARRY => CARRY);

    TB1 : PROCESS
        VARIABLE READ_COL_FROM_INPUT_BUF : LINE; -- read lines from INPUT_BUF
        VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE; -- write lines to OUTPUT_BUF
        VARIABLE VAL_A, VAL_B : STD_LOGIC;
        VARIABLE VAL_SUM, VAL_CARRY : STD_LOGIC;
        VARIABLE VAL_SEPARATOR : CHARACTER; -- for commas between data in file
        VARIABLE GOOD_NUM : BOOLEAN;
    BEGIN
        -- READING DATA
        -- prefer relative path
        FILE_OPEN(INPUT_BUF, "../../tb_input.csv", READ_MODE);
        -- alternatively provide absolute path
--        FILE_OPEN(INPUT_BUF, "/media/user/develop/github__vhdl/basics/testbench__combinational__06__csv-file/tb_input.csv", READ_MODE);

        FILE_OPEN(OUTPUT_BUF, "../../result.csv", WRITE_MODE);
--        FILE_OPEN(OUTPUT_BUF, "/media/user/develop/github__vhdl/basics/testbench__combinational__06__csv-file/tb_input.csv", WRITE_MODE);

        WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("#A,B,SUM_ACTUAL,SUM,CARRY_ACTUAL,CARRY,SUM_TEST_RESULTS,CARRY_TEST_RESULTS"));
        WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
        
        WHILE NOT ENDFILE(INPUT_BUF) LOOP
            READLINE(INPUT_BUF, READ_COL_FROM_INPUT_BUF);
            READ(READ_COL_FROM_INPUT_BUF, VAL_A, GOOD_NUM);
            NEXT WHEN NOT GOOD_NUM; -- i.e. skip the header lines

            READ(READ_COL_FROM_INPUT_BUF, VAL_SEPARATOR); -- read separator
            READ(READ_COL_FROM_INPUT_BUF, VAL_B, GOOD_NUM);
            ASSERT GOOD_NUM
                REPORT "bad value assigned to VAL_B";

            READ(READ_COL_FROM_INPUT_BUF, VAL_SEPARATOR); -- read separator
            READ(READ_COL_FROM_INPUT_BUF, VAL_SUM);
            READ(READ_COL_FROM_INPUT_BUF, VAL_SEPARATOR); -- read separator
            READ(READ_COL_FROM_INPUT_BUF, VAL_CARRY);

            -- PASS THE VARIABLE TO A SIGNAL TO ALLOW THE RIPPLE CARRY TO USE IT
            A <= VAL_A;
            B <= VAL_B;
            SUM_ACTUAL <= VAL_SUM;
            CARRY_ACTUAL <= VAL_CARRY;

            WAIT FOR 20 NS;

            WRITE(WRITE_COL_TO_OUTPUT_BUF, A);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, B);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, SUM_ACTUAL);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, SUM);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, CARRY_ACTUAL);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            WRITE(WRITE_COL_TO_OUTPUT_BUF, CARRY);
            WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));

            -- DISPLAY ERROR OR OK DEPENDING ON SUM
            IF (SUM_ACTUAL /= SUM) THEN
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("ERROR,"));
            ELSE
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(","));
            END IF;

            -- DISPLAY ERROR OR OK DEPENDING ON CARRY
            IF (CARRY_ACTUAL /= CARRY) THEN
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("ERROR,"));
            ELSE
                WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("OK,"));
            END IF;

            WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF);
        END LOOP;

        FILE_CLOSE(INPUT_BUF);
        FILE_CLOSE(OUTPUT_BUF);
        WAIT;

    END PROCESS;
END TB;

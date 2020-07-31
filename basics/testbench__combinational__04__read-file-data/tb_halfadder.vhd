-- HALFADDER_TB.VHD
--
-- IMPORTANT: DON'T FORGET TO ADD tb_input.txt TO THE PROJECT!!!

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL; -- require for writing/reading std_logic etc.

ENTITY TB_HALFADDER IS
END TB_HALFADDER;

ARCHITECTURE TB OF TB_HALFADDER IS
    SIGNAL A, B : STD_LOGIC;       -- inputs
    SIGNAL C : STD_LOGIC_VECTOR(1 DOWNTO 0); -- NEW: output here as STD_LOGIC_VECTOR

    -- buffer for storing the text from input read-file
    FILE INPUT_BUF : TEXT; -- TEXT is a reserved word!!!

BEGIN

    TB1 : PROCESS
        VARIABLE READ_COL_FROM_INPUT_BUF : LINE;           -- reads lines one by one from INPUT_BUF
        VARIABLE VAL_COL1, VAL_COL2 : STD_LOGIC;           -- to save COL1 and COL2 values of 1 bit
        VARIABLE VAL_COL3 : STD_LOGIC_VECTOR(1 DOWNTO 0);  -- to save COL3 value of 2 bit
        VARIABLE VAL_SPACE : CHARACTER;                    -- for spaces between data in file

    BEGIN

        -- if ModelSim project is created, then provide the relative path of the input file
        -- (i.e. tb_input.txt) with respect to main project folder
        FILE_OPEN(INPUT_BUF, "../../tb_input.txt", READ_MODE);
        -- else provide the complete path for the input file as shown below
--        FILE_OPEN(INPUT_BUF, "/media/user/develop/github__vhdl/basics/testbench__combinational__04__read-file-data/tb_input.txt", READ_MODE);

        WHILE NOT ENDFILE(INPUT_BUF) LOOP
            READLINE(INPUT_BUF, READ_COL_FROM_INPUT_BUF);
            READ(READ_COL_FROM_INPUT_BUF, VAL_COL1);
            READ(READ_COL_FROM_INPUT_BUF, VAL_SPACE);      -- read in space character
            READ(READ_COL_FROM_INPUT_BUF, VAL_COL2);
            READ(READ_COL_FROM_INPUT_BUF, VAL_SPACE);      -- read in space character
            READ(READ_COL_FROM_INPUT_BUF, VAL_COL3);

            -- pass the read values to signals
            A <= VAL_COL1;
            B <= VAL_COL2;
            C <= VAL_COL3;
            WAIT FOR 20 NS; -- display results every 20ns
        END LOOP;
        FILE_CLOSE(INPUT_BUF);
        WAIT;
    END PROCESS;
END TB;

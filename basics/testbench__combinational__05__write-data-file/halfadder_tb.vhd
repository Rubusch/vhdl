-- HALFADDER_TB.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL; -- writing STD_LOGIC etc.

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
    SIGNAL A : STD_LOGIC;

    FILE OUTPUT_BUF : TEXT; -- TEXT is a reserved word

BEGIN

    TB1 : PROCESS
    VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE; -- LINE is a reserved word
    VARIABLE B : INTEGER := 40;

    BEGIN

        A <= '1'; -- assign value to A
        WAIT FOR 20 NS;

        -- if ModelSim project is created, provide the relative path
        FILE_OPEN(OUTPUT_BUF, "../../data.out", WRITE_MODE);
        -- else provide the absolute path
--        FILE_OPEN(OUTPUT_BUF, "/media/user/develop/github__vhdl/basics/testbench__combinational__05__write-data-file/data.out", WRITE_MODE);

        WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("printing values"));
        WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF); -- write in line 1

        WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("A = "));
        WRITE(WRITE_COL_TO_OUTPUT_BUF, A);
        WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'(", B = "));
        WRITE(WRITE_COL_TO_OUTPUT_BUF, B);
        WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF); -- write in line 2

        WRITE(WRITE_COL_TO_OUTPUT_BUF, STRING'("THANX"));
        WRITELINE(OUTPUT_BUF, WRITE_COL_TO_OUTPUT_BUF); -- write in line 3

        FILE_CLOSE(OUTPUT_BUF);
        WAIT; -- indefinitely suspend process
    END PROCESS;
END TB;

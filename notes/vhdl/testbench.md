# Testbenches

## RESOURCES

My ModelSim notes are taken and copied from my masters course projects, and based on the following ressources.  

Please, when learning VHDL or for getting a thorough understanding, have a look on the linked pages below.   

https://vhdlguide.readthedocs.io/en/latest/vhdl/testbench.html


## COMBINATIONAL

example half-adder as combinational circuit  

```vhdl
-- HALFADDER.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HALFADDER_ENT IS
PORT( A, B : IN STD_LOGIC
    ; SUM, CARRY : OUT STD_LOGIC
    );
END HALFADDER_ENT;

ARCHITECTURE HALFADDER_ARCH OF HALFADDER_ENT IS
BEGIN
    SUM <= A XOR B;
    CARRY <= A AND B;
END HALFADDER_ARCH;
```


#### COMBINATIONAL: TESTBENCH

in the testbench and provide all the input values in the file  

```vhdl
-- HALFADDER_TB.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
    SIGNAL A, B : STD_LOGIC;       -- inputs
    SIGNAL SUM, CARRY : STD_LOGIC; -- outputs
BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY WORK.HALFADDER_ENT PORT MAP (A => A, B=> B, SUM => SUM, CARRY => CARRY);

    -- inputs
    -- 00 at 0 ns
    -- 01 at 20 ns, as b is 0 at 20 ns and a is changed to 1 at 20 ns
    -- 10 at 40 ns
    -- 11 at 60 ns
    A <= '0', '1' AFTER 20 NS, '0' AFTER 40 NS, '1' AFTER 60 NS;
    B <= '0', '1' AFTER 40 NS;
END TB;
```

In this listing, a testbench with name ``half_adder_simple_tb`` is defined at Lines 7-8. Note that, entity of testbench is always empty i.e. no ports are defined in the entity (see Lines 7-8). Then 4 signals are defined i.e. a, b, sum and carry (Lines 11-12) inside the architecture body; these signals are then connected to actual half adder design using structural modeling (see Line 15). Lastly, different values are assigned to input signals e.g. ‘a’ and ‘b’ at lines 16 and 17 respectively.  

In Line 22, value of ‘a’ is 0 initially (at 0 ns), then it changes to ‘1’ at 20 ns and again changes to ‘0’ at 40 ns (do not confuse with after 40 ns, as after 40 ns is with respect to 0 ns, not with respect to 20 ns). Similarly, the values of ‘a’ becomes ‘0’ and ‘1’ at 40 and 60 ns respectively. In the same way value of ‘b’ is initially ‘0’ and change to ‘1’ at 40 ns at Line 23. In this way 4 possible combination are generated for two bits (‘ab’) i.e. 00, 01, 10 and 11; also corresponding outputs, i.e. sum and carry, are shown in the figure.  

Generation:  
- Compile the project ``Processing`` -> ``Start Compilation``
- Open ModelSim ``Tools`` -> ``Run Simulation Tool`` -> ``RTL Simulation``
- in ModelSim Shell execute the following:
```tcl
ModelSim> vcom -reportprogress 300 -work work /media/user/develop/github__vhdl/basics/testbench__combinational__01/halfadder_tb.vhd
ModelSim> vsim work.halfadder_ent_tb
ModelSim> run
```

Problem: Although, the testbench is very simple, but input patterns are not readable. By using the process statement in the testbench, we can make input patterns more readable along with inclusion of various other features e.g. report generation etc.  


#### COMBINATIONAL: PROCESS STATEMENT

Note that, process statement is written without the sensitivity list.  

```vhdl
-- HALFADDER_TB.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
    SIGNAL A, B : STD_LOGIC;       -- inputs
    SIGNAL SUM, CARRY : STD_LOGIC; -- outputs
BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY WORK.HALFADDER_ENT PORT MAP (A => A, B=> B, SUM => SUM, CARRY => CARRY);

    TB1 : PROCESS
    CONSTANT PERIOD : TIME := 20 NS;
    BEGIN
        A <= '0';
        B <= '0';
        WAIT FOR PERIOD;
        ASSERT ((SUM = '0') AND (CARRY = '0')) --EXPECTED OUTPUT
        -- ERROR WILL BE REPORTED IF SUM OR CARRY IS NOT '0'
            REPORT "TEST FAILED FOR INPUT COMBINATION 00"
            SEVERITY ERROR;

        A <= '0';
        B <= '1';
        WAIT FOR PERIOD;
        ASSERT ((SUM = '1') AND (CARRY = '0'))
            REPORT "TEST FAILED FOR INPUT COMBINATION 01"
            SEVERITY ERROR;

        A <= '1';
        B <= '0';
        WAIT FOR PERIOD;
        ASSERT ((SUM = '1') AND (CARRY = '0'))
            REPORT "TEST FAILED FOR INPUT COMBINATION 10"
            SEVERITY ERROR;

        A <= '1';
        B <= '1';
        WAIT FOR PERIOD;
        ASSERT ((SUM = '0') AND (CARRY = '1'))
            REPORT "TEST FAILED FOR INPUT COMBINATION 11"
            SEVERITY ERROR;

        -- FAIL TEST
        A <= '0';
        B <= '1';
        WAIT FOR PERIOD;
        ASSERT ((SUM = '0') AND (CARRY = '0'))
            REPORT "FAIL TEST (FAIL EXPECTED)"
            SEVERITY ERROR;

        WAIT; -- INDEFINITELY SUSPEND PROCESS
    END PROCESS;
END TB;
```

#### COMBINATIONAL: USING LOOK UP TABLES (LUT)

```vhdl
-- HALFADDER_TB.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
    SIGNAL A, B : STD_LOGIC;       -- inputs
    SIGNAL SUM, CARRY : STD_LOGIC; -- outputs

    -- declare record type
    TYPE TEST_VECTOR IS RECORD
        A, B : STD_LOGIC;
        SUM, CARRY : STD_LOGIC;
    END RECORD;

    -- declare record array based on record type
    TYPE TEST_VECTOR_ARRAY IS ARRAY(NATURAL RANGE <>) OF TEST_VECTOR;

    CONSTANT TEST_VECTORS : TEST_VECTOR_ARRAY := (
    --    a,   b,  sum, carry (positional method is used below)
        ('0', '0', '0', '0'), -- or: (a => '0', b => '0', sum => '0', carry => '0')
        ('0', '1', '1', '0'),
        ('1', '0', '1', '0'),
        ('1', '1', '0', '1'),
        ('0', '1', '0', '1') -- FAIL TEST
    );

BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY WORK.HALFADDER_ENT PORT MAP (A => A, B=> B, SUM => SUM, CARRY => CARRY);

    TB1 : PROCESS
    BEGIN
        FOR I IN TEST_VECTORS'RANGE LOOP
            A <= TEST_VECTORS(I).A;     -- signal a = i^th-row-value of test_vector's a
            B <= TEST_VECTORS(I).B;

            WAIT FOR 20 NS;

            ASSERT ((SUM = TEST_VECTORS(I).SUM) AND (CARRY = TEST_VECTORS(I).CARRY))
                -- IMAGE() is used for string-representation of integer etc.
                REPORT "TEST_VECTOR " & INTEGER'IMAGE(I) & " FAILED " &
                " FOR INPUT A = " & STD_LOGIC'IMAGE(A) &
                " AND B = " & STD_LOGIC'IMAGE(B)
                SEVERITY ERROR;
        END LOOP;
        WAIT;
    END PROCESS;

END TB;
```

*  Define record : First we need to define a record which contains the all the possible columns in the look table. Here, there are four possible columns i.e. a, b, sum and carry, which are defined in record at Lines 15-18.  

*  Create lookup table : Next, we need to define the lookup table values, which is done at Lines 20-28. Here positional method is used for assigning the values to columns (see line 22-27); further, name-association method can also be used as shown in the comment at Line 23.  

*  Assign values to signals : Then the values of the lookup table need to be assigned to half_adder entity (one by one). For this ‘for loop’ is used at line 35, which assigns the values of ‘’test-vector’s ‘a’ and ‘b’ ‘’ to signal ‘a’ and ‘b’ (see comment at Line 36 for better understanding). Similarly, expected values of sum and carry are generated at Lines 41-44. Lastly, report is generated for wrong outputs at Lines 46-50.  


#### COMBINATIONAL: READ DATA FROM FILE

File ``data.txt`` content  

```
0 0 11
0 1 01
1 0 11 
```

```vhdl
-- HALFADDER_TB.VHD
--
-- IMPORTANT: DON'T FORGET TO ADD data.txt TO THE PROJECT!!!

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL; -- require for writing/reading std_logic etc.

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
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
        -- (i.e. data.txt) with respect to main project folder
        FILE_OPEN(INPUT_BUF, "../../data.txt", READ_MODE);
        -- else provide the complete path for the input file as shown below
--        FILE_OPEN(INPUT_BUF, "/media/user/develop/github__vhdl/basics/testbench__combinational__04__read-file-data/data.txt", READ_MODE);

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
```

To read the file, first we need to define a buffer of type ‘text’, which can store the values of the file in it, as shown in Line 17; file is open in read-mode and values are stored in this buffer at Line 32.  

Next, we need to define the variable to read the value from the buffer. Since there are 4 types of values (i.e. a, b, c and spaces) in file ‘read_file_ex.txt’, therefore we need to define 4 variables to store them, as shown in Line 24-26. Since, variable c is of 2 bit, therefore Line 25 is 2-bit vector; further, for spaces, variable of character type is defined at Line 26.  

Then, values are read and store in the variables at Lines 36-42. Lastly, these values are assigned to appropriate signals at Lines 45-47. Finally, file is closed at Line 52.   


#### COMBINATIONAL: WRITE DATA TO FILE

Here, only ``write_mode`` is used for writing the data to file (not the ``append_mode``).  

```vhdl
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
```

To write the data to the file, first we need to define a buffer, which will load the file on the simulation environment for writing the data during simulation, as shown in Line 15 (buffer-defined) and Line 27 (load the file to buffer).  

Next, we need to define a variable, which will store the values to write into the buffer, as shown in Line 19. In the listing, this variable stores three types of value i.e. strings (Lines 31 and 34 etc.), signal ‘a’ (Line 35) and variable ‘b’ (Line 37).  

Note that, two keyword are used for writing the data into the file i.e. ‘write’ and ‘writeline’. ‘write’ keyword store the values in the ‘write_col_to_output_buf’ and ‘writeline’ writes the values in the file. Remember that, all the ‘write’ statements before the ‘writeline’ will be written in same line.  


#### COMBINATIONAL: CSV AS INPUT AND CSV AS OUTPUT

Demo of read and write results to a CSV file.  

```vhdl
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

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
    SIGNAL A, B : STD_LOGIC;
    SIGNAL SUM_ACTUAL, CARRY_ACTUAL : STD_LOGIC;
    SIGNAL SUM, CARRY : STD_LOGIC; -- generated results by half-adder

    -- buffer for storing data for i/o
    FILE INPUT_BUF : TEXT;
    FILE OUTPUT_BUF : TEXT;

BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY WORK.HALFADDER_ENT PORT MAP (A => A, B=> B, SUM => SUM, CARRY => CARRY);

    TB1 : PROCESS
    VARIABLE READ_COL_FROM_INPUT_BUF : LINE; -- read lines from INPUT_BUF
    VARIABLE WRITE_COL_TO_OUTPUT_BUF : LINE; -- write lines to OUTPUT_BUF
    VARIABLE BUF_DATA_FROM_FILE : LINE; -- buffer for storing data from input read-file
    VARIABLE VAL_A, VAL_B : STD_LOGIC;
    VARIABLE VAL_SUM, VAL_CARRY : STD_LOGIC;
    VARIABLE VAL_SEPARATOR : CHARACTER; -- for commas between data in file
    VARIABLE GOOD_NUM : BOOLEAN;
    BEGIN
        -- READING DATA
        -- prefer relative path
        FILE_OPEN(INPUT_BUF, "../../data.csv", READ_MODE);
        -- alternatively provide absolute path
--        FILE_OPEN(INPUT_BUF, "/media/user/develop/github__vhdl/basics/testbench__combinational__06__csv-file/data.csv", READ_MODE);

        FILE_OPEN(OUTPUT_BUF, "../../result.csv", WRITE_MODE);
--        FILE_OPEN(OUTPUT_BUF, "/media/user/develop/github__vhdl/basics/testbench__combinational__06__csv-file/data.csv", WRITE_MODE);

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
```

-  Lines 63-64 are added to skip the header row, i.e. any row which does not start with boolean-number(see line 42).  
-  Also, error will be reported for value ‘b’ if it is not the boolean. Similarly, this functionality can be added to other values as well.  
-  Lastly, errors are reported in CSV file at Lines 96-109.  

Content of data.csv:  

```
$ cat ./testbench__combinational__06__csv-file/data.csv 
#A,B,SUM,CARRY
0,0,0,0
0,1,1,0
1,0,1,0
1,1,0,1
1,0,1,1
1,1,1,1
```

Resulting result.csv

```
$ cat ./testbench__combinational__06__csv-file/result.csv 
#A,B,SUM_ACTUAL,SUM,CARRY_ACTUAL,CARRY,SUM_TEST_RESULTS,CARRY_TEST_RESULTS
0,0,0,0,0,0,,OK,
0,1,1,1,0,0,,OK,
1,0,1,1,0,0,,OK,
1,1,0,0,1,1,,OK,
1,0,1,1,1,0,,ERROR,
```


## SEQUENTIAL

In the case of sequential circuits, we need clock and reset signals; hence two additional blocks are required. Since, clock is generated for complete simulation process, therefore it is defined inside the separate process statement. Whereas, reset signal is required only at the beginning of the operations, hence it is not defined inside the process statement.  

```vhdl
-- MODMCOUNTER.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MODMCOUNTER_ENT IS
GENERIC( M : INTEGER := 5    -- count from 0 to M-1
       ; N : INTEGER := 3    -- N bits required to count up to M, i.e. 2^N >= M
);
PORT( CLK, RESET : IN STD_LOGIC
    ; COMPLETE_TICK : OUT STD_LOGIC
    ; COUNT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END MODMCOUNTER_ENT;

ARCHITECTURE MODMCOUNTER_ARCH OF MODMCOUNTER_ENT IS
    SIGNAL COUNT_REG, COUNT_NEXT : UNSIGNED(N-1 DOWNTO 0);

BEGIN

    PROCESS(CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            COUNT_REG <= (OTHERS => '0');
        ELSIF RISING_EDGE(CLK) THEN
            COUNT_REG <= COUNT_NEXT;
        END IF;
    END PROCESS;

    -- set COUNT_NEXT to 0 when maximum count is reached i.e. M-1
    -- otherwise increase the count
    COUNT_NEXT <= (OTHERS => '0') WHEN COUNT_REG = (M-1) ELSE (COUNT_REG+1);

    -- generate tick on each maximum count
    COMPLETE_TICK <= '1' WHEN COUNT_REG = (M-1) ELSE '0';

    COUNT <= STD_LOGIC_VECTOR(COUNT_REG); -- assign value to output port
END ARCHITECTURE;
```


#### SEQUENTIAL: INFINITE DURATION TESTBENCH

Demo of a Mod-M counter as a sequential example.  

```vhdl
-- modMCounter_tb.vhd

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modMCounter_tb is
end modMCounter_tb;


architecture arch of modMCounter_tb is
    constant M : integer := 10;
    constant N : integer := 4;
    constant T : time := 20 ns; 

    signal clk, reset : std_logic;  -- input
    signal complete_tick : std_logic; -- output
    signal count : std_logic_vector(N-1 downto 0);  -- output
begin

    modMCounter_unit : entity work.modMCounter
        generic map (M => M, N => N)
        port map (clk=>clk, reset=>reset, complete_tick=>complete_tick,
                    count=>count);

    -- continuous clock
    process 
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
    end process;


    -- reset = 1 for first clock cycle and then 0
    reset <= '1', '0' after T/2;

end arch;
```

Here ``clk`` signal is generated in the separate process block i.e. Lines 27-33; in this way, clock signal will be available throughout the simulation process. Further, reset signal is set to ``1`` in the beginning and then set to ``0`` in next clock cycle (Line 37). If there are further, inputs signals, then those signals can be defined in separate process statement, as discussed in combination circuits’ testbenches.  

#### SEQUENTIAL: FINITE DURATION

```vhdl
-- modMCounter_tb2.vhd

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- require for std_logic etc.

entity modMCounter_tb2 is
end modMCounter_tb2;


architecture arch of modMCounter_tb2 is
    constant M : integer := 3;  -- count upto 2 (i.e. 0 to 2)
    constant N : integer := 4;
    constant T : time := 20 ns; 

    signal clk, reset : std_logic;  -- input
    signal complete_tick : std_logic; -- output
    signal count : std_logic_vector(N-1 downto 0);  -- output

    -- total samples to store in file
    constant num_of_clocks : integer := 30; 
    signal i : integer := 0; -- loop variable
    file output_buf : text; -- text is keyword

begin

    modMCounter_unit : entity work.modMCounter
        generic map (M => M, N => N)
        port map (clk=>clk, reset=>reset, complete_tick=>complete_tick,
                    count=>count);


    -- reset = 1 for first clock cycle and then 0
    reset <= '1', '0' after T/2;

    -- continuous clock
    process 
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;

        -- store 30 samples in file
        if (i = num_of_clocks) then
            file_close(output_buf);
            wait;
        else
            i <= i + 1;
        end if;
    end process;


    -- save data in file : path is relative to Modelsim-project directory
    file_open(output_buf, "input_output_files/counter_data.csv", write_mode);
    process(clk)
        variable write_col_to_output_buf : line; -- line is keyword
    begin
        if(clk'event and clk='1' and reset /= '1') then  -- avoid reset data
            -- comment below 'if statement' to avoid header in saved file
            if (i = 0) then 
              write(write_col_to_output_buf, string'("clock_tick,count"));
              writeline(output_buf, write_col_to_output_buf);
            end if; 

            write(write_col_to_output_buf, complete_tick);
            write(write_col_to_output_buf, string'(","));
            -- Note that unsigned/signed values can not be saved in file, 
            -- therefore change into integer or std_logic_vector etc.
             -- following line saves the count in integer format
            write(write_col_to_output_buf, to_integer(unsigned(count))); 
            writeline(output_buf, write_col_to_output_buf);
        end if;
    end process;
end arch;
```

To run the simulation for the finite duration, we need to provide the ‘number of clocks’ for which we want to run the simulation, as shown in Line 23.

Now, if we press the run all button, then the simulator will stop after ``num_of_clocks`` cycles. Note that, if the data is in ``signed or unsigned`` format, then it can not be saved into the file. We need to change the data into other format e.g. ``integer``, ``natural`` or ``std_logic_vector`` etc. before saving it into the file, as shown in Line 73.  


## MODELSIM IN QUARTUS

#### MODELSIM: GENERATE TESTBENCH

TODO     


#### MODELSIM: USE TESTBENCH

Note: any change in the ``*_tb.vhd`` file needs to `Compile` again, then `Restart` and `Run` again  

TODO      

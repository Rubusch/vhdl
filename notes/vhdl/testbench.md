# Testbenches

## RESOURCES

The notes are taken and copied from the following ressources, in a motivation to have them available whenever I need to look them up.  

Please, for learning VHDL or getting an understanding, have a look into the original links rather.   

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


### COMBINATIONAL: TESTBENCH

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
TODO
```

Problem: Although, the testbench is very simple, but input patterns are not readable. By using the process statement in the testbench, we can make input patterns more readable along with inclusion of various other features e.g. report generation etc.  


### COMBINATIONAL: PROCESS STATEMENT

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

### COMBINATIONAL: USING LOOK UP TABLES (LUT)

```vhdl
-- half_adder_lookup_tb.vhd

library ieee;
use ieee.std_logic_1164.all;

entity half_adder_lookup_tb is
end half_adder_lookup_tb;

architecture tb of half_adder_lookup_tb is
    signal a, b : std_logic; -- input
    signal sum, carry : std_logic; -- output

    -- declare record type
    type test_vector is record
        a, b : std_logic;
        sum, carry : std_logic;
    end record;

    type test_vector_array is array (natural range <>) of test_vector;
    constant test_vectors : test_vector_array := (
        -- a, b, sum , carry   -- positional method is used below
        ('0', '0', '0', '0'), -- or (a => '0', b => '0', sum => '0', carry => '0')
        ('0', '1', '1', '0'),
        ('1', '0', '1', '0'),
        ('1', '1', '0', '1'),
        ('0', '1', '0', '1')  -- fail test
        );

begin
    UUT : entity work.half_adder port map (a => a, b => b, sum => sum, carry => carry);

    tb1 : process
    begin
        for i in test_vectors'range loop
            a <= test_vectors(i).a;  -- signal a = i^th-row-value of test_vector's a
            b <= test_vectors(i).b;

            wait for 20 ns;

            assert (
                        (sum = test_vectors(i).sum) and
                        (carry = test_vectors(i).carry)
                    )

            -- image is used for string-representation of integer etc.
            report  "test_vector " & integer'image(i) & " failed " &
                    " for input a = " & std_logic'image(a) &
                    " and b = " & std_logic'image(b)
                    severity error;
        end loop;
        wait;
    end process;

end tb;
```

*  Define record : First we need to define a record which contains the all the possible columns in the look table. Here, there are four possible columns i.e. a, b, sum and carry, which are defined in record at Lines 15-18.  

*  Create lookup table : Next, we need to define the lookup table values, which is done at Lines 20-28. Here positional method is used for assigning the values to columns (see line 22-27); further, name-association method can also be used as shown in the comment at Line 23.  

*  Assign values to signals : Then the values of the lookup table need to be assigned to half_adder entity (one by one). For this ‘for loop’ is used at line 35, which assigns the values of ‘’test-vector’s ‘a’ and ‘b’ ‘’ to signal ‘a’ and ‘b’ (see comment at Line 36 for better understanding). Similarly, expected values of sum and carry are generated at Lines 41-44. Lastly, report is generated for wrong outputs at Lines 46-50.  


### COMBINATIONAL: READ DATA FROM FILE

File content  

```
0 0 11
0 1 01
1 0 11 
```

```vhdl
-- read_file_ex.vhd


library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- require for writing/reading std_logic etc.

entity read_file_ex is
end read_file_ex;

architecture tb of read_file_ex is
    signal a, b : std_logic;
    signal c : std_logic_vector(1 downto 0);

    -- buffer for storing the text from input read-file
    file input_buf : text;  -- text is keyword

begin     

tb1 : process
    variable read_col_from_input_buf : line; -- read lines one by one from input_buf

    variable val_col1, val_col2 : std_logic; -- to save col1 and col2 values of 1 bit
    variable val_col3 : std_logic_vector(1 downto 0); -- to save col3 value of 2 bit
    variable val_SPACE : character;  -- for spaces between data in file

    begin
     
        -- if modelsim-project is created, then provide the relative path of 
        -- input-file (i.e. read_file_ex.txt) with respect to main project folder
        file_open(input_buf, "VHDLCodes/input_output_files/read_file_ex.txt",  read_mode); 
        -- else provide the complete path for the input file as show below 
        -- file_open(input_buf, "E:/VHDLCodes/input_output_files/read_file_ex.txt", read_mode); 

        while not endfile(input_buf) loop
          readline(input_buf, read_col_from_input_buf);
          read(read_col_from_input_buf, val_col1);
          read(read_col_from_input_buf, val_SPACE);           -- read in the space character
          read(read_col_from_input_buf, val_col2);
          read(read_col_from_input_buf, val_SPACE);           -- read in the space character
          read(read_col_from_input_buf, val_col3);

          -- Pass the read values to signals
          a <= val_col1;
          b <= val_col2;
          c <= val_col3;

          wait for 20 ns;  --  to display results for 20 ns
        end loop;

        file_close(input_buf);             
        wait;
    end process;
end tb ; -- tb
```

To read the file, first we need to define a buffer of type ‘text’, which can store the values of the file in it, as shown in Line 17; file is open in read-mode and values are stored in this buffer at Line 32.  

Next, we need to define the variable to read the value from the buffer. Since there are 4 types of values (i.e. a, b, c and spaces) in file ‘read_file_ex.txt’, therefore we need to define 4 variables to store them, as shown in Line 24-26. Since, variable c is of 2 bit, therefore Line 25 is 2-bit vector; further, for spaces, variable of character type is defined at Line 26.  

Then, values are read and store in the variables at Lines 36-42. Lastly, these values are assigned to appropriate signals at Lines 45-47. Finally, file is closed at Line 52.   


### COMBINATIONAL: WRITE DATA TO FILE

Here, only ``write_mode`` is used for writing the data to file (not the ``append_mode``).  

```vhdl
-- write_file_ex.vhd


library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- require for writing std_logic etc.

entity write_file_ex is
end write_file_ex;

architecture tb of write_file_ex is
    signal a : std_logic;

    file output_buf : text;  -- text is keyword
begin     

    tb1 : process
        variable write_col_to_output_buf : line; -- line is keyword
        variable b : integer := 40;
        begin
            a <= '1';  -- assign value to a
            wait for 20 ns; 

            -- if modelsim-project is created, then provide the relative path of 
            -- input-file (i.e. read_file_ex.txt) with respect to main project folder
            file_open(output_buf, "VHDLCodes/input_output_files/write_file_ex.txt",  write_mode); 
            -- else provide the complete path for the input file as show below 
            --file_open(output_buf, "E:/VHDLCodes/input_output_files/write_file_ex.txt",  write_mode); 

            write(write_col_to_output_buf, string'("Printing values"));
            writeline(output_buf, write_col_to_output_buf);  -- write in line 1

            write(write_col_to_output_buf, string'("a = "));
            write(write_col_to_output_buf, a);
            write(write_col_to_output_buf, string'(", b = "));
            write(write_col_to_output_buf, b);
            writeline(output_buf, write_col_to_output_buf);    -- write in new line 2

            write(write_col_to_output_buf, string'("Thank you"));
            writeline(output_buf, write_col_to_output_buf);   -- write in new line 3

            file_close(output_buf);
            wait; -- indefinitely suspend process
        end process;
end tb ; -- tb
```

To write the data to the file, first we need to define a buffer, which will load the file on the simulation environment for writing the data during simulation, as shown in Line 15 (buffer-defined) and Line 27 (load the file to buffer).  

Next, we need to define a variable, which will store the values to write into the buffer, as shown in Line 19. In the listing, this variable stores three types of value i.e. strings (Lines 31 and 34 etc.), signal ‘a’ (Line 35) and variable ‘b’ (Line 37).  

Note that, two keyword are used for writing the data into the file i.e. ‘write’ and ‘writeline’. ‘write’ keyword store the values in the ‘write_col_to_output_buf’ and ‘writeline’ writes the values in the file. Remember that, all the ‘write’ statements before the ‘writeline’ will be written in same line.  


### COMBINATIONAL: CSV AS INPUT

Demo of read and write results to a CSV file.  

```vhdl
-- read_write_file_ex.vhd

-- testbench for half adder, 

-- Features included in this code are
    -- inputs are read from csv file, which stores the desired outputs as well
    -- outputs are written to csv file
    -- actual output and calculated outputs are compared
    -- Error message is displayed in the file
    -- header line is skipped while reading the csv file


library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- require for writing/reading std_logic etc.

entity read_write_file_ex is
end read_write_file_ex;

architecture tb of read_write_file_ex is
    signal a, b : std_logic;
    signal sum_actual, carry_actual : std_logic;
    signal sum, carry : std_logic;  -- calculated sum and carry by half_adder

    -- buffer for storing the text from input and for output files
    file input_buf : text;  -- text is keyword
    file output_buf : text;  -- text is keyword

begin     
  UUT : entity work.half_adder port map (a => a, b => b, sum => sum, carry => carry);

  tb1 : process
  variable read_col_from_input_buf : line; -- read lines one by one from input_buf
  variable write_col_to_output_buf : line; -- write lines one by one to output_buf

  variable buf_data_from_file : line;  -- buffer for storind the data from input read-file
  variable val_a, val_b : std_logic; 
  variable val_sum, val_carry: std_logic;
  variable val_comma : character;  -- for commas between data in file

  variable good_num : boolean;
  begin
   
  -- ####################################################################
   -- Reading data

      -- if modelsim-project is created, then provide the relative path of 
      -- input-file (i.e. read_file_ex.txt) with respect to main project folder
      file_open(input_buf, "VHDLCodes/input_output_files/half_adder_input.csv",  read_mode); 
      -- else provide the complete path for the input file as show below 
      -- file_open(input_buf, "E:/VHDLCodes/input_output_files/read_file_ex.txt",  read_mode); 

      -- writing data
      file_open(output_buf, "VHDLCodes/input_output_files/half_adder_output.csv",  write_mode); 

      write(write_col_to_output_buf, 
        string'("#a,b,sum_actual,sum,carry_actual,carry,sum_test_results,carry_test_results"));
      writeline(output_buf, write_col_to_output_buf);

      while not endfile(input_buf) loop
        readline(input_buf, read_col_from_input_buf);
        read(read_col_from_input_buf, val_a, good_num);
        next when not good_num;  -- i.e. skip the header lines

        read(read_col_from_input_buf, val_comma);           -- read in the space character
        read(read_col_from_input_buf, val_b, good_num);  
        assert good_num report "bad value assigned to val_b";

        read(read_col_from_input_buf, val_comma);           -- read in the space character
        read(read_col_from_input_buf, val_sum);
        read(read_col_from_input_buf, val_comma);           -- read in the space character
        read(read_col_from_input_buf, val_carry);

        -- Pass the variable to a signal to allow the ripple-carry to use it
        a <= val_a;
        b <= val_b;
        sum_actual <= val_sum;
        carry_actual <= val_carry;

        wait for 20 ns;  --  to display results for 20 ns

        write(write_col_to_output_buf, a);
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, b);
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, sum_actual);
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, sum);
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, carry_actual);
        write(write_col_to_output_buf, string'(","));
        write(write_col_to_output_buf, carry); 
        write(write_col_to_output_buf, string'(","));
        
        -- display Error or OK if results are wrong
        if (sum_actual /= sum) then
          write(write_col_to_output_buf, string'("Error,"));
        else
          write(write_col_to_output_buf, string'(","));  -- write nothing
          
        end if;

        -- display Error or OK based on comparison
        if (carry_actual /= carry) then
          write(write_col_to_output_buf, string'("Error,"));
        else
          write(write_col_to_output_buf, string'("OK,"));
        end if;


        --write(write_col_to_output_buf, a, b, sum_actual, sum, carry_actual, carry);
        writeline(output_buf, write_col_to_output_buf);
      end loop;

      file_close(input_buf);             
      file_close(output_buf);             
      wait;
  end process;
end tb ; -- tb
```

-  Lines 63-64 are added to skip the header row, i.e. any row which does not start with boolean-number(see line 42).  
-  Also, error will be reported for value ‘b’ if it is not the boolean. Similarly, this functionality can be added to other values as well.  
-  Lastly, errors are reported in CSV file at Lines 96-109.  


## SEQUENTIAL

In the case of sequential circuits, we need clock and reset signals; hence two additional blocks are required. Since, clock is generated for complete simulation process, therefore it is defined inside the separate process statement. Whereas, reset signal is required only at the beginning of the operations, hence it is not defined inside the process statement.  

```vhdl
-- modMCounter.vhd

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modMCounter is
    generic (
            M : integer := 5; -- count from 0 to M-1
            N : integer := 3   -- N bits required to count upto M i.e. 2**N >= M
    );
    
    port(
            clk, reset : in std_logic;
            complete_tick : out std_logic;
            count : out std_logic_vector(N-1 downto 0)
    );
end modMCounter;


architecture arch of modMCounter is
    signal count_reg, count_next : unsigned(N-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then 
            count_reg <= (others=>'0');
        elsif   clk'event and clk='1' then
            count_reg <= count_next;
        else  -- note that else block is not required
            count_reg <= count_reg;
        end if;
    end process;
    
    -- set count_next to 0 when maximum count is reached i.e. (M-1)
    -- otherwise increase the count
    count_next <= (others=>'0') when count_reg=(M-1) else (count_reg+1);
    
    -- Generate 'tick' on each maximum count
    complete_tick <= '1' when count_reg = (M-1) else '0';
    
    count <= std_logic_vector(count_reg); -- assign value to output port
end arch;
```


### SEQUENTIAL: INFINITE DURATION TESTBENCH

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

### SEQUENTIAL: FINITE DURATION

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

### MODELSIM: GENERATE TESTBENCH

TODO     


### MODELSIM: USE TESTBENCH

TODO      

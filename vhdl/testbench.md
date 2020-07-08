# Testbenches

## RESOURCES

The notes are taken and copied from the following ressources, in a motivation to have them available whenever I need to look them up.  

Please, for learning VHDL or getting an understanding, have a look into the original links rather.   

https://vhdlguide.readthedocs.io/en/latest/vhdl/testbench.html


## COMBINATIONAL TESTBENCH

example half-adder as combinational circuit
```
-- half_adder.vhd

library ieee;
use ieee.std_logic_1164.all;

entity half_adder is 
  port (a, b : in std_logic;
        sum, carry : out std_logic
    );
end half_adder;

architecture arch of half_adder is
begin
  sum <= a xor b;
  carry <= a and b;
end arch;
```

in the testbench and provide all the input values in the file  

```
-- half_adder_simple_tb.vhd

library ieee;
use ieee.std_logic_1164.all;


entity half_adder_simple_tb is
end half_adder_simple_tb;

architecture tb of half_adder_simple_tb is
    signal a, b : std_logic;  -- inputs 
    signal sum, carry : std_logic;  -- outputs
begin
    -- connecting testbench signals with half_adder.vhd
    UUT : entity work.half_adder port map (a => a, b => b, sum => sum, carry => carry);

    -- inputs
    -- 00 at 0 ns
    -- 01 at 20 ns, as b is 0 at 20 ns and a is changed to 1 at 20 ns
    -- 10 at 40 ns
    -- 11 at 60 ns
    a <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
    b <= '0', '1' after 40 ns;        
end tb ;
```

In this listing, a testbench with name ``half_adder_simple_tb`` is defined at Lines 7-8. Note that, entity of testbench is always empty i.e. no ports are defined in the entity (see Lines 7-8). Then 4 signals are defined i.e. a, b, sum and carry (Lines 11-12) inside the architecture body; these signals are then connected to actual half adder design using structural modeling (see Line 15). Lastly, different values are assigned to input signals e.g. ‘a’ and ‘b’ at lines 16 and 17 respectively.  

In Line 22, value of ‘a’ is 0 initially (at 0 ns), then it changes to ‘1’ at 20 ns and again changes to ‘0’ at 40 ns (do not confuse with after 40 ns, as after 40 ns is with respect to 0 ns, not with respect to 20 ns). Similarly, the values of ‘a’ becomes ‘0’ and ‘1’ at 40 and 60 ns respectively. In the same way value of ‘b’ is initially ‘0’ and change to ‘1’ at 40 ns at Line 23. In this way 4 possible combination are generated for two bits (‘ab’) i.e. 00, 01, 10 and 11; also corresponding outputs, i.e. sum and carry, are shown in the figure.  

Generation:  
- Compile the project ``Processing`` -> ``Start Compilation``
- Open ModelSim ``Tools`` -> ``Run Simulation Tool`` -> ``RTL Simulation``

- Build testbench TODO                                      

- In ModelSim ``Simulate`` -> ``Start Simulation`` TODO        
- In ModelSim ``Simulate`` -> ``Run`` -> ``Run All`` TODO       

Problem: Although, the testbench is very simple, but input patterns are not readable. By using the process statement in the testbench, we can make input patterns more readable along with inclusion of various other features e.g. report generation etc.  


### COMBINATIONAL: PROCESS STATEMENT

Note that, process statement is written without the sensitivity list.  

```
-- half_adder_process_tb.vhd

library ieee;
use ieee.std_logic_1164.all;


entity half_adder_process_tb is
end half_adder_process_tb;

architecture tb of half_adder_process_tb is
    signal a, b : std_logic;
    signal sum, carry : std_logic;
begin
    -- connecting testbench signals with half_adder.vhd
    UUT : entity work.half_adder port map (a => a, b => b, sum => sum, carry => carry);

    tb1 : process
        constant period: time := 20 ns;
        begin
            a <= '0';
            b <= '0';
            wait for period;
            assert ((sum = '0') and (carry = '0'))  -- expected output
            -- error will be reported if sum or carry is not 0
            report "test failed for input combination 00" severity error;

            a <= '0';
            b <= '1';
            wait for period;
            assert ((sum = '1') and (carry = '0'))
            report "test failed for input combination 01" severity error;

            a <= '1';
            b <= '0';
            wait for period;
            assert ((sum = '1') and (carry = '0'))
            report "test failed for input combination 10" severity error;

            a <= '1';
            b <= '1';
            wait for period;
            assert ((sum = '0') and (carry = '1'))
            report "test failed for input combination 11" severity error;

            -- Fail test
            a <= '0';
            b <= '1';
            wait for period;
            assert ((sum = '0') and (carry = '1'))
            report "test failed for input combination 01 (fail test)" severity error;


            wait; -- indefinitely suspend process
        end process;
end tb;
```

### COMBINATIONAL: USING LOOK UP TABLES (LUT)

```
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

```
0 0 11
0 1 01
1 0 11 
```

```
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

o read the file, first we need to define a buffer of type ‘text’, which can store the values of the file in it, as shown in Line 17; file is open in read-mode and values are stored in this buffer at Line 32.  

Next, we need to define the variable to read the value from the buffer. Since there are 4 types of values (i.e. a, b, c and spaces) in file ‘read_file_ex.txt’, therefore we need to define 4 variables to store them, as shown in Line 24-26. Since, variable c is of 2 bit, therefore Line 25 is 2-bit vector; further, for spaces, variable of character type is defined at Line 26.  

Then, values are read and store in the variables at Lines 36-42. Lastly, these values are assigned to appropriate signals at Lines 45-47. Finally, file is closed at Line 52.   


## SEQUENTIAL TESTBENCH

TODO


## GENERATE TESTBENCH WITH MODELSIM

TODO



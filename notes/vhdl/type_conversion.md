# VHDL: type conversions

## Resources

https://www.nandland.com/vhdl/tips/tip-convert-numeric-std-logic-vector-to-integer.html#Arith-Integer-To-Signed


## Using NUMERIC_STD

### INTEGER to SIGNED

```
signal input  : integer;
signal output : signed(3 downto 0);

output <= to_signed(input, output'length);
```


### INTEGER to STD_LOGIC_VECTOR

```
signal input   : integer;
signal output_a : std_logic_vector(3 downto 0);
signal output_b : std_logic_vector(3 downto 0);

-- This line demonstrates how to convert positive integers
output_a <= std_logic_vector(to_unsigned(input, output_a'length));

-- This line demonstrates how to convert positive or negative integers
output_b <= std_logic_vector(to_signed(input, output_b'length));
```


### INTEGER to UNSIGNED

```
signal input  : integer;
signal output : unsigned(3 downto 0);

output <= to_unsigned(input, output'length);
```


### STD_LOGIC_VECTOR to INTEGER

```
signal input   : std_logic_vector(3 downto 0);
signal output_a : integer;
signal output_b : integer;

-- This line demonstrates the unsigned case
output_a <= to_integer(unsigned(input));

-- This line demonstrates the signed case
output_b <= to_integer(signed(input));
```


### STD_LOGIC_VECTOR to SIGNED

```
signal input  : std_logic_vector(3 downto 0);
signal output : signed(3 downto 0);

output <= signed(input);
```


### STD_LOGIC_VECTOR to UNSIGNED

```
signal input  : std_logic_vector(3 downto 0);
signal output : unsigned(3 downto 0);

output <= unsigned(input);
```


### SIGNED to INTEGER

```
signal input  : signed(3 downto 0);
signal output : integer;

output <= to_integer(input);
```


### SIGNED to STD_LOGIC_VECTOR

```
signal input  : signed(3 downto 0);
signal output : std_logic_vector(3 downto 0);

output <= std_logic_vector(input);
```


### SIGNED to UNSIGNED

```
signal input  : signed(3 downto 0);
signal output : unsigned(3 downto 0);

output <= unsigned(input);
```


### UNSIGNED to INTEGER

```
signal input  : unsigned(3 downto 0);
signal output : integer;

output <= to_integer(input);
```


### UNSIGNED to SIGNED

```
signal input  : unsigned(3 downto 0);
signal output : signed(3 downto 0);

output <= signed(input);
```


### UNSIGNED to STD_LOGIC_VECTOR

```
signal input  : unsigned(3 downto 0);
signal output : std_logic_vector(3 downto 0);

output <= std_logic_vector(input);
```


## Using STD_LOGIC_ARITH

### INTEGER to SIGNED

```
signal input  : integer;
signal output : signed(3 downto 0);

output <= conv_signed(input, output'length);
```


### INTEGER to STD_LOGIC_VECTOR

```
signal input  : integer;
signal output : std_logic_vector(3 downto 0);

output <= conv_std_logic_vector(input, output'length);
```


### INTEGER to UNSIGNED

```
signal input  : integer;
signal output : unsigned(3 downto 0);

output <= conv_unsigned(input, output'length);
```


### STD_LOGIC_VECTOR to INTEGER

```
signal input   : std_logic_vector(3 downto 0);
signal output_a : integer;
signal output_b : integer;

-- This line demonstrates the unsigned case
output_a <= conv_integer(unsigned(input));

-- This line demonstrates the signed case
output_b <= conv_integer(signed(input));
```


### STD_LOGIC_VECTOR to SIGNED

```
signal input  : std_logic_vector(3 downto 0);
signal output : signed(3 downto 0);

output <= signed(input);
```


### STD_LOGIC_VECTOR to UNSIGNED

```
signal input  : std_logic_vector(3 downto 0);
signal output : unsigned(3 downto 0);

output <= unsigned(input);
```


### SIGNED to INTEGER

```
signal input  : signed(3 downto 0);
signal output : integer;

output <= conv_integer(input);
```


### SIGNED to STD_LOGIC_VECTOR

```
signal input  : signed(3 downto 0);
signal output : std_logic_vector(3 downto 0);

output <= std_logic_vector(input);
```


### SIGNED to UNSIGNED

```
signal input  : signed(3 downto 0);
signal output : unsigned(3 downto 0);

output <= unsigned(input);
```


### UNSIGNED to INTEGER

```
signal input  : unsigned(3 downto 0);
signal output : integer;

output <= conv_integer(input);
```


### UNSIGNED to SIGNED

```
signal input  : unsigned(3 downto 0);
signal output : signed(3 downto 0);

output <= signed(input);
```


### UNSIGNED to STD_LOGIC_VECTOR

```
signal input  : unsigned(3 downto 0);
signal output : std_logic_vector(3 downto 0);

output <= std_logic_vector(input);
```

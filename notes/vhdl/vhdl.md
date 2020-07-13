# VHDL

### General notes on VHDL

* Single quotation is used for 1-bit (i.e. ‘1’), whereas double quotation is used for more than one bits (i.e. ‘‘101’‘)   


### Modeling

Mixed Modeling is generally composed out of the three types of modeling used for HW/SW Design:  

1) Dataflow Modeling: In this modeling style, the relation between input and outputs are defined using signal assignments. In the other words, we do not define the structure of the design explicitly; we only define the relationships between the signals; and structure is implicitly created during synthesis process.   

2) Structural Modeling: We use the pre-defined designs to create the new designs (instead of implementing the ‘boolean’ expression).  

3) Behavioral Modeling: the ‘process’ keyword is used and all the statements inside the process statement execute sequentially, and known as ‘sequential statements’. Various conditional and loop statements can be used inside the process block.  


### Types

In package ``std_logic_1164`` and ``numeric_std`` provided types are mainly

* std_logic
* std_logic_vector
* unsigned
* signed
* integer
* natural
* time
* string

Category          | Datatype                                                  | Package
-------------------------------------------------------------------------------------------------------------
Synthesizable     | ``bit``, ``bit_vector``                                   | standard library
                  | ``boolean``, ``boolean_vector``                           | (automatically included,
                  | ``integer``, ``natural``, ``postive``, ``integer_vector`` | no need to include explicitly)
                  | ``character``, ``string``                                 |
                  |                                                           |
                  | ``std_logic``, ``std_logic_vector``                       | ``std_logic_1164``
                  | ``signed``, ``unsigned``                                  | ``numeric_std``
--------------------------------------------------------------------------------------------------------------
Non-synthesizable | ``real``, ``real_vector``                                 | standard library
                  | ``time``, ``time_vector``                                 | (automatically included,
                  | ``delay_length``                                          | no need to include explicitly)
                  |                                                           |
                  | ``read``, ``write``, ``line``, ``text``                   | ``textio`` and
                  |                                                           | ``std_logic_textio``

In general ``integer types`` are used for mathematical and range operations,
where ``enumeration types`` are rather used for state machines  


### Entity - Component - Package

Use another *ENTITY* in a different file (library is always ``WORK``), add the file to the project (in Quartus), then use it as follows  
```vhdl
-- (...)
ARCHITECTURE FULLADDER_ARCH OF FULLADDER_ENT IS
-- (...)

BEGIN
-- (...)
    HA1 : ENTITY WORK.HALFADDER_ENT PORT MAP(
        A => A,
        B => B,
        SUM => SUM_TMP,
        CARRY => CARRY_FIRST_TMP);
-- (...)
```



Use a *COMPONENT* from a different file
```vhdl
-- (...)
ARCHITECTURE FULLADDER_ARCH OF FULLADDER_ENT IS
    COMPONENT HALFADDER_ENT
    PORT( A : IN STD_LOGIC
        ; B : IN STD_LOGIC
        ; SUM : OUT STD_LOGIC
        ; CARRY : OUT STD_LOGIC
    );
    END COMPONENT;
-- (...)

BEGIN
-- (...)

    HA1 : HALFADDER_ENT PORT MAP(
        A => A,
        B => B,
        SUM => SUM_TMP,
        CARRY => CARRY_FIRST_TMP);
-- (...)
```


Define a *PACKAGE*  

```vhdl
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE PACKAGE_EX IS
    COMPONENT COMPARATOR1BIT
    PORT( X, Y : IN STD_LOGIC
        ; EQ : OUT STD_LOGIC
    );

    END COMPONENT;
END PACKAGE;
```

Usage of package, remember our workspace (library location) is always ``WORK``.  

```vhdl
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.PACKAGE_EX.ALL;
-- (...)
ARCHITECTURE ARCH OF COMPARATOR2BIT_ENT IS
    SIGNAL S0, S1 : STD_LOGIC;
BEGIN
    EQ_BIT0: COMPARATOR1BIT -- from package, but now w/o COMPONENT declaration in ARCH
        PORT MAP (X => A(0), Y => B(0), EQ => S0);
-- (...)
```

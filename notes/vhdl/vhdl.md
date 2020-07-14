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

| Category                                | Datatype                                                  | Package                          |
|-----------------------------------------|-----------------------------------------------------------|----------------------------------|
| Synthesizable                           | ``bit``, ``bit_vector``                                   | standard library                 |
|                                         | ``boolean``, ``boolean_vector``                           | (automatically included,         |
|                                         | ``integer``, ``natural``, ``postive``, ``integer_vector`` | no need to include explicitly)   |
|                                         | ``character``, ``string``                                 |                                  |
|                                         |                                                           |                                  |
|                                         | ``std_logic``, ``std_logic_vector``                       | ``std_logic_1164``               |
|                                         | ``signed``, ``unsigned``                                  | ``numeric_std``                  |
|-----------------------------------------|-----------------------------------------------------------|----------------------------------|
| Non-synthesizable                       | ``real``, ``real_vector``                                 | standard library                 |
|                                         | ``time``, ``time_vector``                                 | (automatically included,         |
|                                         | ``delay_length``                                          | no need to include explicitly)   |
|                                         |                                                           |                                  |
| ``read``, ``write``, ``line``, ``text`` | ``textio`` and                                            |                                  |
|                                         | ``std_logic_textio``                                      |                                  |

In general ``integer types`` are used for mathematical and range operations, where ``enumeration types`` are rather used for state machines  

In VHDL, list with same data types is defined using *Array* keyword; whereas list with different data types is defined using *Record*.  
```
-- (...)
ARCHITETCURE ARCH OF COMPOSITE_ENT IS
    TYPE NEW_ARRAY IS ARRAY (0 TO 1) OF STD_LOGIC; -- create array
    SIGNAL ARR_VALUE : NEW_ARRAY; -- signal of array type

    TYPE NEW_RECORD IS RECORD -- create record
        D1, D2 : STD_LOGIC;
        V1, V2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
    END RECORD;
    SIGNAL RECORD_VALUE : NEW_RECORD; -- signal of record type
BEGIN
-- (...)
```

### Constants vs Generics

Constants are defined in 'architecture declaration' part and can not be modified in the architecture-body after declaration.  

Generics are defined in 'entity' and can not be modified in the architecture-body.   


### Functions vs Procedures

Differences between the function and the procedure blocks,

* Procedures can have both input and output ports, whereas the functions can have only input ports.

* Functions can return only one value using ``return`` keyword; whereas procedures do not have ``return`` keyword but can return multiple values using ``output`` port.



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

### Design Type

* Combinational - Logic, no clock, no inner memory / storage
* Sequential - clocked and with storing memory (e.g. D-FlipFlops)
* Mixed

| Design                       | Statement                  | VHDL               |
----------------------------------------------------------------------------------
| Sequential                   | Sequential statements only | ``If``, ``CASE``,  |
| (Flip-flops and logic gates) |                            | ``LOOP``, ``WAIT`` |
|                              |                            |                    |
| Combinational                | Concurrent and Sequential  | ``WHEN-ELSE``      |
| (only logic gates)           |                            | ``WITH-SELECT``    |
|                              |                            | ``GENERATE``       |



### State Machines

If a system transits between a finite number of internal states, then a finite state machines (FSM) can be used to design the system.  

* FSM design is known as Moore design if the output of the system depends only on the states  
* It is known as Mealy design if the output depends on the states and external inputs  




-- Moore Machines - Regular Machine Template
--
-- Meher Krishna Patel says:
--
-- Moore and Mealy machines can be divided into three categories i.e. ‘regular’, ‘timed’ and ‘recursive’.
--
--
--
-- REGULAR MOORE MACHINE
--
-- +---------+                    +---------+                    +---------+
-- |  zero   |            x = '1' |  one    |            x = '1' |  two    |
-- |         |------------------->|         |------------------->|         |
-- | z = '0' |                    | z = '0' |                    | z = '1' |
-- +---------+                    +---------+                    +---------+
--
--
--
-- TIMED MOORE MACHINE : next state depends on time as well
--
-- +---------+                    +---------+          x = '1' & +---------+
-- |  zero   |            x = '1' |  one    |            t = 5   |  two    |
-- |         |------------------->|         |------------------->|         |
-- | z = '0' |                    | z = '0' |                    | z = '1' |
-- +---------+                    +---------+                    +---------+
--
--
--
-- RECURSIVE MOORE MACHINE : output 'z' depends on output (feedback)
--
-- +---------+                    +---------+          x = '1' & +---------+
-- |  zero   |            x = '1' |  one    |            z = 5   |  two    |
-- |         |------------------->| z =     |------------------->|         |
-- | z = '0' |                    |   z + 1 |                    | z = '1' |
-- +---------+                    +---------+                    +---------+
--
--
-- "Regular" means:
-- * Output depends only on the states, therefore no ‘if statement’ is required in the process-statement.
-- * Next-state depends on current-state and and current external inputs.
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MOOREREGULAR IS
GENERIC( PARAM1 : STD_LOGIC_VECTOR(...) := <VALUE>
    ; PARAM2 : UNSIGNED(...) := <VALUE>
);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; INPUT1 : IN STD_LOGIC_VECTOR(...)
    ; INPUT2 : IN STD_LOGIC_VECTOR(...)
    ...
    ; OUTPUT1 : OUT SIGNED(...)
    ; OUTPUT2 : OUT SIGNED(...)
);
END MOOREREGULAR;

ARCHITECTURE ARCH OF MOOREREGULAR IS
    TYPE STATETYPE IS (S0, S1, S2,...);
    SIGNAL STATE_REG, STATE_NEXT : STATETYPE;

BEGIN

    
END ARCH;


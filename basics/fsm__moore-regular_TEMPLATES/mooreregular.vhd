-- Moore Machines - Regular Machine Template
--
-- Meher Krishna Patel says:
--
-- Moore and Mealy machines can be divided into three categories i.e. ‘regular’, ‘timed’ and ‘recursive’.
--
-- TODO ascii art
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

BEGIN

END ARCH;


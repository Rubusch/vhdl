-- N-bit binary counter
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY COUNTER IS
GENERIC( N : INTEGER := 3;
);
PORT( CLK, RST
    
);
END COUNTER;

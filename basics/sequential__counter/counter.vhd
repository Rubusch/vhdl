-- N-bit binary counter
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY COUNTER IS
GENERIC( N : INTEGER := 3 );
PORT( CLK, RST : IN STD_LOGIC
    ; COMPLETE_TICK : OUT STD_LOGIC
    ; COUNT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END COUNTER;

ARCHITECTURE ARCH OF COUNTER IS
    CONSTANT MAX_COUNT : INTEGER := 2**N -1;
    SIGNAL COUNT_REG, COUNT_NEXT : UNSIGNED(N-1 DOWNTO 0);
BEGIN
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            COUNT_REG <= (OTHERS => '0');
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            COUNT_REG <= COUNT_NEXT;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    -- the following is GENERAL true
    COUNT_NEXT <= COUNT_REG+1;

    -- a 'tick' is generated exactly when the below expression using MAX_COUNT is true
    COMPLETE_TICK <= '1' WHEN COUNT_REG = MAX_COUNT ELSE '0';

    COUNT <= STD_LOGIC_VECTOR(COUNT_REG);
END ARCH;

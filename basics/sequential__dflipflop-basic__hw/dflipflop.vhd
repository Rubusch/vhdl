-- basic d-flip-flop
--
-- author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DFLIPFLOP IS
PORT( CLK, RST : IN STD_LOGIC
    ; D : IN STD_LOGIC
    ; Q : OUT STD_LOGIC
);
END DFLIPFLOP;

ARCHITECTURE ARCH OF DFLIPFLOP IS
BEGIN
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            Q <= '0';
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            Q <= D;
        ELSE
            NULL;
        END IF;
    END PROCESS;
END ARCH;

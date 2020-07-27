-- d-flipflop demo with ENA
--
-- author: Lothar Rubusch

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DFLIPFLOP IS
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; ENA : IN STD_LOGIC
    -- ENA: enable e.g. if we want to change the output of the 
    -- D-flip-flop on every 10th-clock, then we can set the
    -- enable to '1' for every 10thclock and '0' for rest of
    -- the clocks
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
        ELSIF (CLK'EVENT AND CLK = '1' AND ENA = '1') THEN
            Q <= D;
        ELSE
            NULL; -- do nothing
        END IF;
    END PROCESS;
END ARCH;

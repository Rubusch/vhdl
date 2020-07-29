-- d-flipflop demo with ENA and QBAR
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
    ; Q : OUT STD_LOGIC := '0'
    ; QBAR : OUT STD_LOGIC := '1'
    -- QBAR: returns the NOTed Q signal
);
END DFLIPFLOP;

ARCHITECTURE ARCH OF DFLIPFLOP IS

BEGIN

    PROCESS(CLK, RST)
    BEGIN
        IF RST = '0' THEN
            Q <= '0';
            QBAR <= '0'; -- set both to '0' as unpowered gate
        ELSIF (CLK'EVENT AND CLK = '1' AND RST = '1' AND ENA = '1') THEN
            Q <= D;
            QBAR <= NOT D;
        ELSE
            NULL; -- do nothing
        END IF;
    END PROCESS;

END ARCH;

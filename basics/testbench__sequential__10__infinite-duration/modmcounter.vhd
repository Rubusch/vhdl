-- MODMCOUNTER.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MODMCOUNTER_ENT IS
GENERIC( M : INTEGER := 5    -- count from 0 to M-1
       ; N : INTEGER := 3    -- N bits required to count up to M, i.e. 2^N >= M
);
PORT( CLK, RESET : IN STD_LOGIC
    ; COMPLETE_TICK : OUT STD_LOGIC
    ; COUNT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END MODMCOUNTER_ENT;

ARCHITECTURE MODMCOUNTER_ARCH OF MODMCOUNTER_ENT IS
    SIGNAL COUNT_REG, COUNT_NEXT : UNSIGNED(N-1 DOWNTO 0);

BEGIN

    PROCESS(CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            COUNT_REG <= (OTHERS => '0');
        ELSIF RISING_EDGE(CLK) THEN
            COUNT_REG <= COUNT_NEXT;
        END IF;
    END PROCESS;

    -- set COUNT_NEXT to 0 when maximum count is reached i.e. M-1
    -- otherwise increase the count
    COUNT_NEXT <= (OTHERS => '0') WHEN COUNT_REG = (M-1) ELSE (COUNT_REG+1);

    -- generate tick on each maximum count
    COMPLETE_TICK <= '1' WHEN COUNT_REG = (M-1) ELSE '0';

    COUNT <= STD_LOGIC_VECTOR(COUNT_REG); -- assign value to output port
END ARCHITECTURE;

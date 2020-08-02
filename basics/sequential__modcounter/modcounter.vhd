-- modulo counter
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MODCOUNTER IS
GENERIC( NBITS : INTEGER := 2    -- number of bits for counter
    ; MODULO : INTEGER := 4      -- count up to MODULO-1 for signal
);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; COMPLETE_TICK : OUT STD_LOGIC
    ; COUNT : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0)
);
END MODCOUNTER;

ARCHITECTURE ARCH OF MODCOUNTER IS
    SIGNAL COUNT_REG : UNSIGNED(NBITS-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL COUNT_NEXT : UNSIGNED(NBITS-1 DOWNTO 0) := (OTHERS => '0');

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

    -- implement modulo
    COUNT_NEXT <= (OTHERS => '0') WHEN COUNT_REG = (MODULO - 1) ELSE (COUNT_REG + 1);

    -- generate tick when MODULO is reached
    COMPLETE_TICK <= '1' WHEN COUNT_REG = (MODULO - 1) ELSE '0';

    -- display value on OUT port
    COUNT <= STD_LOGIC_VECTOR(COUNT_REG);
END ARCH;


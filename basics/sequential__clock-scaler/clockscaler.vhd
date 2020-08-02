-- clock scaler
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CLOCKSCALER IS
-- MODULO =   5 000 000, NBITS = 23 to represent a 10^6 decimal number in binary, i.e. for 0.1 s
-- MODULO =  50 000 000, NBITS = 26 to represent a 10^7 decimal number in binary, i.e. for 1 s
-- MODULO = 500 000 000, NBITS = 29 to represent a 10^7 decimal number in binary, i.e. for 10 s
GENERIC( MODULO : INTEGER := 5000000
    ; NBITS : INTEGER := 23
);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; PULSE : OUT STD_LOGIC
);
END CLOCKSCALER;

ARCHITECTURE CLOCKSCALeR_ARCH OF CLOCKSCALER IS
    SIGNAL COMPLETE_TICK : STD_LOGIC;

BEGIN

    MODCOUNTER_UNIT : ENTITY WORK.MODCOUNTER
        GENERIC MAP (NBITS => NBITS, MODULO => MODULO)
        PORT MAP (CLK => CLK, RST => RST, COMPLETE_TICK => COMPLETE_TICK);

    PULSE <= COMPLETE_TICK;
END CLOCKSCALER_ARCH;

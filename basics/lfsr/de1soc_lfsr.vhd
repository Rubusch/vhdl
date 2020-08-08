-- de1soc: hw adaptation of lfsr
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DE1SOC_LFSR IS
GENERIC( NBITS : INTEGER := 3);
PORT( CLK50 : IN STD_LOGIC
    ; KEY_RST : IN STD_LOGIC
    ; LED_Q : OUT STD_LOGIC_VECTOR(NBITS DOWNTO 0)
);

ARCHITECTURE DE1SOC OF DE1SOC_LFSR IS

BEGIN

END DE1SOC;

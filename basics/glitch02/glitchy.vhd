-- unfixable glitch example (Manchester encoding)
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY GLITCHY IS
PORT( CLK : IN STD_LOGIC
    ; DIN : IN STD_LOGIC
    ; DOUT : OUT STD_LOGIC
);
END GLITCHY;

ARCHITECTURE GLITCHY_ARCH OF GLITCHY IS
BEGIN
    -- glitch will occur on transition of signal din
    DOUT <= CLK XOR DIN;
END GLITCHY_ARCH;


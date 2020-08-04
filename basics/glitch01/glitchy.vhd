-- glitch example
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY GLITCHY IS
PORT( IN0 : IN STD_LOGIC
    ; IN1 : IN STD_LOGIC
    ; SEL : IN STD_LOGIC
    ; Z : OUT STD_LOGIC
);
END GLITCHY;

ARCHITECTURE GLITCHY_ARCH OF GLITCHY IS
    SIGNAL NOT_SEL : STD_LOGIC := '0';
    SIGNAL AND_OUT1 : STD_LOGIC := '0';
    SIGNAL AND_OUT2 : STD_LOGIC := '0';

BEGIN

    NOT_SEL <= NOT SEL;
    AND_OUT1 <= NOT_SEL AND IN0;
    AND_OUT2 <= SEL AND IN1;

    Z <= AND_OUT1 OR AND_OUT2; -- glitch in signal Z
    -- fix to the glitch: comment out above line and enable the line below to fix the glitch
--    Z <= AND_OUT1 OR AND_OUT2 OR (IN0 AND IN1);
END GLITCHYARCH;

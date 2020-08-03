-- fsm: mealy and moore state machines
--
-- the example generates a tick of the duration of one clock cycle, whenever the input signal changes from 0 to 1.
--
--      +--+                         +--+
--      |  |                         |  |
--      V  |                         V  |
--    ,------.                     ,------.
--    | zero |                     | zero |
--    '------'                     '------'
--       |                            |
--
--
-- author: Lothar Rubusch (pls, find original in Meher Krishna Patel's Edge Detector Example)
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MEALYANDMOORE IS
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; LEVEL : IN STD_LOGIC
    ; MEALY_TICK : OUT STD_LOGIC
    ; MOORE_TICK : OUT STD_LOGIC
);
END MEALYANDMOORE;

ARCHITECTURE MEALYANDMORE_ARCH OF MEALYANDMOORE IS
    -- TODO
BEGIN
    -- TODO
END MEALYANDMOORE;

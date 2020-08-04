-- fsm: mealy and moore state machines
--
-- In Moore machines the output is available after 1 clock cycle and depends
-- on the states only (synchronous machine).
-- In Mealy machines the output is available as soon as the input is changed,
-- and depends on the states along with external inputs (asynchronous machine).
--
-- In consequence Mealy machines require fewer states than Moore machines.
-- Moore machine designs should be preferred where glitches are not a problem.
-- Mealy machines are used in synchronous systems i.e. 'delay free' and
-- 'glitch free'!
--
-- the example generates a tick of the duration of one clock cycle, whenever the input signal changes from 0 to 1.
--
-- Mealy Design
--
--                                                                       LEVEL = 1
--                  +------+                                              TICK = 1  +------+
--            ,---->|      |------------------------------------------------------->|      |-----.
-- LEVEL = 0  |     | zero |                                                        | one  |     | LEVEL = 1
--  TICK = 0  '-----|      |<-------------------------------------------------------|      |<----'  TICK = 0
--                  +------+  LEVEL = 0                                             +------+
--                             TICK = 0
--
--
--
-- Moore Design
--
--                  +----------+          LEVEL = 1 +----------+          LEVEL = 1 +----------+
--            ,---->|   zero   |------------------->|   edge   |------------------->|   one    |-----.
-- LEVEL = 0  |     |          |                    |          |                    |          |     | LEVEL = 1
--            '-----| TICK = 0 |<-------------------| TICK = 1 |                    | TICK = 0 |<----'
--                  +----------+  LEVEL = 0         +----------+                    +----------+
--                       A                                                               |
--                       |                                                               |
--                       '---------------------------------------------------------------'
--                    LEVEL = 0
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

ARCHITECTURE MEALYANDMOORE_ARCH OF MEALYANDMOORE IS
    TYPE STATEMEALY_TYPE IS (ZERO, ONE);  -- the 2 states as above
    SIGNAL STATEMEALY_REG, STATEMEALY_NEXT : STATEMEALY_TYPE;

    TYPE STATEMOORE_TYPE IS (ZERO, EDGE, ONE); -- the states as above
    SIGNAL STATEMOORE_REG, STATEMOORE_NEXT : STATEMOORE_TYPE;

BEGIN

    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            STATEMEALY_REG <= ZERO;
            STATEMOORE_REG <= ZERO;
        ELSIF (RISING_EDGE(CLK)) THEN
            STATEMEALY_REG <= STATEMEALY_NEXT;
            STATEMOORE_REG <= STATEMOORE_NEXT;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    -- MEALY
    PROCESS(STATEMEALY_REG, LEVEL)
    BEGIN
        STATEMEALY_NEXT <= STATEMEALY_REG;
        MEALY_TICK <= '0';
        CASE STATEMEALY_REG IS
            WHEN ZERO =>
                IF (LEVEL = '1') THEN
                    STATEMEALY_NEXT <= ONE;
                    MEALY_TICK <= '1';
                END IF;
            WHEN ONE =>
                IF (LEVEL = '0') THEN
                    STATEMEALY_NEXT <= ZERO;
                END IF;
        END CASE;
    END PROCESS;

    -- MOORE
    PROCESS(STATEMOORE_REG, LEVEL)
    BEGIN
        STATEMOORE_NEXT <= STATEMOORE_REG;
        MOORE_TICK <= '0';
        CASE STATEMOORE_REG IS
            WHEN ZERO =>
                IF (LEVEL = '1') THEN
                    STATEMOORE_NEXT <= EDGE;
                END IF;
            WHEN EDGE =>
                MOORE_TICK <= '1';
                IF (LEVEL = '1') THEN
                    STATEMOORE_NEXT <= ONE;
                ELSE
                    STATEMOORE_NEXT <= ZERO;
                END IF;
            WHEN ONE =>
                IF (LEVEL = '0') THEN
                    STATEMOORE_NEXT <= ZERO;
                END IF;
        END CASE;
    END PROCESS;
END MEALYANDMOORE_ARCH;

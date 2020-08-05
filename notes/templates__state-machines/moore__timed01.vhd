-- Moore Machines - Timed Machine Template
--
-- Meher Krishna Patel says:
--
-- Moore and Mealy machines can be divided into three categories i.e. ‘regular’, ‘timed’ and ‘recursive’.
--
--
--
-- REGULAR MOORE MACHINE
--
-- +---------+                    +---------+                    +---------+
-- |  zero   |            x = '1' |  one    |            x = '1' |  two    |
-- |         |------------------->|         |------------------->|         |
-- | z = '0' |                    | z = '0' |                    | z = '1' |
-- +---------+                    +---------+                    +---------+
--
--
--
-- TIMED MOORE MACHINE : next state depends on time as well
--
-- +---------+                    +---------+          x = '1' & +---------+
-- |  zero   |            x = '1' |  one    |            t = 5   |  two    |
-- |         |------------------->|         |------------------->|         |
-- | z = '0' |                    | z = '0' |                    | z = '1' |
-- +---------+                    +---------+                    +---------+
--
--
--
-- RECURSIVE MOORE MACHINE : output 'z' depends on output (feedback)
--
-- +---------+                    +---------+          x = '1' & +---------+
-- |  zero   |            x = '1' |  one    |            z = 5   |  two    |
-- |         |------------------->| z =     |------------------->|         |
-- | z = '0' |                    |   z + 1 |                    | z = '1' |
-- +---------+                    +---------+                    +---------+
--
--
-- "Timed" means:
-- * Zero the timer : The value of the timer is set to zero, whenever the state
--   of the system changes.
-- * Stop the timer : Value of the timer is incremented till the predefined
--   'maximum value' is reached and then it should be stopped incrementing.
--   Further, its value should not be set to zero until state is changed.
-- * Outputs depend on current external inputs
-- * Next states depend on time along with current states and current external inputs.
--
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MOORE_TIMED IS
GENERIC( PARAM1 : STD_LOGIC_VECTOR(...) := <VALUE>
    ; PARAM2 : UNSIGNED(...) := <VALUE>
);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; INPUT1 : IN STD_LOGIC_VECTOR(...)
    ; INPUT2 : IN STD_LOGIC_VECTOR(...)
    ; ...
    ; OUTPUT1 : OUT SIGNED(...)
    ; OUTPUT2 : OUT SIGNED(...)
    ; ...
);
END MOORE_TIMED;

ARCHITECTURE ARCH OF MOORE_TIMED IS
    TYPE STATETYPE IS (S0, S1, S2,...);
    SIGNAL STATE_REG, STATE_NEXT : STATETYPE;

    -- timer
    CONSTANT T1 : NATURAL := <VALUE>;
    CONSTANT T2 : NATURAL := <VALUE>;
    CONSTANT T3 : NATURAL := <VALUE>;
    ...;
    SIGNAL T : NATURAL;

BEGIN

    -- state register: STATE_REG
    -- the sequential part of the design
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            STATE_REG <= S1;
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            STATE_REG <= STATE_NEXT;
        END IF;
    END PROCESS;

    -- timer
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            T <= 0;
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            IF (STATE_REG /= STATE_NEXT) THEN -- state transition
                T <= 0;
            ELSE
                T <= T + 1;
            END IF;
        END IF;
    END PROCESS;

    -- next state logic: STATE_NEXT
    -- this is combination of the sequential design which contains the logic
    -- for the NEXT_STATE include all signals and input in sensitive list
    -- except STATE_NEXT
    PROCESS(INPUT1, INPUT2, ..., STATE_REG)
    BEGIN
        STATE_NEXT <= STATE_REG;

        --  default outputs
        OUTPUT1 <= <VALUE>;
        OUTPUT2 <= <VALUE>;
        ...;

        CASE STATE_REG IS
            WHEN S0 =>
                OUTPUT1 <= <VALUE>;
                OUTPUT2 <= <VALUE>;
                ...;
                IF (<CONDITION> AND T >= T1-1) THEN
                    STATE_NEXT <= S1;
                ELSIF (<CONDITION> AND T >= T2-1) THEN
                    STATE_NEXT <= ...;
                ELSE -- remain
                    STATE_NEXT <= S0;
                END IF;
            WHEN S1 =>
                OUTPUT1 <= <VALUE>;
                OUTPUT2 <= <VALUE>;
                ...;
                IF (<CONDITION> AND T >= T3-1) THEN
                    STATE_NEXT <= S2;
                ELSIF (<CONDITION> AND T >= T2-1) THEN
                    STATE_NEXT <= ...;
                ELSE -- remain
                    STATE_NEXT <= S1;
                END IF;
            WHEN S2 =>
                ...;
        END CASE;
    END PROCESS;

    -- D-FF (D-Flipflop): to remove the glitches
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            NEW_OUTPUT1 <= ...;
            NEW_OUTPUT2 <= ...;
            ...;
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            NEW_OUTPUT1 <= OUTPUT1;
            NEW_OUTPUT2 <= OUTPUT2;
            ...;
        END IF;
    END PROCESS;
END ARCH;


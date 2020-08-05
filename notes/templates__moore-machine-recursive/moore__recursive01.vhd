-- Moore Machines - Recursive Machine Template
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
-- "Recursive" means:
-- * Outputs depend on current external inputs. Values in the feedback
--   registers are also used as outputs.
-- * STATE_NEXT depends on current states, current external inputs, current
--   internal inputs (i.e. previous outputs feedback as inputs to system) and
--   time (optional).
--
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MOORERECURSIVE IS
GENERIC( PARAM1 : STD_LOGIC_VECTOR(...) := <VALUE>
    ; PARAM2 : UNSIGNED(...) := <VALUE>
);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; INPUT1 : IN STD_LOGIC_VECTOR(...)
    ; INPUT2 : IN STD_LOGIC_VECTOR(...)
    ...
    ; NEW_OUTPUT1 : INOUT SIGNED(...)
    ; NEW_OUTPUT2 : INOUT SIGNED(...)
    ...
    ; OUTPUT1 : INOUT SIGNED(...)
    ; OUTPUT2 : INOUT SIGNED(...)
);
END MOORERECURSIVE;

ARCHITECTURE ARCH OF MOORERECURSIVE IS
    TYPE STATETYPE IS (S0, S1, S2,...);
    SIGNAL STATE_REG, STATE_NEXT : STATETYPE;

    -- timer (optional)
    CONSTANT T1 : NATURAL := <VALUE>;
    CONSTANT T2 : NATURAL := <VALUE>;
    CONSTANT T3 : NATURAL := <VALUE>;
    ...;
    CONSTANT TMAX : NATURAL := <VALUE>; -- TMAX >= MAX(T1, T2,...)-1
    SIGNAL T : NATURAL;

    -- recursive: feedback register
    SIGNAL S1_REG : STD_LOGIC_VECTOR(...) := <VALUE>;
    SIGNAL S1_NEXT : STD_LOGIC_VECTOR(...) := <VALUE>;
    SIGNAL S2_REG : SIGNED(...) := <VALUE>;
    SIGNAL S2_NEXT : SIGNED(...) := <VALUE>;
    ...;
BEGIN

    PROCESS(CLK, RST)
    BEGIN
        IF RST = '1' THEN
            STATE_REG <= S1;
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            STATE_REG <= STATE_NEXT;
        END IF;
    END PROCESS;

    -- timer
    PROCESS(CLK, RST)
    BEGIN
        IF RST = '1' THEN
            T <= '0';
        ELSIF (RISING_EDGE(CLK)) THEN
            IF (STATE_REG /= STATE_NEXT) THEN -- state is changing
                T <= 0;
            ELSIF (T /= TMAX) THEN
                T <= T + 1;
            END IF;
        END IF;
    END PROCESS;

    -- feedback register
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            R1_REG <= <INITIAL VALUE>
            R2_REG <= <INITIAL VALUE>
            ...;
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            R1_REG <= R1_NEXT;
            R2_REG <= R2_NEXT;
            ...;
        END IF;
    END PROCESS;

    -- next state logic: STATE_NEXT
    -- this is combination of the sequential design which contains the logic
    -- for the NEXT_STATE include all signals and input in sensitive list
    -- except STATE_NEXT
    PROCESS(INPUT1, INPUT2, ..., STATE_REG)
    BEGIN
        STATE_NEXT <= STATE_REG;

        OUTPUT1 <= <VALUE>;
        OUTPUT2 <= <VALUE>;
        ...;
        CASE STATE_REG IS
            WHEN S0 =>
                OUTPUT1 <= <VALUE>;
                OUTPUT2 <= <VALUE>;
                ...;
                IF (<CONDITION> AND R1_REG = <VALUE> AND T >= T1-1) THEN
                    STATE_NEXT <= S1;
                    R1_NEXT <= <VALUE>;
                    R2_NEXT <= <VALUE>;
                ELSIF (<CONDITION> AND R2_REG = <VALUE>  AND T >= T2-1) THEN
                    STATE_NEXT <= ...;
                    R1_NEXT <= <VALUE>;
                    ...;
                ELSE -- remain
                    STATE_NEXT <= S0;
                    R2_NEXT <= <VALUE>;
                    ...;
                END IF;
            WHEN S1 =>
                ...;
        END CASE;
    END PROCESS;

    -- optional: DFF (d-flipflop) to remove glitches
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            NEW_OUTPUT1 <= ...;
            NEW_OUTPUT2 <= ...;
        ELSIF (RISING_EDGE(CLK)) THEN
            NEW_OUTPUT1 <= OUTPUT1;
            NEW_OUTPUT2 <= OUTPUT2;
        END IF;
    END PROCESS;
END ARCH;


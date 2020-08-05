-- Mealy Machines - Regular Machine Template
--
-- Meher Krishna Patel says:
--
-- Moore and Mealy machines can be divided into three categories i.e. ‘regular’, ‘timed’ and ‘recursive’.
--
--
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MEALY_REGULAR IS
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
END MEALY_REGULAR;

ARCHITECTURE ARCH OF MEALY_REGULAR IS
    TYPE STATETYPE IS (S0, S1, S2,...);
    SIGNAL STATE_REG, STATE_NEXT : STATETYPE;

BEGIN

    -- state register: STATE_REG
    -- the sequential part of the design
    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            STATE_REG <= '1';
        ELSIF (CLK'EVENT AND CLK = '1') THEN
            STATE_REG <= STATE_NEXT;
        END IF;
    END PROCESS;

    -- next state logic: combinational and sequential design
    -- which contains the logic for STATE_NEXT and outputs
    -- include all signals and input in sensitivity list except STATE_NEXT
    PROCESS(INPUT1, INPUT2, ..., STATE_REG)
    BEGIN
        STATE_NEXT <= STATE_REG;

        --  default outputs
        OUTPUT1 <= <VALUE>;
        OUTPUT2 <= <VALUE>;
        ...;

        CASE STATE_REG IS
            WHEN S0 =>
                IF <CONDITION> THEN
                    OUTPUT1 <= <VALUE>;
                    OUTPUT2 <= <VALUE>;
                    ...;
                    STATE_NEXT <= S1;
                ELSIF <CONDITION> THEN
                    OUTPUT1 <= <VALUE>;
                    OUTPUT2 <= <VALUE>;
                    ...;
                    STATE_NEXT <= ...;
                ELSE -- remain in current state
                    OUTPUT1 <= <VALUE>;
                    OUTPUT2 <= <VALUE>;
                    ...;
                    STATE_NEXT <= S0;
                END IF;
            WHEN S1 =>
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

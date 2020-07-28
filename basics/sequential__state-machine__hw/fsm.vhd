-- FINITE STATE MACHINE (FSM) EXAMPLE
--
--              +------+
--              | IDLE |<---------------+
--              +------+                |
--                  |                   |
--  KEY[0]   KEY[1] | KEY[2]   ELSE     |
--    +--------+----+---+-------+       |
--    |        |        |       |       |
--    v        v        v       v       |
-- +------+ +------+ +------+ +-----+   |
-- | OPT1 | | OPT2 | | OPT3 | | ERR |   |
-- +------+ +------+ +------+ +-----+   |
--    |        |        |       |       |
--    +--------+--------+-------+-------+

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY FSM IS
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; KEY : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
    ; LED : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);
END ENTITY FSM;

ARCHITECTURE FSM_ARCH OF FSM IS
    TYPE STATETYPE IS (IDLE_STATE
        , OPTION1_STATE
        , OPTION2_STATE
        , OPTION3_STATE
        , ERROR_STATE
    );

    SIGNAL CURRENTSTATE : STATETYPE;
    SIGNAL NEXTSTATE : STATETYPE;

BEGIN

    TRANSITION_RULES : PROCESS(KEY, CURRENTSTATE)
    BEGIN
        CASE CURRENTSTATE IS
            WHEN IDLE_STATE =>
                LED <= "000";
                CASE KEY IS
                    WHEN "111" =>
                        NEXTSTATE <= IDLE_STATE;
                    WHEN "110" =>
                        NEXTSTATE <= OPTION1_STATE;
                    WHEN "101" =>
                        NEXTSTATE <= OPTION2_STATE;
                    WHEN "011" =>
                        NEXTSTATE <= OPTION3_STATE;
                    WHEN OTHERS =>
                        NEXTSTATE <= ERROR_STATE;
                END CASE;

            WHEN OPTION1_STATE =>
                LED <= "001";
                IF KEY /= "110" THEN
                    -- THIS MEANS ALSO, KEY RELEASE GOES BACK TO IDLE
                    NEXTSTATE <= IDLE_STATE;
                END IF;

            WHEN OPTION2_STATE =>
                LED <= "010";
                IF KEY /= "101" THEN
                    -- THIS MEANS ALSO, KEY RELEASE GOES BACK TO IDLE
                    NEXTSTATE <= IDLE_STATE;
                END IF;

            WHEN OPTION3_STATE =>
                LED <= "100";
                IF KEY /= "011" THEN
                    -- THIS MEANS ALSO, KEY RELEASE GOES BACK TO IDLE
                    NEXTSTATE <= IDLE_STATE;
                END IF;

            WHEN ERROR_STATE =>
                LED <= "111";
                IF KEY = "000" THEN
                    NEXTSTATE <= IDLE_STATE;
                END IF;
        END CASE;
    END PROCESS;

    TRANSITION : PROCESS(CLK, RST)
    BEGIN
        IF RST = '1' THEN
            CURRENTSTATE <= IDLE_STATE;
        ELSIF RISING_EDGE(CLK) THEN
            CURRENTSTATE <= NEXTSTATE; 
        END IF;
    END PROCESS;

END ARCHITECTURE FSM_ARCH;

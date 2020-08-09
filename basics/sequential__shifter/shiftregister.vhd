-- clocked shift register
--
-- author: Lothar Rubusch
-- based on: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

ENTITY SHIFTREGISTER IS
GENERIC(NBITS : INTEGER := 8);
PORT( CLK : IN STD_LOGIC
    ; RST : IN STD_LOGIC
    ; CTRL : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    ; DATA : IN STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);
    ; Q_REG : OUT STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);
);
END SHIFTREGISTER;

ARCHITECTURE SHIFTREGISTER_ARCH OF SHIFTREGISTER IS
    SIGNAL S_REG : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);
    SIGNAL S_NEXT : STD_LOGIC_VECTOR(NBITS-1 DOWNTO 0);

BEGIN

    PROCESS(CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            S_REG <= (OTHERS => '0');
        ELSIF (CLK'EVENT AND CLK = '1' AND RST /= '1') THEN
            S_REG <= S_NEXT;
        END IF;
    END PROCESS;

    PROCESS(CTRL, S_REG)
    BEGIN
        CASE CTRL IS
            WHEN '00' =>
                S_NEXT <= S_REG;
            WHEN '01' =>
                S_NEXT <= DATA(NBITS-1) & S_REG(NBITS-1 DOWNTO 1); -- right shift
            WHEN '10' =>
                S_NEXT <= S_REG(NBITS-2 DOWNTO 0) & DATA(0); -- left shift
            WHEN OTHERS =>
                S_NEXT <= DATA;
        END CASE

        Q_REG <= S_REG;
    END PROCESS;
END SHIFTREGISTER_ARCH;

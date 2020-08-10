-- single port ram
--
-- author: Lothar Rubusch
-- original from: https://vhdlguide.readthedocs.io/en/latest by Meher Krishna Patel

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SINGLEPORTRAM IS
GENERIC( ADDR_WIDTH : INTEGER := 2  -- total number of elements to store (put exact number)
    ; DATA_WIDTH : INTEGER := 3     -- number of bits in each element
);
PORT( CLK : IN STD_LOGIC
    ; WE : IN STD_LOGIC  -- write enable
    ; ADDR : IN STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0)  -- input port for getting address
    ; DIN : IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)   -- input data to be stored in RAM
    ; DOUT : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) -- output data read from RAM
);
END SINGLEPORTRAM;

ARCHITECTURE SINGLEPORTRAM_ARCH OF SINGLEPORTRAM IS
    TYPE RAM_TYPE IS ARRAY(2**ADDR_WIDTH-1 DOWNTO 0) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    SIGNAL RAM_SINGLE_PORT : RAM_TYPE;

BEGIN

    PROCESS(CLK)
    BEGIN
        IF (CLK'EVENT AND CLK = '1') THEN
            IF (WE = '1') THEN -- write data to address ADDR
                -- convert ADDR type to INTEGER from STD_LOGIC_VECTOR
                RAM_SINGLE_PORT(TO_INTEGER(UNSIGNED(ADDR))) <= DIN;
            ELSE
                NULL;
            END IF;
        ELSE
            NULL;
        END IF;
    END PROCESS;

    -- read data from address ADDR
    -- convert ADDR type to INTEGER from STD_LOGIC_VECTOR
    DOUT <= RAM_SINGLE_PORT(TO_INTEGER(UNSIGNED(ADDR)));
END SINGLEPORTRAM_ARCH;

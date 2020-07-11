-- HALFADDER_TB.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
    SIGNAL A, B : STD_LOGIC;       -- inputs
    SIGNAL SUM, CARRY : STD_LOGIC; -- outputs

    -- declare record type
    TYPE TEST_VECTOR IS RECORD
        A, B : STD_LOGIC;
        SUM, CARRY : STD_LOGIC;
    END RECORD;

    -- declare record array based on record type
    TYPE TEST_VECTOR_ARRAY IS ARRAY(NATURAL RANGE <>) OF TEST_VECTOR;

    CONSTANT TEST_VECTORS : TEST_VECTOR_ARRAY := (
    --    a,   b,  sum, carry (positional method is used below)
        ('0', '0', '0', '0'), -- or: (a => '0', b => '0', sum => '0', carry => '0')
        ('0', '1', '1', '0'),
        ('1', '0', '1', '0'),
        ('1', '1', '0', '1'),
        ('0', '1', '0', '1') -- FAIL TEST
    );

BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY WORK.HALFADDER_ENT PORT MAP (A => A, B=> B, SUM => SUM, CARRY => CARRY);

    TB1 : PROCESS
    BEGIN
        FOR I IN TEST_VECTORS'RANGE LOOP
            A <= TEST_VECTORS(I).A;     -- signal a = i^th-row-value of test_vector's a
            B <= TEST_VECTORS(I).B;

            WAIT FOR 20 NS;

            ASSERT ((SUM = TEST_VECTORS(I).SUM) AND (CARRY = TEST_VECTORS(I).CARRY))
                -- IMAGE() is used for string-representation of integer etc.
                REPORT "TEST_VECTOR " & INTEGER'IMAGE(I) & " FAILED " &
                " FOR INPUT A = " & STD_LOGIC'IMAGE(A) &
                " AND B = " & STD_LOGIC'IMAGE(B)
                SEVERITY ERROR;
        END LOOP;
        WAIT;
    END PROCESS;

END TB;

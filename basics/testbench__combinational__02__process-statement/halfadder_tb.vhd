-- HALFADDER_TB.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HALFADDER_ENT_TB IS
END HALFADDER_ENT_TB;

ARCHITECTURE TB OF HALFADDER_ENT_TB IS
    SIGNAL A, B : STD_LOGIC;       -- inputs
    SIGNAL SUM, CARRY : STD_LOGIC; -- outputs
BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY WORK.HALFADDER_ENT PORT MAP (A => A, B=> B, SUM => SUM, CARRY => CARRY);

    TB1 : PROCESS
    CONSTANT PERIOD : TIME := 20 NS;
    BEGIN
        A <= '0';
        B <= '0';
        WAIT FOR PERIOD;
        ASSERT ((SUM = '0') AND (CARRY = '0')) --EXPECTED OUTPUT
        -- ERROR WILL BE REPORTED IF SUM OR CARRY IS NOT '0'
        REPORT "TEST FAILED FOR INPUT COMBINATION 01" SEVERITY ERROR;
        
        A <= '0';
        B <= '1';
        WAIT FOR PERIOD;
        ASSERT ((SUM = '1') AND (CARRY = '0'));
        REPORT "TEST FAILED FOR INPUT COMBINATION 01" SEVERITY ERROR;
        
        
    -- inputs
    -- 00 at 0 ns
    -- 01 at 20 ns, as b is 0 at 20 ns and a is changed to 1 at 20 ns
    -- 10 at 40 ns
    -- 11 at 60 ns
    A <= '0', '1' AFTER 20 NS, '0' AFTER 40 NS, '1' AFTER 60 NS;
    B <= '0', '1' AFTER 40 NS;
END TB;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blinky_ent is
port(
	clock_50  : in std_logic;
	reset_n : in std_logic := '1';
	led    : out std_logic_vector(7 downto 0) -- no ';' at the last port entry!
);
end entity blinky_ent;

architecture blinky_arch of blinky_ent is
	signal clk_blinky     : std_logic;
	signal counter_blinky : integer range 0 to 25000000;
	signal led_blinky     : std_logic; 

	-- macro using pragma trick: for setting different values for sim and synth
	function clock_frequency return natural is
	begin
		-- synthesis translate_off
		return 50;
		-- synthesis translate_on
		return 50000000;
	end clock_frequency;
	
	constant clk_frq : integer := clock_frequency;

begin

	p1 : process(clock_50, reset_n)
	variable counter : integer := 0;
	variable led_num : integer := 0;
	begin
		if reset_n = '0' then
			clk_blinky <= '0';
			counter := 0;
		elsif rising_edge(clock_50) then
			counter := counter + 1;
			if counter < clk_frq then
				led(0) <= '1';
			elsif counter >= clk_frq and counter < 2*clk_frq then
				led(0) <= '0';
			else
				counter := 0;
			end if;
		end if;
	end process p1;

end architecture blinky_arch;
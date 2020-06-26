library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blinky is
port(
--- application
    LED                            : out   std_logic_vector(7 downto 0);
--- FPGA ---
	FPGA_CLK_50                    : in    std_logic;                                        -- 
--- HPS ---
    HPS_SD_CMD                     : inout std_logic;                                        -- hps_io_sdio_inst_CMD
    HPS_SD_DATA                    : INOUT std_logic_vector(3 downto 0);                     -- hps_io_sdio_inst_D0, hps_io_sdio_inst_D1, hps_io_sdio_inst_D2, hps_io_sdio_inst_D3
    HPS_SD_CLK                     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
--- HPS: memory ---	 
    HPS_DDR3_ADDR                  : out   std_logic_vector(12 downto 0);                    -- mem_a
    HPS_DDR3_BA                    : out   std_logic_vector(2 downto 0);                     -- mem_ba
    HPS_DDR3_CK_P                  : out   std_logic;                                        -- mem_ck
    HPS_DDR3_CK_N                  : out   std_logic;                                        -- mem_ck_n
    HPS_DDR3_CKE                   : out   std_logic;                                        -- mem_cke
    HPS_DDR3_CS_N                  : out   std_logic;                                        -- mem_cs_n
    HPS_DDR3_RAS_N                 : out   std_logic;                                        -- mem_ras_n
    HPS_DDR3_CAS_N                 : out   std_logic;                                        -- mem_cas_n
    HPS_DDR3_WE_N                  : out   std_logic;                                        -- mem_we_n
    HPS_DDR3_RESET_N               : out   std_logic;                                        -- mem_reset_n
    HPS_DDR3_DQ                    : inout std_logic_vector(7 downto 0);                     -- mem_dq
    HPS_DDR3_DQS_P                 : inout std_logic;                                        -- mem_dqs
    HPS_DDR3_DQS_N                 : inout std_logic;                                        -- mem_dqs_n
    HPS_DDR3_ODT                   : out   std_logic;                                        -- mem_odt
    HPS_DDR3_DM                    : out   std_logic;                                        -- mem_dm
    HPS_DDR3_RZQ                   : in    std_logic                                         -- oct_rzqin
);
end entity blinky;



architecture main of blinky is

signal RESET_N : std_logic := '1';

component blinky_comp is
port (
    clk_clk                        : in    std_logic                     := 'X';
    led_external_connection_export : out   std_logic_vector(7 downto 0);
    hps_io_hps_io_sdio_inst_CMD    : inout std_logic                     := 'X';
    hps_io_hps_io_sdio_inst_D0     : inout std_logic                     := 'X';
    hps_io_hps_io_sdio_inst_D1     : inout std_logic                     := 'X';
    hps_io_hps_io_sdio_inst_D2     : inout std_logic                     := 'X';
    hps_io_hps_io_sdio_inst_D3     : inout std_logic                     := 'X';
    hps_io_hps_io_sdio_inst_CLK    : out   std_logic;
    memory_mem_a                   : out   std_logic_vector(12 downto 0);
    memory_mem_ba                  : out   std_logic_vector(2 downto 0);
    memory_mem_ck                  : out   std_logic;
    memory_mem_ck_n                : out   std_logic;
    memory_mem_cke                 : out   std_logic;
    memory_mem_cs_n                : out   std_logic;
    memory_mem_ras_n               : out   std_logic;
    memory_mem_cas_n               : out   std_logic;
    memory_mem_we_n                : out   std_logic;
    memory_mem_reset_n             : out   std_logic;
    memory_mem_dq                  : inout std_logic_vector(7 downto 0)  := (others => 'X');
    memory_mem_dqs                 : inout std_logic                     := 'X';
    memory_mem_dqs_n               : inout std_logic                     := 'X';
    memory_mem_odt                 : out   std_logic;
    memory_mem_dm                  : out   std_logic;
    memory_oct_rzqin               : in    std_logic                     := 'X';
    reset_reset_n                  : in    std_logic                     := '1'
);
end component blinky_comp;

----- uses pragmas: for setting different values for sim and synth
function clock_freq return natural is
begin
	-- synthesis translate_off
	return 50;
	-- synthesis translate_on
	return 50000000;
	
end clock_freq;

constant CLK_FRQ : integer := clock_freq;

begin

u0 : component blinky_comp
port map (
    led_external_connection_export => LED,
    clk_clk                        => FPGA_CLK_50,
    hps_io_hps_io_sdio_inst_CMD    => HPS_SD_CMD,
    hps_io_hps_io_sdio_inst_D0     => HPS_SD_DATA(0),
    hps_io_hps_io_sdio_inst_D1     => HPS_SD_DATA(1),
    hps_io_hps_io_sdio_inst_D2     => HPS_SD_DATA(2),
    hps_io_hps_io_sdio_inst_D3     => HPS_SD_DATA(3),
    hps_io_hps_io_sdio_inst_CLK    => HPS_SD_CLK,
    memory_mem_a                   => HPS_DDR3_ADDR,
    memory_mem_ba                  => HPS_DDR3_BA,
    memory_mem_ck                  => HPS_DDR3_CK_P,
    memory_mem_ck_n                => HPS_DDR3_CK_N,
    memory_mem_cke                 => HPS_DDR3_CKE,
    memory_mem_cs_n                => HPS_DDR3_CS_N,
    memory_mem_ras_n               => HPS_DDR3_RAS_N,
    memory_mem_cas_n               => HPS_DDR3_CAS_N,
    memory_mem_we_n                => HPS_DDR3_WE_N,
    memory_mem_reset_n             => HPS_DDR3_RESET_N,
    memory_mem_dq                  => HPS_DDR3_DQ,
    memory_mem_dqs                 => HPS_DDR3_DQS_P,
    memory_mem_dqs_n               => HPS_DDR3_DQS_N,
    memory_mem_odt                 => HPS_DDR3_ODT,
    memory_mem_dm                  => HPS_DDR3_DM,
    memory_oct_rzqin               => HPS_DDR3_RZQ,
    reset_reset_n                  => RESET_N                   --                  reset.reset_n
);


p1 : process(FPGA_CLK_50)
variable counter : integer := 0;
variable led_num : integer := 0;
begin
    -- init
	LED(0) <= '0';
    -- sync part
    if rising_edge(FPGA_CLK_50) then
	    counter := counter + 1;
		if counter < CLK_FRQ then
			LED(0) <= '1';
	    elsif counter >= CLK_FRQ and counter < 2*CLK_FRQ then
		    LED(0) <= '0';
		else
			counter := 0;
		end if;
	end if;
            
end process p1;

end architecture main;

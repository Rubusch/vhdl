set_global_assignment -entity "SDRAM_CLK_ALTPLL" -library "lib_SDRAM_CLK_ALTPLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "SDRAM_CLK_ALTPLL" -library "lib_SDRAM_CLK_ALTPLL" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "SDRAM_CLK_ALTPLL" -library "lib_SDRAM_CLK_ALTPLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_SDRAM_CLK_ALTPLL" -name SPD_FILE [file join $::quartus(sip_path) "SDRAM_CLK_ALTPLL.spd"]

set_global_assignment -library "lib_SDRAM_CLK_ALTPLL" -name MISC_FILE [file join $::quartus(sip_path) "SDRAM_CLK_ALTPLL_sim/SDRAM_CLK_ALTPLL.vho"]

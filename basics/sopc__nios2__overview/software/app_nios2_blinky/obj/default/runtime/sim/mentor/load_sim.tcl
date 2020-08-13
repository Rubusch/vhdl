# ------------------------------------------------------------------------------
# Top Level Simulation Script to source msim_setup.tcl
# ------------------------------------------------------------------------------
set QSYS_SIMDIR obj/default/runtime/sim
source msim_setup.tcl
# Copy generated memory initialization hex and dat file(s) to current directory
file copy -force /opt/github__vhdl/basics/sopc__nios2__overview/software/app_nios2_blinky/mem_init/hdl_sim/nios2_blinky_ram.dat ./ 
file copy -force /opt/github__vhdl/basics/sopc__nios2__overview/software/app_nios2_blinky/mem_init/nios2_blinky_ram.hex ./ 

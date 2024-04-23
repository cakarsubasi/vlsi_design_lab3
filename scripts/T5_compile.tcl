sh date

############################i
##  Source RTL FILE paths ##
############################
source ./rtl.tcl

##########################################
##  Setup logic and milkyway libraries  ##
##########################################
source ./scripts/setup.tcl

################
##  READ RTL  ##
################
set top_module fpmul1

analyze -format vhdl -define RUNDC -lib work ${rtl_files}

elaborate ${top_module} -lib WORK

###############################
##  READ TIMING CONSTRAINTS  ##
###############################
set PERIOD 2.0
#create_clock -name "CLK" -period $PERIOD [get_ports clk]
create_clock -name "CLK" -period 2 -waveform { 0.000 1.000  }  { CLOCK  }

current_design ${top_module}
uniquify
link

#######################
##      Compile      ##
#######################
current_design ${top_module}
compile

################
##  DATA OUT  ##
################
change_names -rule verilog -hier
write -f verilog -h -out ./db/compile.v
write -f ddc -h -out ./db/compile.ddc
write_sdc -nosplit ./db/compile.sdc
write_link -nosplit -out ./db/compile.link
set mw_design_library ./MW_FPMULT
write_milkyway -out compile -over

## REPORT
#########
check_mv_design -verbose > ./report/mv_check_compile.rpt

report_cell > ./report/${top_module}-compile_cells.rpt
report_area > ./report/${top_module}-compile_area.rpt

#report_hier -nosplit -noleaf

report_timing -att \
              -net \
              -trans \
              -cap \
              -input \
              -nosplit > ./report/${top_module}-compile_timing.rpt

report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 3 -sort_by group > ./report/${top_module}-compile_cp.rpt

report_power -hier -hier_level 1 -verb > ./report/${top_module}-compile_power.rpt

sh date

exit

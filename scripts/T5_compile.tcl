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
set top_module fp32mul_pipe
set module_name ${top_module}-${PERIOD}

analyze -format vhdl -define RUNDC -lib work ${rtl_files}

elaborate ${top_module} -lib WORK

###############################
##  READ TIMING CONSTRAINTS  ##
###############################
#set PERIOD 1.0
#create_clock -name "CLK" -period $PERIOD [get_ports clk]
create_clock -name "CLK" -period ${PERIOD} { CLOCK }

current_design ${top_module}
uniquify
link

#######################
##      Compile      ##
#######################
current_design ${top_module}
compile_ultra

################
##  DATA OUT  ##
################
sh mkdir -p db
sh mkdir -p MW_FPMULT

change_names -rule verilog -hier
write -f verilog -h -out ./db/${module_name}-compile.v
write -f ddc -h -out ./db/${module_name}-compile.ddc
write_sdc -nosplit ./db/${module_name}-compile.sdc
write_link -nosplit -out ./db/${module_name}-compile.link
set mw_design_library ./MW_FPMULT
write_milkyway -out compile -over

## REPORT
#########
sh mkdir -p Report

check_mv_design -verbose > ./Report/${module_name}-mv_check_compile.rpt

report_cell > ./Report/${module_name}-compile_cells.rpt
report_area > ./Report/${module_name}-compile_area.rpt

#report_hier -nosplit -noleaf

report_timing -att \
              -net \
              -trans \
              -cap \
              -input \
              -nosplit > ./Report/${module_name}-compile_timing.rpt

report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 3 -sort_by group > ./Report/${module_name}-compile_cp.rpt

report_power -hier -hier_level 1 -verb > ./Report/${module_name}-compile_power.rpt

sh date

exit

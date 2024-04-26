sh date

############################i
##  Source RTL FILE paths ##
############################
source ./rtl.tcl

################
##  READ RTL  ##
################
set top_module fp32mul_pipe

analyze -format vhdl -define RUNDC -lib work ${rtl_files}

elaborate ${top_module} -lib WORK

###############################
##  READ TIMING CONSTRAINTS  ##
###############################
set PERIOD 1.0
create_clock -name "CLK" -period 1.0 -waveform { 0.000 0.500  }  { CLOCK  }

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

write -hierarchy -format ddc -output ${top_module}-syn.ddc
write -hierarchy -format verilog -output ${top_module}-syn.v
write_sdf ${top_module}-syn.sdf


## REPORT
#########

report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 3 -sort_by group > ./Report/${top_module}-syn_cp.txt

report_area > ./Report/${top_module}-syn_area.rpt

report_power -hier -hier_level 1 -verb > ./Report/${top_module}-syn_power.rpt

sh date

exit

sh date

############################i
##  Source RTL FILE paths ##
############################
source ./rtl.tcl

################
##  READ RTL  ##
################
set top_module shiftreg

set target_dir "./"

analyze -format vhdl -define RUNDC -lib work ${rtl_files}

elaborate ${top_module} -lib WORK

###############################
##  READ TIMING CONSTRAINTS  ##
###############################

#create_clock -name "CLOCK" -period PERIOD -waveform { 0.000 1.000  }  { CLOCK  }
current_design ${top_module}

set waveforms 0.0
set half_period [expr ${PERIOD} / 2]
append waveforms " " half_period
create_clock -name "CLK" -period ${PERIOD} { CLOCK }

# Usage not recommended LMAO
set_max_dynamic_power 0
set_max_leakage_power 0

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
#write -hierarchy -format ddc     -output ${target_dir}${top_module}-${shiftreg_type}-${PERIOD}-syn.ddc
#write -hierarchy -format verilog -output ${target_dir}${top_module}-${shiftreg_type}-${PERIOD}-syn.v
#write -hierarchy -format vhdl    -output ${target_dir}${top_module}-${shiftreg_type}-${PERIOD}-syn.vhdl
write -hierarchy -format ddc     -output ${target_dir}${shiftreg_type}-syn.ddc
write -hierarchy -format verilog -output ${target_dir}${shiftreg_type}-syn.v
write -hierarchy -format vhdl    -output ${target_dir}${shiftreg_type}-syn.vhdl
write_sdf ${target_dir}${top_module}-syn.sdf


## REPORT
#########

report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 3 -sort_by group > ./report/${top_module}-syn_cp-${shiftreg_type}-${PERIOD}.txt
report_area > ./report/${top_module}-syn_area-${shiftreg_type}-${PERIOD}.rpt
report_power -hier -hier_level 1 -verb > ./report/${top_module}-syn_power-${shiftreg_type}-${PERIOD}.rpt

sh date

exit

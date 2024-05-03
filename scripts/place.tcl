sh date

##########################################
##  Setup logic and milkyway libraries  ##
##########################################
  
  #source ./scripts/setup.tcl

#####################
##  open pna cell  ##
#####################

set top_module fp32mul_pipe

set module_name ${top_module}-${PERIOD}

  copy_mw_cel -from ${module_name}-floorplan -to ${module_name}-place
  open_mw_cel ${module_name}-place
  link
  link_physical

##################
## PLACE DESIGN ##
##################
 
   place_opt -power
   legalize_placement	

##########################
## CLOCK TREE SYNTHESIS ##
##########################

   clock_opt
   legalize_placement

##################
## ROUTE DESIGN ##
##################

   route_opt
   check_routeability

###############
## DUMP DATA ##
###############
sh mkdir -p db

  change_names -rule verilog -hier
  write_sdc -nosplit ./db/${module_name}-place.sdc
  write_script -nosplit -o ./db/${module_name}-place.script
  write_verilog ${module_name}-place.v
  write_sdf ${module_name}-place.sdf
  write_link -nosplit -out ./db/${module_name}-place.link
  save_mw_cel -over

###############
## REPORTING ##
###############
sh mkdir -p Report

  report_area -ph > ./Report/${module_name}-place_area.txt

  report_timing -att \
                -net \
                -trans \
                -cap \
                -input \
                -nosplit > ./Report/${module_name}-place_timing.txt

  report_net -physical > ./Report/${module_name}-route_nets.rpt	

  report_cell -physical -nosplit > ./Report/${module_name}-route_phy.rpt
		
  report_hier -nosplit -nolea > ./Report/${module_name}-route_hier.rpt
  report_power -hier -hier_level 1 -verb > ./Report/${module_name}-place_power.txt
  report_qor > ./Report/${module_name}-place_qor.rpt
  
  report_timing -path full -delay max -nworst 1 -max_paths 1 \
     -significant_digits 3 -sort_by group > ./Report/${module_name}-place_cp.txt

sh date

#exit

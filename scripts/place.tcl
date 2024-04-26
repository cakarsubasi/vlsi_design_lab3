sh date

##########################################
##  Setup logic and milkyway libraries  ##
##########################################
  
  #source ./scripts/setup.tcl

#####################
##  open pna cell  ##
#####################

set top_module fp32mul_pipe

  copy_mw_cel -from ${top_module}-floorplan -to ${top_module}-place
  open_mw_cel ${top_module}-place
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

  change_names -rule verilog -hier
  write_sdc -nosplit ./db/place.sdc
  write_script -nosplit -o ./db/place.script
  write_verilog ${top_module}-place.v
  write_sdf ${top_module}-place.sdf
  write_link -nosplit -out ./db/place.link
  save_mw_cel -over

###############
## REPORTING ##
###############

  report_area -ph > ./Report/${top_module}-place_area.txt

  report_timing -att \
                -net \
                -trans \
                -cap \
                -input \
                -nosplit > ./Report/${top_module}-place_timing.txt

  report_net -physical > ./Report/route_nets.rpt	

  report_cell -physical -nosplit > ./Report/route_phy.rpt
		
  report_hier -nosplit -nolea > ./Report/route_hier.rpt
  report_power -hier -hier_level 1 -verb > ./Report/${top_module}-place_power.txt
  report_qor > ./Report/place_qor.rpt
  
  report_timing -path full -delay max -nworst 1 -max_paths 1 \
     -significant_digits 3 -sort_by group > ./Report/${top_module}-place_cp.txt

sh date

#exit

sh date

##########################################
##  Setup logic and milkyway libraries  ##
##########################################
  
  #source ./scripts/setup.tcl

#####################
##  open pna cell  ##
#####################

  copy_mw_cel -from floorplan -to place
  open_mw_cel place
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

  set top_module shiftreg

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

  report_area -ph > ./report/${top_module}-place_area.txt

  report_timing -att \
                -net \
                -trans \
                -cap \
                -input \
                -nosplit > ./report/${top_module}-place_timing.txt

  report_net -physical > ./report/route_nets.rpt	

  report_cell -physical -nosplit > ./report/route_phy.rpt
		
  report_hier -nosplit -nolea > ./report/route_hier.rpt
  report_power -hier -hier_level 1 -verb > ./report/${top_module}-place_power.txt
  report_qor > ./report/place_qor.rpt
  
  report_timing -path full -delay max -nworst 1 -max_paths 1 \
     -significant_digits 3 -sort_by group > ./report/${top_module}-place_cp.txt

sh date

#exit

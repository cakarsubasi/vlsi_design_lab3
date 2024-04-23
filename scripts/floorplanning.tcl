sh date

##########################################
##  Setup logic and milkyway libraries  ##
##########################################
  
  #source ./scripts/setup.tcl

#####################
##  open dft cell  ##
#####################

  copy_mw_cel -from compile -to floorplan
  open_mw_cel floorplan
  link
  link_physical

###########################
##  Floorplan generation ##
###########################
  
# patch AN 28/02/2020
set_fp_strategy -unit_tile_name unit

create_floorplan -control_type  aspect_ratio  \
  		       -core_aspect_ratio 1.0 \
			-core_utilization 0.7 \
		       -left_io2core 10 \
		       -bottom_io2core 10 \
		       -right_io2core 10 \
		       -top_io2core 10 


derive_pg_connection -power_net VDD -ground_net VSS

#################
##  Placement  ##
#################
		  
 create_fp_placement		  

###############################
##  Power Network Synthesis  ##
###############################
create_rectangular_rings  -nets  {VDD VSS} \
                          -left_offset 1 -left_segment_layer M4 -left_segment_width 2 -extend_ll -extend_lh \
			  -right_offset 1 -right_segment_layer M4 -right_segment_width 2 -extend_rl -extend_rh \
			  -bottom_offset 1 -bottom_segment_layer M3 -bottom_segment_width 2 -extend_bl -extend_bh \
			  -top_offset 1 -top_segment_layer M3 -top_segment_width 2 -extend_tl -extend_th -offsets absolute

create_power_straps  -nets  {VDD} \
                     -layer M4 \
		     -width 2 \
                     -direction vertical \
                     -start_at 31.2 \
                     -num_placement_strap 2 \
		     -increment_x_or_y 147 
		     


create_preroute_vias  -nets  {VDD} \
                      -from_layer M4 \
		      -from_object_strap \
		      -to_object_std_pin_connection \
		      -to_object_std_pin \
		      -within {{-22.235 -4.945} {217.200 220.495}}


set_fp_rail_constraints  -skip_ring -extend_strap core_ring
set_fp_rail_constraints -add_layer  -layer M6 -direction horizontal -max_strap 32 -min_strap 2 -min_width 0.2 -spacing minimum
set_fp_rail_constraints -add_layer  -layer M5 -direction vertical -max_strap 32 -min_strap 2 -min_width 0.2 -spacing minimum
###############
##  PNS VSS  ##
###############

synthesize_fp_rail  -nets {VSS} -power_budget 2 -voltage_supply 1.0 -use_pins_as_pads

commit_fp_rail

##############
## PNS VDD  ##
##############

#set_fp_rail_voltage_area_constraints -net  {VDD} \
#                                     -power_budget 1 \
#                                     -voltage_supply 1.0
				     
synthesize_fp_rail -use_pins_as_pads -nets {VDD} -target_voltage_drop 200.0
commit_fp_rail

preroute_standard_cells -nets  {VDD VSS}  -connect horizontal   \
                                          -port_filter_mode off -cell_master_filter_mode off \
					  -cell_instance_filter_mode off \
					  -voltage_area_filter_mode select


remove_stdcell_filler -stdcell
					  
save_mw_cel -increase_version

close_mw_cel

sh date

#exit

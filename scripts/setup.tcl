###################################
# DEFINE WORKING MILKYWAY LIBRARY #
###################################
set MW_WORK_DIR "MW_FPMUL"



#define_design_lib WORK -path "./WORK"

set lib_path "/cell_libs/cmos090_50a"

set mw_reference_library " \
	$lib_path/adv_AvantiTechnoKit_cmos090_7M2T_M2V_AP_5.1/COMMON/UnitTile/unitTile_STD/ \
	$lib_path/CORE90GPSVT_SNPS-AVT_2.1/AVANTI/PR/bc_1.10V_m40C_wc_0.90V_105C/CORE90GPSVT \
  $lib_path/CORE90GPHVT_SNPS-AVT_2.1.a/AVANTI/PR/bc_1.10V_m40C_wc_0.90V_105C/CORE90GPHVT"

set search_path "\
	$lib_path/CORE90GPSVT_SNPS-AVT_2.1/SIGNOFF/bc_1.10V_m40C_wc_0.90V_105C/PT_LIB \
  $lib_path/CORE90GPHVT_SNPS-AVT_2.1.a/SIGNOFF/bc_1.10V_m40C_wc_0.90V_105C/PT_LIB"


set target_library    "\
	CORE90GPSVT_NomLeak.db \
  CORE90GPHVT_NomLeak.db"

set link_library "* $target_library dw_foundation.sldb"

set TECH_FILE $lib_path/adv_AvantiTechnoKit_cmos090_7M2T_M2V_AP_5.1/COMMON/tech.tf
set mw_design_library $MW_WORK_DIR

set mw_power_net  VDD
set mw_ground_net VSS
set mw_power_port VDD
set mw_ground_port VSS
set mw_logic1_net VDD
set mw_logic0_net VSS

set report_default_significant_digits 6

# Design creation 

if { [file exist ./$MW_WORK_DIR]} {
  echo " -- MW Design Lib found, then reading it (open_mw_lib)"
  set_mw_lib_reference -mw_reference_library\
                       $mw_reference_library ./$MW_WORK_DIR
  open_mw_lib ./$MW_WORK_DIR
} else {
  echo "-- CREATE NEW MW DESIGN LIB (create_mw_lib)"
  create_mw_lib -tech $TECH_FILE ./$MW_WORK_DIR
  set_mw_lib_reference -mw_reference_library\
                       $mw_reference_library ./$MW_WORK_DIR
  open_mw_lib ./$MW_WORK_DIR
}

set_tlu_plus_files \
          -max_tluplus $lib_path/adv_AvantiTechnoKit_cmos090_7M2T_M2V_AP_5.1/TLUPLUS/max/tluplus \
          -min_tluplus $lib_path/adv_AvantiTechnoKit_cmos090_7M2T_M2V_AP_5.1/TLUPLUS/min/tluplus \
          -tech2itf_map $lib_path/adv_AvantiTechnoKit_cmos090_7M2T_M2V_AP_5.1/TLUPLUS/mapfile
	  
suppress_message {PSYN-040}
suppress_message {PSYN-650}
suppress_message {PSYN-651}
suppress_message {MWLIBP-324}
suppress_message {MWLIBP-301}
suppress_message {LIBG-36}


set derive_default_routing_layer_direction true


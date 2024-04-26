rtl_files_list = "./rtl_files_here.list"
top_level_file = "./top_level_file.txt"

# Behavorial simulation:
# make sim-cmd

compile:
	vhdlan -full64 `cat ${rtl_files_list}`
	vhdlan -full64 `cat ${top_level_file}`

compile-gui:
	vhdlan -kdb -full64 `cat ${rtl_files_list}`
	vhdlan -kdb -full64 `cat ${top_level_file}`

simv-cmd: compile
	vcs -full64 -debug_access+all E +neg_tchk

simv-gui: compile-gui
	vcs -kdb -full64 -debug_access+all E +neg_tchk

sim-cmd: simv-cmd
	./simv -ucli	

sim-gui: simv-gui
	./simv -gui

synth-build:
	dc_shell -f ./scripts/T3_synthesis.tcl

synth-sim: compile synth-build
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPSVT_SNPS-AVT_2.1/VERILOG_LD/CORE90GPSVT.v
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPHVT_SNPS-AVT_2.1.a/VERILOG_LD/CORE90GPHVT.v
	vlogan -full64 shiftreg-gated-syn.v 
	vhdlan -full64 ${top_level_file}
	vcs -full64 -debug_access+all -sdf typ:E/UUT:shiftreg-syn.sdf E +neg_tchk +sdfverbose 
#	./simv -ucli -include saif.cmd
	
synth-phys:
	dc_shell -topo -f ./scripts/T5_compile.tcl

floorplan:
	icc_shell -no_gui -shared_license -f ./scripts/plan_and_place.tcl

clean:
	rm -rf AN.DB 64 simv* csrc work.lib++ alib-52 ARCH CONF ENTI WORK command.log default.svf filenames.log



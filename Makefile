rtl_files_list = "./rtl_files_here.list"
top_level_file = "./top_level_file.txt"

# Just compile, good for checking vhdl syntax errors
compile:
	vhdlan -full64 `cat ${rtl_files_list}`
	vhdlan -full64 `cat ${top_level_file}`

compile-gui:
	vhdlan -kdb -full64 `cat ${rtl_files_list}`
	vhdlan -kdb -full64 `cat ${top_level_file}`

# Create a simv file for simulation
simv-cmd: compile
	vcs -full64 -debug_access+all E +neg_tchk

simv-gui: compile-gui
	vcs -kdb -full64 -debug_access+all E +neg_tchk

# Run a simulation
sim-cmd: simv-cmd
	./simv -ucli	

sim-gui: simv-gui
	./simv -gui

# Run the synthesis script to build the file and generate reports
synth-build:
	dc_shell -x "set PERIOD 1.0" -f ./scripts/T3_synthesis.tcl
	
# Run a physical synthesis script that is "higher quality"
synth-phys:
	dc_shell -topo -x "set PERIOD 1.0" -f ./scripts/T5_compile.tcl

# Needs source icc_env.tcsh
# Run the plan and place script
floorplan:
	icc_shell -no_gui -shared_license -f ./scripts/plan_and_place.tcl

# Run synthesis script for 4 periods
synth-power:
	dc_shell -x "set PERIOD 1.0" -f ./scripts/T3_synthesis.tcl
	dc_shell -x "set PERIOD 1.25" -f ./scripts/T3_synthesis.tcl
	dc_shell -x "set PERIOD 1.5" -f ./scripts/T3_synthesis.tcl
	dc_shell -x "set PERIOD 2.0" -f ./scripts/T3_synthesis.tcl

# Run physical synthesis script for 4 periods
synth-phys-power:
	dc_shell -topo -x "set PERIOD 1.0"  -f ./scripts/T5_compile.tcl
	dc_shell -topo -x "set PERIOD 1.25" -f ./scripts/T5_compile.tcl
	dc_shell -topo -x "set PERIOD 1.5"  -f ./scripts/T5_compile.tcl
	dc_shell -topo -x "set PERIOD 2.0"  -f ./scripts/T5_compile.tcl

# Run plan and place script for 4 periods
floorplan-power:
	icc_shell -no_gui -shared_license -x "set PERIOD 1.0" -f ./scripts/plan_and_place.tcl
	icc_shell -no_gui -shared_license -x "set PERIOD 1.25" -f ./scripts/plan_and_place.tcl
	icc_shell -no_gui -shared_license -x "set PERIOD 1.5" -f ./scripts/plan_and_place.tcl
	icc_shell -no_gui -shared_license -x "set PERIOD 2.0" -f ./scripts/plan_and_place.tcl

# Run post synthesis power simulation
post-syn-power-sim:
	$(eval DESIGN := fp32mul_pipe-1.0-syn)
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPSVT_SNPS-AVT_2.1/VERILOG_LD/CORE90GPSVT.v
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPHVT_SNPS-AVT_2.1.a/VERILOG_LD/CORE90GPHVT.v
	vlogan -full64 ./db/${DESIGN}.v 
	vhdlan -full64 tb_s_fpmul1.vhd
	vcs -full64 -debug_access+all -sdf typ:E/UUT:./db/${DESIGN}.sdf E +neg_tchk +sdfverbose
	./simv -ucli -include saif_post.cmd
	mv fp32mul_pipe-place.saif ./Report/${DESIGN}.saif

# Run post placement simulation to generate saif files for four designs
post-plan-power-sim:
	$(eval DESIGN := fp32mul_pipe-1.0-place)
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPSVT_SNPS-AVT_2.1/VERILOG_LD/CORE90GPSVT.v
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPHVT_SNPS-AVT_2.1.a/VERILOG_LD/CORE90GPHVT.v
	vlogan -full64 ./db/${DESIGN}.v
	vhdlan -full64 tb_s_fpmul1.vhd
	vcs -full64 -debug -sdf typ:E/UUT:./db/${DESIGN}.sdf E +neg_tchk +sdfverbose
	./simv -ucli -include saif_post.cmd
	mv fp32mul_pipe-place.saif ./Report/${DESIGN}.saif
	$(eval DESIGN := fp32mul_pipe-1.25-place)
	vlogan -full64 ./db/${DESIGN}.v
	vhdlan -full64 tb_s_fpmul1.vhd
	vcs -full64 -debug -sdf typ:E/UUT:./db/${DESIGN}.sdf E +neg_tchk +sdfverbose
	./simv -ucli -include saif_post.cmd
	mv fp32mul_pipe-place.saif ./Report/${DESIGN}.saif
	$(eval DESIGN := fp32mul_pipe-1.5-place)
	vlogan -full64 ./db/${DESIGN}.v
	vhdlan -full64 tb_s_fpmul1.vhd
	vcs -full64 -debug -sdf typ:E/UUT:./db/${DESIGN}.sdf E +neg_tchk +sdfverbose
	./simv -ucli -include saif_post.cmd
	mv fp32mul_pipe-place.saif ./Report/${DESIGN}.saif
	$(eval DESIGN := fp32mul_pipe-2.0-place)
	vlogan -full64 ./db/${DESIGN}.v
	vhdlan -full64 tb_s_fpmul1.vhd
	vcs -full64 -debug -sdf typ:E/UUT:./db/${DESIGN}.sdf E +neg_tchk +sdfverbose
	./simv -ucli -include saif_post.cmd
	mv fp32mul_pipe-place.saif ./Report/${DESIGN}.saif

# Use the saif files to generate power consumption report
post-plan-power-generate:
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPSVT_SNPS-AVT_2.1/VERILOG_LD/CORE90GPSVT.v
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPHVT_SNPS-AVT_2.1.a/VERILOG_LD/CORE90GPHVT.v
	dc_shell -x "set top_level fp32mul_pipe-1.0" -f ./scripts/post_syn_power.tcl
	dc_shell -x "set top_level fp32mul_pipe-1.25" -f ./scripts/post_syn_power.tcl
	dc_shell -x "set top_level fp32mul_pipe-1.5" -f ./scripts/post_syn_power.tcl
	dc_shell -x "set top_level fp32mul_pipe-2.0" -f ./scripts/post_syn_power.tcl

# Copy the relevant files to the appendix
prepare-appendix:
	cp fp32mul_pipe.vhd Report/
	cp significand_compute_pipe.vhd Report/
	cp regnb.vhd Report/
	cp tb_s_fpmul1.vhd Report/tb_fp32mul_pipe.vhd
	cp db/fp32mul_pipe-1.0-syn.ddc Report/fp32mul_pipe_syn.ddc
	cp db/fp32mul_pipe-1.0-syn.v Report/fp32mul_pipe_syn.v
	cp db/fp32mul_pipe-1.0-syn.sdf  Report/fp32mul_pipe_syn.sdf
	cp Report/fp32mul_pipe-1.0-syn.saif  Report/fp32mul_pipe_syn.saif
	cp db/fp32mul_pipe-1.0-place.v Report/fp32mul_pipe_layout.v
	cp db/fp32mul_pipe-1.0-place.sdf  Report/fp32mul_pipe_layout.sdf
	cp Report/fp32mul_pipe-1.0-place.saif  Report/fp32mul_pipe_layout.saif

clean:
	rm -rf AN.DB 64 simv* csrc work.lib++ alib-52 ARCH CONF ENTI WORK command.log default.svf filenames.log



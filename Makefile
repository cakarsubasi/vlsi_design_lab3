rtl_files_list = "./rtl_files_here.list"
top_level_file = "./top_level_file.txt"
top_level_type = `cat "type.txt"`

# Behavorial simulation:
# make shift compile
# make sim-cmd


shift:
	cat shift.list > ${rtl_files_list}
	echo tb_shiftreg.vhd > top_level_file.txt
	echo shiftreg > type.txt
	cp shiftreg_rtl.tcl rtl.tcl

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
	dc_shell -x "set PERIOD 1.0; set shiftreg_type ${top_level_type}" -f ./scripts/T3_synthesis.tcl
# need to also add 

synth-sim: compile synth-build
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPSVT_SNPS-AVT_2.1/VERILOG_LD/CORE90GPSVT.v
	vlogan -full64 /cell_libs/cmos090_50a/CORE90GPHVT_SNPS-AVT_2.1.a/VERILOG_LD/CORE90GPHVT.v
	vlogan -full64 shiftreg-gated-syn.v 
	vhdlan -full64 ${top_level_file}
	vcs -full64 -debug_access+all -sdf typ:E/UUT:shiftreg-syn.sdf E +neg_tchk +sdfverbose 
#	./simv -ucli -include saif.cmd

synth-power:
	num=100 ; while [[ $$num -le 40000 ]] ; do \
		python generate_saif.py $$num ; \
		./simv -ucli -include saif_tmp.cmd ; \
		dc_shell -x "set top_level shiftreg-gated ; set sim_length $$num " -f ./scripts/post_syn_power.tcl ; \
		((num = num + 200)) ; \
	done
	


clean:
	rm -rf AN.DB 64 simv* csrc work.lib++

# library 90nm
vlogan -full64 /cell_libs/cmos090_50a/CORE90GPSVT_SNPS-AVT_2.1/VERILOG_LD/CORE90GPSVT.v
vlogan -full64 /cell_libs/cmos090_50a/CORE90GPHVT_SNPS-AVT_2.1.a/VERILOG_LD/CORE90GPHVT.v
vlogan -full64 fpmul1-place.v
vhdlan -full64 tb2_fpmul1.vhd  
vcs -full64 -debug -sdf typ:E/UUT:fpmul1-place.sdf E +neg_tchk +sdfverbose
./simv -ucli -include saif_post.cmd

sh date

read_file -format ddc ${top_level}-syn.ddc
read_saif -input report/${top_level}-${sim_length}-full_timing.saif -instance E/UUT -unit ns
report_power -hier > report/${top_level}-${sim_length}-power_report.rpt

sh date
exit
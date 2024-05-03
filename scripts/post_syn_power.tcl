sh date

read_file -format ddc ./db/${top_level}-compile.ddc
read_saif -input Report/${top_level}-place.saif -instance E/UUT -unit ns
report_power -hier > Report/${top_level}-place-power_report.rpt

sh date
exit
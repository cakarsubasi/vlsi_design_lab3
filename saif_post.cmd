power -gate_level on
power UUT
power -enable
run 100000
power -disable
power -report  fp32mul_pipe-place.saif 1e-09 UUT
quit



database -open IDCT.vcd -vcd
probe -all -depth all -database IDCT.vcd :arch
run
database -close IDCT.vcd


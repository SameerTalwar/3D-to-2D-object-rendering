transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Data/EE705\ VLSI\ Design\ Lab/project/EE705/EE705/Verilog\ Implementation {C:/Data/EE705 VLSI Design Lab/project/EE705/EE705/Verilog Implementation/VGA.v}
vlog -vlog01compat -work work +incdir+C:/Data/EE705\ VLSI\ Design\ Lab/project/EE705/EE705/Verilog\ Implementation {C:/Data/EE705 VLSI Design Lab/project/EE705/EE705/Verilog Implementation/sine.v}
vlog -vlog01compat -work work +incdir+C:/Data/EE705\ VLSI\ Design\ Lab/project/EE705/EE705/Verilog\ Implementation {C:/Data/EE705 VLSI Design Lab/project/EE705/EE705/Verilog Implementation/cosine.v}
vlog -vlog01compat -work work +incdir+C:/Data/EE705\ VLSI\ Design\ Lab/project/EE705/EE705/Verilog\ Implementation {C:/Data/EE705 VLSI Design Lab/project/EE705/EE705/Verilog Implementation/main.v}

vlog -vlog01compat -work work +incdir+C:/Data/EE705\ VLSI\ Design\ Lab/project/EE705/EE705/Verilog\ Implementation {C:/Data/EE705 VLSI Design Lab/project/EE705/EE705/Verilog Implementation/test_main.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test_main

add wave *
view structure
view signals
run -all

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Data/QuartusPrimeWorkingDirectory/render3D {C:/Data/QuartusPrimeWorkingDirectory/render3D/sine.v}
vlog -vlog01compat -work work +incdir+C:/Data/QuartusPrimeWorkingDirectory/render3D {C:/Data/QuartusPrimeWorkingDirectory/render3D/cosine.v}
vlog -vlog01compat -work work +incdir+C:/Data/QuartusPrimeWorkingDirectory/render3D {C:/Data/QuartusPrimeWorkingDirectory/render3D/main.v}

vlog -vlog01compat -work work +incdir+C:/Data/QuartusPrimeWorkingDirectory/render3D {C:/Data/QuartusPrimeWorkingDirectory/render3D/test_main.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  test_main

add wave *
view structure
view signals
run -all

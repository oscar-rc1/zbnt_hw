
cd [file dirname [info script]]

# Get number of jobs to use

if { [info exists ::env(NUM_JOBS) ] } {
	set jobs $::env(NUM_JOBS)
} else {
	set jobs [exec nproc]
}

# Create project

if { ![file exists vivado/zbnt_hw_dual_tgen_detector.xpr ] } {
	source create_project.tcl
} else {
	open_project vivado/zbnt_hw_dual_tgen_detector.xpr
}

# Launch synthesis run

if { [get_property needs_refresh [get_runs synth_1]] || [get_property status [get_runs synth_1]] == "Not started" } {
	reset_runs synth_1
	launch_runs synth_1 -jobs $jobs
	wait_on_run synth_1
}

# Write dcp

open_run synth_1 -name synth_1

set dtb_data [split [exec ../../../scripts/gen_dtb_rom.py rp_devtree.dts RP] "\n "]
set dtb_bram [get_cells -of_objects [all_fanin -flat [get_nets U0/dtb_rom/mem/douta[0]]] -filter {REF_NAME == RAMB36E1}]

foreach {key val} $dtb_data {
	set_property $key $val $dtb_bram
}

file mkdir ../hw
file mkdir ../hw/dcp
write_checkpoint -force ../hw/dcp/rp_dual_tgen_detector.dcp

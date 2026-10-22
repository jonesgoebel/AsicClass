#### Template Script for RTL->Gate-Level Flow

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

##############################################################################
## Preset global variables and attributes
##############################################################################
set DESIGN idct8_multi

set GEN_EFF high
set MAP_OPT_EFF high

set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs_${DATE}
set _REPORTS_PATH reports_${DATE}
set _LOG_PATH logs_${DATE}
##set ET_WORKDIR <ET work directory>
 
set_db lib_search_path  {. \
	 ../Library/Nangate_45nm\
 }

set_db script_search_path {. \
   ../Scripts/ \
}

set_db hdl_search_path {../rtl} 

##Uncomment and specify machine names to enable super-threading.
##set_attribute super_thread_servers {<machine names>} /
##For design size of 1.5M - 5M gates, use 8 to 16 CPUs. For designs > 5M gates, use 16 to 32 CPUs
##set_attribute max_cpus_per_server 8 /

set_db max_cpus_per_server 8
set_db super_thread_servers "localhost"

##Default undriven/unconnected setting is 'none'.  
##set_attribute hdl_unconnected_input_port_value 0 | 1 | x | none /
##set_attribute hdl_undriven_output_port_value   0 | 1 | x | none /
##set_attribute hdl_undriven_signal_value        0 | 1 | x | none /


##set_attribute wireload_mode <value> /
set_db information_level 7 
##set_attribute retime_reg_naming_suffix __retimed_reg /
#set_db auto_partition true

#set_db information_level 9 
set_db wireload_mode top 
set_db lib_lef_consistency_check_enable true
set_db error_on_lib_lef_pin_inconsistency true 

set_db auto_super_thread true 
set_db hdl_track_filename_row_col true 
set_db use_multibit_cells false 
set_db lp_power_unit mW

###############################################################
## Set of Optimizations
###############################################################
#set_db lp_insert_clock_gating true 

set_db auto_ungroup none 
#set_db auto_ungroup_min_effort high 

#set_db control_logic_optimization advanced
#set_db dp_area_mode true 
#set_db iopt_lp_power_analysis_effort high
#set_db iopt_ultra_optimization true

#set_db ultra_global_mapping true

#set_db leakage_power_effort high 
#set_db lp_power_analysis_effort medium 

###############################################################
## Library setup
###############################################################
#25c 0.9V - typical 
set_db library {NangateOpenCellLibrary_typical_ecsm.lib}

#Wire Delay Estimation  
set_db lef_library {NangateOpenCellLibrary.lef}

####################################################################
## Load Design
####################################################################
read_hdl -vhdl dct4.vhd
read_hdl -vhdl dct8.vhd
read_hdl -vhdl op_module_idct8.vhd
read_hdl -vhdl idct8_multi.vhd

#read_hdl -vhdl {dct4.vhd dct8.vhd op_module_idct8.vhd idct8_multi.vhd}

elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"
time_info Elaboration

check_design -unresolved

####################################################################
## Constraints Setup
####################################################################
read_sdc ../scripts/constraints.sdc
puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"

report timing -lint
check_timing_intent

####################################################################################################
## Synthesizing to generic 
####################################################################################################
set_db syn_generic_effort $GEN_EFF 

syn_generic 

puts "Runtime & Memory after 'syn_generic'"
time_info GENERIC

####################################################################################################
## Synthesizing to gates
####################################################################################################
## Add '-auto_identify_shift_registers' to 'syn_map' to automatically 
## identify functional shift register segments. Not applicable for n2n flow.
set_db syn_map_effort $MAP_OPT_EFF 
syn_map 
puts "Runtime & Memory after 'syn_map'"
time_info MAPPED

#######################################################################################################
## Optimize Netlist
#######################################################################################################
syn_opt
#-physical
#write_snapshot -outdir $_REPORTS_PATH -tag syn_opt_incr
#report_summary -outdir $_REPORTS_PATH

puts "Runtime & Memory after 'syn_opt'"
time_info OPT

#foreach cg [find / -cost_group *] {
#  report timing -cost_group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_opt.rpt
#}

#######################################################################################################
## Optimize Netlist
#######################################################################################################
## Uncomment to remove assigns & insert tiehilo cells during Incremental synthesis
##set_attribute remove_assigns true /
##set_remove_assign_options -buffer_or_inverter <libcell> -design <design|subdesign>
##set_attribute use_tiehilo_for_const <none|duplicate|unique> /

## An effort of low was selected to minimize runtime of incremental opto.
## If your timing is not met, rerun incremental opto with a different effort level
set_db syn_opt_effort medium 
syn_opt -incremental
#write_snapshot -outdir $_REPORTS_PATH -tag syn_opt_low_incr 
#report_summary -outdir $_REPORTS_PATH
#puts "Runtime & Memory after 'syn_opt'"
#time_info INCREMENTAL_POST_SCAN_CHAINS

#################################
### final_reports
#################################
puts "Final Runtime & Memory."
time_info FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"

report_clocks
report_gates -power
report_timing
report area -depth 1
report area -depth 1 -normalize_with_gate NAND2_X1
#report_power -unit mW -format %.3f -levels 1 -by_hierarchy -cols {cells pct_cells leakage internal switching total level hier} -by_hierarchy -sort_by total -header
report_power -unit mW -format %.3f -levels 1 -by_hierarchy -cols {cells pct_cells leakage internal switching total level hier} -by_hierarchy -sort_by total

report qor

quit

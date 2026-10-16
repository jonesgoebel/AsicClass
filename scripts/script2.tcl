#### Template Script for RTL->Gate-Level Flow (generated from RC v07.20-s021_1) 

## rc -files ../scripts/setupe.tcl


if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"
########################################################
## Include TCL utility scripts..
########################################################

include load_etc.tcl

##############################################################################
## Preset global variables and attributes
##############################################################################
# Top module name.
set DESIGN  idct8_multi
# change switch activity; low use 50%, medium: propagate from other nodes to nodes not declared, high: propagate with more accuracy. default: low{low | medium | high}
set POW_EFF high
set SYN_EFF medium
set MAP_EFF medium
set DATE [clock format [clock seconds] -format "%b%d-%T"]
#set _OUTPUTS_PATH outputs_${DATE}
set _REPORTS_PATH reports
#set _LOG_PATH logs
#set _RESULTS_PATH results
shell rm -rf logs/ outputs_* rc.* reports/ results/
#shell mkdir outputs_${DATE}
shell mkdir reports
#shell mkdir logs
#shell mkdir results
set_attribute lib_search_path {. /cadence/Library/NangateOpenCellLib_45/Front_End/Liberty/CCS/ /cadence/Library/NangateOpenCellLib_45/Back_End/lef/} /


set_attribute hdl_search_path { ../rtl } /
set_attribute wireload_mode top /
set_attribute information_level 9 /
set_attribute lp_power_unit mW /

set_attribute auto_super_thread true /
set_attribute hdl_track_filename_row_col true /


###############################################################
## Library setup
###############################################################

set_attribute library {NangateOpenCellLibrary_typical_ccs.lib} /

set_attribute lef_library { NangateOpenCellLibrary.tech.lef NangateOpenCellLibrary.lef}  /  
set_attribute interconnect_mode ple /

###############################################################
## Clock gating 
###############################################################
#set_attr lp_insert_clock_gating true /
#set_attribute lp_insert_operand_isolation true /
set_attr lp_multi_vt_optimization_effort high /


####################################################################
## Load RTL Design verilog or vhdl, (create a single top file to call all others)
####################################################################
puts "Reading HDLs..."
#read_hdl -v2001 teste.v 
#read_hdl -vhdl booth_vector.vhd
#read_hdl -v2001 arquivos.v
#read_hdl -vhdl -library work me_de_package.vhd

read_hdl -vhdl {dct4.vhd dct8.vhd op_module_idct8.vhd idct8_multi.vhd}



puts "Elaborate Design..."
elaborate $DESIGN 
puts "Runtime & Memory after 'read_hdl'"
timestat Elaboration 

check_design -unresolved 

####################################################################
## Constraints Setup
####################################################################
read_sdc ../scripts/constraints.sdc

report timing -lint


###################################################################################################
## Architecture setup ( Multiply, CSA)
###################################################################################################
# turn off Carry Save Adders:  set_attr dp_csa {none|basic} 
set_attr dp_csa none /

################################################################################
## Power Directives- only make difference if swicthing activity file is provided
################################################################################

#set_attribute lp_optimize_dynamic_power_first true design $DESIGN 
#set_attribute lp_clock_gating_cell [find /lib* -libcell <cg_libcell_name>] "/designs/$DESIGN"
set_attribute max_leakage_power 0.0 "/designs/$DESIGN"

#this command sets the max power at 2mW. The tool will optimize a bit but it wont necessarilly reach that goal
#set_attribute max_dynamic_power 0 design $DESIGN 
# change switch activity; low use 50%, medium: propagate from other nodes to nodes not declared, high: propagate with more accuracy. default: medium
#set_attribute lp_power_analysis_effort {low | medium | high}
set_attribute lp_power_analysis_effort $POW_EFF
#set_attribute lp_power_optimization_weight <value from 0 to 1> "/designs/$DESIGN"
#set_attribute lp_power_optimization_weight 0.99 design $DESIGN

# Builds  detailed power models for more accurate RTL power analysis.


#set_attribute lp_default_probability 0.5 $DESIGN 
#set_attribute lp_default_toggle_rate 0.02 $DESIGN 
#set_attribute lp_asserted_toggle_rate 0.01  [find [find / -design $DESIGN] -port IN*]  
#set_attribute lp_asserted_toggle_rate 0.0  [find [find / -design $DESIGN] -port TAM*]  
#set_attribute lp_asserted_toggle_rate 0.00156 [find [find / -design $DESIGN] -port TAM*] 


#############################################################################
## Swicthing Activity (before synthesis to mapped)
#############################################################################
## read_tcf <TCF file name>
## read_saif <SAIF file name>
## read_vcd <VCD file name>

#set_attribute find_takes_multiple_names  true
#read_vcd -static -vcd_module arch -module $DESIGN  ../work/IDCT1.vcd

#read_tcf  ../work/IDCT.tcf

build_rtl_power_models -clean_up_netlist -design $DESIGN
#build_rtl_power_models -design $DESIGN

# Report (making sure tool knows power values)
report power > $_REPORTS_PATH/RC_power_bef_gen.txt
#report power -depth 2 > $_REPORTS_PATH/RC_power_short_bef_gen.txt

####################################################################################################
## Synthesizing to generic 
####################################################################################################
synthesize -to_generic -eff $SYN_EFF
puts "Runtime & Memory after 'synthesize -to_generic'"
timestat GENERIC
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_generic.rpt



####################################################################################################
## Synthesizing to gates
####################################################################################################
synthesize -to_mapped -eff $MAP_EFF -no_incr
puts "Runtime & Memory after 'synthesize -to_map -no_incr'"
timestat MAPPED
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_map.rpt
#clock_gating share -hier ; # if clock gating disabled this is unnecessary


##Post global map netlist for LEC verification..
#write_hdl -lec > ${_OUTPUTS_PATH}/${DESIGN}_global_mapped.v
#write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_global_mapped.v -logfile ${_LOG_PATH}/rtl2globalmap.lec.log > ${_OUTPUTS_PATH}/rtl2globalmap.lec.do

#######################################################################################################
## Incremental Synthesis
#######################################################################################################
synthesize -to_mapped -eff $MAP_EFF -incr   
puts "Runtime & Memory after incremental synthesis"
timestat INCREMENTAL

check_design -all


#############################################################################
## Swicthing Activity (after synthesis to mapped)
#############################################################################



#############################################################################
## Reports & Results
#############################################################################
#write -m  > ${_OUTPUTS_PATH}/${DESIGN}_m.hvsyn
#write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_m.sdc
#write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script

# Timing reports for all modules
#report timing -worst 1 -through  C_structure/*[*] > $_REPORTS_PATH/RC_timing_C.txt
#report timing -worst 1 -through  D_structure/*[*] > $_REPORTS_PATH/RC_timing_D.txt
#report timing -worst 1 -through  E_structure/*[*] > $_REPORTS_PATH/RC_timing_E.txt

# Report worst timing
report timing > $_REPORTS_PATH/RC_timing.log
report area > $_REPORTS_PATH/RC_area.log
report power > $_REPORTS_PATH/RC_power.log

#report area -depth 3 > $_REPORTS_PATH/RC_area_short.txt
#report power -depth 3 > $_REPORTS_PATH/RC_power_short.txt
#report clock_gating > $_REPORTS_PATH/clock_gating.txt
#write_encounter design -basename $_RESULTS_PATH/mar_tool $DESIGN

#adding timescale information do generated gates for use in simulation
#shell "sed -i '1i `timescale 1ns/10ps' $_RESULTS_PATH/udp_ip_struct.v" This line doesn't work on RC
#shell echo "`timescale 1ns/10ps" > temp
#shell cat $_RESULTS_PATH/mar_tool.v >> temp
#shell mv temp $_RESULTS_PATH/mar_tool.v

report area -depth 3
report power -depth 2
report qor

write_saif  -computed $DESIGN > output.saif 

puts "Final Runtime & Memory."
timestat FINAL
puts "============================"
puts "Synthesis Finished ........."
puts "============================"


#quit

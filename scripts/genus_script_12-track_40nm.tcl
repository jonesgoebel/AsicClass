#### Template Script for RTL->Gate-Level Flow (generated from GENUS 17.22-s017_1) 

if {[file exists /proc/cpuinfo]} {
  sh grep "model name" /proc/cpuinfo
  sh grep "cpu MHz"    /proc/cpuinfo
}

puts "Hostname : [info hostname]"

##############################################################################
## Preset global variables and attributes
##############################################################################

#set DESIGN Transposition_Buffer64

set GEN_EFF high
set MAP_OPT_EFF high

set DATE [clock format [clock seconds] -format "%b%d-%T"] 
set _OUTPUTS_PATH outputs_${DATE}
set _REPORTS_PATH reports_${DATE}
set _LOG_PATH logs_${DATE}
##set ET_WORKDIR <ET work directory>

 
set_db lib_search_path  {. \
	 /cadence/Library/TSMC/40/G/G_12/plvt/lib/tcbn45gsbwp12tlvt_200a_nldm/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn45gsbwp12tlvt_200a \
	 /cadence/Library/TSMC/40/G/G_12/plvt/lef/tcbn45gsbwp12tlvt_120c_sef/TSMCHOME/digital/Back_End/lef/tcbn45gsbwp12tlvt_120c/lef/VHV_0d5_0 \
	 /cadence/Library/TSMC/40/G/G_12/plvt/lef/tcbn45gsbwp12tlvt_120c_sef/TSMCHOME/digital/Back_End/lef/tcbn45gsbwp12tlvt_120c/techfiles/captable \
	 /cadence/Library/TSMC/40/G/G_12/IO1.8V/lef \
 }

set_db script_search_path {. \
   ../../../../Scripts/synthesis/custom_scripts/ \
}
set_db hdl_search_path {../../../../../HDL} 

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
set_db lp_insert_clock_gating true 

set_db auto_ungroup none 
set_db auto_ungroup_min_effort high 

#set_db control_logic_optimization advanced
#set_db dp_area_mode true 
#set_db iopt_lp_power_analysis_effort high
#set_db iopt_ultra_optimization true

#set_db ultra_global_mapping true

#set_db leakage_power_effort high 
#set_db lp_power_analysis_effort medium 

###############################################################
## Library setup #nand2 0.9408um2
###############################################################
#25c 0.9V - TC (recomended)
set_db library {tcbn45gsbwp12tlvttc.lib}

#Wire Delay Estimation
# from cadence path   
set_db lef_library {tcbn45gsbwp12tlvt_9lm6X2ZRDL.lef}

#dc::set_dont_use NAND2_X2 true
set_db cap_table_file {cln40g_1p09m+alrdl_6x2z_typical.captab}

#read_qrc {qrcTechFile}

## Power root attributes


## Power root attributes
#set_attribute lp_clock_gating_prefix <string> /
#set_attribute lp_power_analysis_effort <high> /
#set_attribute lp_power_unit mW /
#set_attribute lp_toggle_rate_unit /ns /
## The attribute has been set to default value "medium"
## you can try setting it to high to explore MVT QoR for low power optimization

####################################################################
## Load Design
####################################################################
#read_hdl -v2001 TranspositionBuffer/Transposition_Buffer64.v
read_hdl -v2001 $HDL_FILES


elaborate $DESIGN
puts "Runtime & Memory after 'read_hdl'"
time_info Elaboration



check_design -unresolved

####################################################################
## Constraints Setup
####################################################################

read_sdc ../../../../synthesis/scripts/$SDC_FILE
puts "The number of exceptions is [llength [vfind "design:$DESIGN" -exception *]]"


#set_attribute force_wireload <wireload name> "/designs/$DESIGN"

#if {![file exists ${_LOG_PATH}]} {
#  file mkdir ${_LOG_PATH}
#  puts "Creating directory ${_LOG_PATH}"
#}
#
#if {![file exists ${_OUTPUTS_PATH}]} {
#  file mkdir ${_OUTPUTS_PATH}
#  puts "Creating directory ${_OUTPUTS_PATH}"
#}
#
#if {![file exists ${_REPORTS_PATH}]} {
#  file mkdir ${_REPORTS_PATH}
#  puts "Creating directory ${_REPORTS_PATH}"
#}

report timing -lint
check_timing_intent
################################################################################################
## read in def file.
################################################################################################

 if {!$ONLY_ELABORATE} {
  #read_def <file_name>
  #
  #
  #
  #if {![file exists ${_LOG_PATH}]} {
  #  file mkdir ${_LOG_PATH}
  #  puts "Creating directory ${_LOG_PATH}"
  #}
  #
  #if {![file exists ${_OUTPUTS_PATH}]} {
  #  file mkdir ${_OUTPUTS_PATH}
  #  puts "Creating directory ${_OUTPUTS_PATH}"
  #}
  #
  #if {![file exists ${_REPORTS_PATH}]} {
  #  file mkdir ${_REPORTS_PATH}
  #  puts "Creating directory ${_REPORTS_PATH}"
  #}
  #report timing -lint

  ###################################################################################
  ## Define cost groups (clock-clock, clock-output, input-clock, input-output)
  ###################################################################################

  ## Uncomment to remove already existing costgroups before creating new ones.
  ## rm [find /designs/* -cost_group *]

  #if {[llength [all::all_seqs]] > 0} { 
  #  define_cost_group -name I2C -design $DESIGN
  #  define_cost_group -name C2O -design $DESIGN
  #  define_cost_group -name C2C -design $DESIGN
  #  path_group -from [all::all_seqs] -to [all::all_seqs] -group C2C -name C2C
  #  path_group -from [all::all_seqs] -to [all::all_outs] -group C2O -name C2O
  #  path_group -from [all::all_inps]  -to [all::all_seqs] -group I2C -name I2C
  #}
  #
  #define_cost_group -name I2O -design $DESIGN
  #path_group -from [all::all_inps]  -to [all::all_outs] -group I2O -name I2O
  #foreach cg [find / -cost_group *] {
  #  report timing -cost_group [list $cg] >> $_REPORTS_PATH/${DESIGN}_pretim.rpt
  #}
  ##################################################################################################
  ## DFT Setup
  ##################################################################################################

  #set_attribute dft_scan_style muxed_scan /

  ## Uncomment for clocked_LSSD 
  #set_attribute dft_scan_style clocked_lssd_scan /
  #define_dft scan_clock_a -name <scanClockAObject> -period <delay in pico sec, default 50000> -rise <integer> -fall <integer> <portOrpin> 
  #define_dft scan_clock_b -name <scanClockAObject> -period <delay in pico sec, default 50000> -rise <integer> -fall <integer> <portOrpin> 

  #set_attribute dft_prefix DFT_ /
  ## For VDIO customers, it is recommended to set the value of the next two attributes to false.
  #set_attribute dft_identify_top_level_test_clocks true /
  #set_attribute dft_identify_test_signals true /
  #
  #set_attribute dft_identify_internal_test_clocks false /
  #set_attribute use_scan_seqs_for_non_dft false /
  #
  #set_attribute dft_scan_map_mode tdrc_pass "/designs/$DESIGN"
  #set_attribute dft_connect_shift_enable_during_mapping tie_off "/designs/$DESIGN"
  #set_attribute dft_connect_scan_data_pins_during_mapping loopback "/designs/$DESIGN"
  #set_attribute dft_scan_output_preference auto "/designs/$DESIGN"
  #set_attribute dft_lockup_element_type preferred_level_sensitive "/designs/$DESIGN"
  ##set_attribute dft_mix_clock_edges_in_scan_chains true "/designs/$DESIGN"
  #
  ##set_attribute dft_dont_scan true <instance or subdesign> 
  ##set_attribute dft_controllable "<from pin> <inverting|non_inverting>" <to pin>
  #
  #define_dft test_clock -name <testClockObject> -domain <testClockDomain> -period <delay in pico sec, default 50000>  -rise <integer> -fall <integer> <portOrpin>
  #define_dft shift_enable -name <shiftEnableObject> -active <high|low> <portOrpin> [-create_port]
  #define_dft test_mode -name <testModeObject> -active <high|low> <portOrpin> [-create_port] [-shared_in]

  ## If you intend to insert compression logic, define your compression test signals or clocks here:
  ## define_dft test_mode...  [-shared_in]
  ## define_dft test_clock...
  #########################################################################
  ## Segments Constraints (support fixed, floating, preserved and abstract)
  ## only showing preserved, and abstract segments as these are most often used
  #############################################################################

  ##define_dft preserved_segment -name <segObject> -sdi <pin|port|subport> -sdo <pin|port|subport> -analyze 
  ## If the block is complete from a DFT perspective, uncomment to prevent any non-scan flops from being scan-replaced
  #set_attribute dft_dont_scan true [filter dft_mapped false [find /designs/* -instance <subDesignInstance>/instances_seq/*]]

  ##define_dft abstract_segment -name <segObject> <-module|-instance|-libcell> -sdi <pin> -sdo <pin> -clock_port <pin> [-rise|-fall] -shift_enable_port <pin> -active <high|low> -length <integer> 
  ## Uncomment if abstract segments are modeled in CTL format
  ##read_dft_abstract_model -ctl <file>


  #define_dft scan_chain -name <ChainName> -sdi <topLeveLSDIPort>	-sdo <topLevelSDOPort> [-hookup_pin_sdi <coreSideSDIDrivingPin>] [-hookup_pin_sdo <coreSideSDOLoadPin>] [-shift_enable <ShiftEnableObject>] [-shared_output | -non_shared_output] [-terminal_lockup <level | edge>]

  ## Run the DFT rule checks
  #check_dft_rules > $_REPORTS_PATH/${DESIGN}-tdrcs
  #report dft_registers > $_REPORTS_PATH/${DESIGN}-DFTregs
  #report dft_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_tdrc

  ## Fix the DFT Violations
  ## Uncomment to fix dft violations
  ## set numDFTviolations [check_dft_rules]
  ## if {$numDFTviolations > "0"} {
  ##   report dft_violations > $_REPORTS_PATH/${DESIGN}-DFTviols  
  ##   fix_dft_violations -async_set -async_reset [-clock] -test_control <TestModeObject>
  ##   check_dft_rules
  ## }

  ##  Run the Advanced DFT rule checks to identify:
  ## ...  x-source generators, internal tristate nets, and clock and data race violations
  ## Note:  tristate nets are reported for busses in which the enables are driven by
  ## tristate devices.  Use 'check_design' to report other types of multidriven nets.

  #check_design -multidriven
  #check_dft_rules -advanced  > $_REPORTS_PATH/${DESIGN}-Advancedtdrcs
  #report dft_violations [-tristate] [-xsource] [-xsource_by_instance] > $_REPORTS_PATH/${DESIGN}-AdvancedDFTViols

  ## Fix the Avanced DFT Violations
  ## ... x-source violations are fixed by inserting registered shadow logic
  ## ... tristate net violations are fixed by selectively enabling and disabiling the tristate enable signals
  ##  in shift-mode. 
  ## ... clock and data race violations are not auto-fixed by the tool.
  ## Note: The fixing of tristate net violations using the 'fix_dft_violations -tristate_net' command
  ## should be deferred until a full-chip representation of the design is available.

  ## Uncomment to fix x-source violations (or alternatively, insert the shadow logic using the
  ## 'insert_dft shadow_logic' command).
  #fix_dft_violations -xsource -test_control <TestModeObject> -test_clock_pin <ClockPinOrPort> [-exclude_xsource <instance>]
  #check_dft_rules -advanced

  ## Update DFT status
  ## report dft_registers > $_REPORTS_PATH/${DESIGN}-DFTregs_tdrc
  ## report dft_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_tdrc

  #####################################################################################
  #### Retime
  #####################################################################################
  set_db dp_rewriting advanced
  #retime -prepare -min_delay -effort high $DESIGN
  #set rt_subds {mysub1  mysub2 mysub3}
  #foreach subd $rt_subds {
  #  set_attribute retime true $subd
    ####Uncomment to prevent registers from being moved across the subdesign boundaries
    ##set_attribute retime_hard_region true $subd 
  #}
  ####Setting 'retime' attribute on the top-level as shown below 
  ####is not recommended due to possible verification/ECO issues unless for very small designs
  #set_attribute retime true   "/designs/$DESIGN"

  ####set dont_retime on registers which should not be retimed
  #set dont_rt_flops "myflop1 myflop2 myflop3 .."
  #foreach rtf $rt_flops {
  #  set_attribute dont_retime true $rtf
  #}
  # Enable verification flow 
  #set_db retime_verification_flow true 
  #set_db "designs:$DESIGN" .retime true

  #######################################################################################
  ## Leakage/Dynamic power/Clock Gating setup.
  #######################################################################################

  #split_clock_gate
  #declone_clock_gate -hierarchical

  #suspend 
  #set_db leakage_power_effort high 
  #set_db lp_power_analysis_effort medium 
  #set_db "designs:$DESIGN" .max_leakage_power 100
  #set_db "designs:$DESIGN" .max_dynamic_power 200
  #set_db "design:$DESIGN" .lp_power_optimization_weight 0.96



  #set_attribute lp_clock_gating_cell [find /lib* -libcell <cg_libcell_name>] "/designs/$DESIGN"
  #set_attribute max_leakage_power 0.0 "/designs/$DESIGN"
  #set_attribute max_dynamic_power <number> "/designs/$DESIGN"

  #set_attribute lp_clock_gating_test_signal <test_signal_object> "/designs/$DESIGN"
  ## read_tcf <TCF file name>
  ## read_saif <SAIF file name>
  ## read_vcd <VCD file name>


  #set_db port:$DESIGN/SEL[0] .lp_asserted_probability 0
  #set_db port:$DESIGN/SEL[1] .lp_asserted_probability 0
  #set_db port:$DESIGN/SEL[2] .lp_asserted_probability 0
  #set_db port:$DESIGN/SEL[0] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/SEL[1] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/SEL[2] .lp_asserted_toggle_rate 0


  #read_stimulus
  #Genus for power analysis
  #computer_power
  #power_map

  #set_db port:$DESIGN/RESET .lp_asserted_probability 0.001
  #set_db port:$DESIGN/ACK_OUT .lp_asserted_probability 1.0
  #set_db port:$DESIGN/ACK_OUT .lp_asserted_toggle_rate 0.0
  
  #set_db port:$DESIGN/ENABLE_IN .lp_asserted_probability 1.0
  #set_db port:$DESIGN/ENABLE_IN .lp_asserted_toggle_rate 0.0
  
  #set_db port:$DESIGN/BLOCK_SIZE[1] .lp_asserted_probability 0
  #set_db port:$DESIGN/BLOCK_SIZE[2] .lp_asserted_probability 0
  #set_db port:$DESIGN/BLOCK_SIZE[3] .lp_asserted_probability 0
  #set_db port:$DESIGN/BLOCK_SIZE[4] .lp_asserted_probability 0
  #set_db port:$DESIGN/BLOCK_SIZE[5] .lp_asserted_probability 0
  #set_db port:$DESIGN/BLOCK_SIZE[6] .lp_asserted_probability 0

  #set_db port:$DESIGN/BLOCK_SIZE[0] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/BLOCK_SIZE[1] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/BLOCK_SIZE[2] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/BLOCK_SIZE[3] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/BLOCK_SIZE[4] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/BLOCK_SIZE[5] .lp_asserted_toggle_rate 0
  #set_db port:$DESIGN/BLOCK_SIZE[6] .lp_asserted_toggle_rate 1


  #### To turn off sequential merging on the design 
  #### uncomment & use the following attributes.
  ##set_attribute optimize_merge_flops false /
  ##set_attribute optimize_merge_latches false /
  #### For a particular instance use attribute 'optimize_merge_seqs' to turn off sequential merging. 


  ####################################################################################################
  ## Synthesizing to generic 
  ####################################################################################################

  set_db syn_generic_effort $GEN_EFF 
  #syn_generic
  syn_generic 
  puts "Runtime & Memory after 'syn_generic'"
  time_info GENERIC
  #write_snapshot -outdir $_REPORTS_PATH -tag generic
  #report datapath > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt
  #report_summary -outdir $_REPORTS_PATH


  #### Build RTL power models
  ##build_rtl_power_models -design $DESIGN -clean_up_netlist [-clock_gating_logic] [-relative <hierarchical instance>]
  #report power -rtl


  ######################################################################################################
  ## Optional DFT commands (section 1)
  ######################################################################################################

  #############
  ## Identify Functional Shift Registers
  #############
  #identify_shift_register_scan_segments

  #############
  ## Add testability logic as required
  #############
  #insert_dft shadow_logic -around <instance> -mode <no_share|share|bypass> -test_control <TestModeObject>
  #insert_dft test_point -location <port|pin> -test_control <test_signal> -type <string>

  #######################
  ## Add Boundary Scan and Programmable MBIST logic
  ########################

  ## Uncomment to define the existing 3rd party TAP controller to be used as the master controller for
  ## DFT logic such as boundary-scan, compression, Programmable MBIST and ptam.
  #define_dft jtag_macro -name <objectName> ....

  ## Define JTAG Instructions for the existing Macro or when building the JTAG_Macro with user-defined instructions. 
  ## ... For current release, name the mandatory JTAG instructions as: EXTEST, SAMPLE, PRELOAD, BYPASS

  ##define_dft jtag_instruction_register -name <string> -length <integer> -capture <string>
  ##define_dft jtag_instruction -name <string> -opcode <string> ;# [-register <string> -length <integer>] [-private]

  ## Uncomment to build a JTAG_Macro with Programmable MBIST instructions.
  ## Names of the mandatory instructions are: MBISTTPN, MBISTSCH, MBISTCHK
  #define_dft jtag_instruction -name <string> -opcode <string> -register <string> -length <integer>

  ## Uncomment to define the MBIST clock if inserting Programmable MBIST logic
  #define_dft mbist_clock -name <objectNameOfMBISTClock> ...

  ## Uncomment to read memory view files for programmable MBIST
  #read_memory_view -cdns_memory_view_file <string> -arm_mbif <string> -directory <string> <design>

  #insert_dft boundary_scan -tck <tckpin> -tdi <tdipin> -tms <tmspin> -trst <trstpin> -tdo <tdopin> -exclude_ports <list of ports excluded from boundary register> -preview

  ## Uncomment to read block-level interface files for programmable MBIST
  #read_pmbist_interface_files -directory <locationOfInterfaceFiles> <lib_cell|module|design>

  ## Uncomment to insert Programmable BIST (PMBIST) for memories
  #insert_dft pmbist -config_file <filename> -connect_to_jtag -directory <PMBISTworkDir> -dft_cfg_mode <dft_configuration_mode> -amu_location <design|module|inst|hinst> ..

  ## Uncomment to write interface files for programmable MBIST
  #write_pmbist_interface_files -directory <locationOfInterfaceFiles> [<design>]

  ## Uncomment to write out data and script files to generate PMBIST patterns
  #write_pmbist_testbench [-create_embedded_test_options <string>] [-irun_options <string>] [-directory <string>] [-testbench_directory <string>] [-ncsim_library <string>] [-script_only] [-no_deposit_script] [-no_build_model] [<design>]

  ##Write out BSDL file
  #write_bsdl -bsdlout <BSDLfileName> -directory <work directory>


  ####################################################################################################
  ## Synthesizing to gates
  ####################################################################################################

  ## Add '-auto_identify_shift_registers' to 'syn_map' to automatically 
  ## identify functional shift register segments. Not applicable for n2n flow.
  set_db syn_map_effort $MAP_OPT_EFF 
  syn_map 
  puts "Runtime & Memory after 'syn_map'"
  time_info MAPPED
  #write_snapshot -outdir $_REPORTS_PATH -tag map
  #report_summary -outdir $_REPORTS_PATH
  #report datapath > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt


  #foreach cg [find / -cost_group *] {
  #  report timing -cost_group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_map.rpt

  #}


  #write_do_lec -revised_design fv_map -logfile ${_LOG_PATH}/rtl2intermediate.lec.log > ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

  ## ungroup -threshold <value>

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

  ######################################################################################################
  ## Optional additional DFT commands. (section 2)
  ######################################################################################################

  ## Re-run DFT rule checks
  ## check_dft_rules [-advanced]
  ## Build the full scan chanins
  ## connect_scan_chains [-preview] [-auto_create_chains]
  ## report dft_chains > $_REPORTS_PATH/${DESIGN}-DFTchains

  ## Inserting Compression logic
  ## compress_scan_chains -ratio <integer>  -mask <string> [-auto_create] [-preview]
  ##report dft_chains > $_REPORTS_PATH/${DESIGN}-DFTchains_compression
  ## Reapply CPF rules
  #commit_cpf

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


  #############################################
  ## DFT Reports
  #############################################

  #report dft_setup > $_REPORTS_PATH/${DESIGN}-DFTsetup_final
  #write_scandef > ${DESIGN}-scanDEF
  #write_dft_abstract_model > ${DESIGN}-scanAbstract
  #write_hdl -abstract > ${DESIGN}-logicAbstract
  #write_script -analyze_all_scan_chains > ${DESIGN}-writeScript-analyzeAllScanChains
  ## check_atpg_rules -library <Verilog simulation library files> -compression -directory <Encounter Test workdir directory>
  ## write_et_bsv -library <Verilog structural library files> -directory $ET_WORKDIR 
  #write_et_atpg -library <Verilog structural library files> -compression -directory $ET_WORKDIR 


  ######################################################################################################
  ## write backend file set (verilog, SDC, config, etc.)
  ######################################################################################################



  #report clock_gating > $_REPORTS_PATH/${DESIGN}_clockgating.rpt
  #report power -depth 0 > $_REPORTS_PATH/${DESIGN}_power.rpt
  #report gates -power > $_REPORTS_PATH/${DESIGN}_gates_power.rpt

  #report datapath > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
  #report messages > $_REPORTS_PATH/${DESIGN}_messages.rpt
  #write_snapshot -outdir $_REPORTS_PATH -tag final
  #report_summary -outdir $_REPORTS_PATH
  ## write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_m.v
  ## write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script
  #write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_m.sdc

  #write_design -innovus ${DESIGN} -basename innovus/${DESIGN}

  #################################
  ### write_do_lec
  #################################




  report_clock_gating > $_REPORTS_PATH/${DESIGN}_clockgating.rpt
  report_power -depth 0 > $_REPORTS_PATH/${DESIGN}_power.rpt
  report_gates -power > $_REPORTS_PATH/${DESIGN}_gates_power.rpt

  report_dp > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
  report_messages > $_REPORTS_PATH/${DESIGN}_messages.rpt
  write_snapshot -outdir $_REPORTS_PATH -tag final
  report_summary -directory $_REPORTS_PATH
  write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}_m.v
  ## write_script > ${_OUTPUTS_PATH}/${DESIGN}_m.script
  write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_m.sdc


  #write_do_lec -golden_design fv_map -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile  ${_LOG_PATH}/intermediate2final.lec.log > ${_OUTPUTS_PATH}/intermediate2final.lec.do
  ##Uncomment if the RTL is to be compared with the final netlist..
  ##write_do_lec -revised_design ${_OUTPUTS_PATH}/${DESIGN}_m.v -logfile ${_LOG_PATH}/rtl2final.lec.log > ${_OUTPUTS_PATH}/rtl2final.lec.do

  puts "Final Runtime & Memory."
  time_info FINAL
  puts "============================"
  puts "Synthesis Finished ........."
  puts "============================"


  report_clocks
  report_gates -power
  report_timing
  report area -depth 1 -normalize_with_gate ND2XD0BWP12TLVT
  report area -depth 1
  #report_power -unit mW -format %.3f -levels 1 -by_hierarchy -cols {cells pct_cells leakage internal switching total level hier} -by_hierarchy -sort_by total -header
  report_power -unit mW -format %.3f -levels 1 -by_hierarchy -cols {cells pct_cells leakage internal switching total level hier} -by_hierarchy -sort_by total

  #write_saif  -computed $DESIGN > output_default.saif

  report qor

 # Diretório de saída
  set REPORT_DIR "../report_stimulus"

  # Cria o diretório se não existir
  if {![file exists $REPORT_DIR]} {
      file mkdir $REPORT_DIR
  }
  
  foreach sequency $VIDEO {
    puts $sequency
    read_tcf ../../../verification/stimulus/$arch/${sequency}.tcf
    report_power -unit mW -format %.3f -levels 1 -cols {leakage internal switching total level hier} -by_hierarchy -sort_by total > $REPORT_DIR/${sequency}_power.rpt
    #write_saif  -computed $DESIGN > output_${sequency}.saif
  }
 }

##########################
quit

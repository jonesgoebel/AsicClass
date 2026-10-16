
########################################################
## Include TCL utility scripts..
########################################################

include load_etc.tcl

##############################################################################
## Preset global variables and attributes
##############################################################################

set DESIGN  idct8_multi


set_attribute lib_search_path {. /home/aluno/cadence/Library/NangateOpenCellLib_45/Front_End/Liberty/CCS/  /home/aluno/cadence/Library/NangateOpenCellLib_45/Back_End/lef/} /
set_attribute hdl_search_path { ../rtl } /
set_attribute lp_power_unit mW /



###############################################################
## Library setup
###############################################################
set_attribute library {NangateOpenCellLibrary_typical_ccs.lib}
set_attribute lef_library { NangateOpenCellLibrary.tech.lef NangateOpenCellLibrary.lef}    


####################################################################
## Load RTL Design verilog or vhdl, (create a single top file to call all others)
####################################################################

read_hdl -vhdl {dct4.vhd dct8.vhd op_module_idct8.vhd idct8_multi.vhd}
 
elaborate $DESIGN 

check_design -unresolved 

####################################################################
## Constraints Setup
####################################################################
read_sdc ../scripts/constraints.sdc

report timing -lint


################################################################################
## Power Directives
################################################################################

set_attribute lp_power_analysis_effort medium


build_rtl_power_models -clean_up_netlist -design $DESIGN


####################################################################################################
## Synthesizing 
####################################################################################################
synthesize -to_generic -eff medium

synthesize -to_mapped -eff medium -no_incr

synthesize -to_mapped -eff medium -incr   

check_design -all


#############################################################################
## Reports & Results
#############################################################################

report area -depth 3
report power -depth 2
report qor


#quit

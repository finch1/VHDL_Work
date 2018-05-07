# -----------------------------------------------------------------
# sim.tcl
#
# 2/20/2012 D. W. Hawkins (dwh@ovro.caltech.edu)
#
# JTAG-to-Avalon-MM tutorial Qsys System Modelsim simulation
# script.
#
# -----------------------------------------------------------------
# Usage
# -----
#
# From within Modelsim, change to the project folder, and type
#
#    source scripts/synth.tcl
#
# -----------------------------------------------------------------
# Notes:
# ------
#
# Tested with both Modelsim Altera Starter Edition and Modelsim-SE.
#
# -----------------------------------------------------------------

echo ""
echo "JTAG-to-Avalon-MM tutorial 'qsys_system' simulation script"
echo "----------------------------------------------------------"
echo ""

# -----------------------------------------------------------------
# Tutorial HDL folder
# -----------------------------------------------------------------
#
# Determine the altera_jtag_to_avalon_mm_tutorial/hdl directory
#
# * current location should be altera_jtag_to_avalon_mm_tutorial/
#   hdl/qsys_system, so strip off the last directory from the
#   current directory
#
set path [file split [pwd]]
set len  [llength $path]
set hdl  [eval file join [lrange $path 0 [expr {$len-2}]]]

# Check the directory name
if {![string match [file tail $hdl] "hdl"]} {
	puts [concat \
		"Error: this script should be sourced from the "\
		"qsys_system/ project directory. Please "\
		"change to that directory and try again."]
	return
}

# -----------------------------------------------------------------
# Create the Modelsim work directory
# -----------------------------------------------------------------
#
# The msim_setup.tcl script copies files into the current
# directory, so create a modelsim work folder (mwork).
# The msim_setup.tcl script creates a 'libraries' subfolder,
# and compiles the source into libraries within that folder.
# There is no need to setup a 'work' folder in this script
# (it gets created in libraries/work).
#
set mwork $hdl/qsys_system/mwork
if {![file exists $mwork]} {
	echo " * Creating the Modelsim work folder; $mwork"
	file mkdir $mwork
}
cd $mwork

# -----------------------------------------------------------------
# Qsys System
# -----------------------------------------------------------------
#
# Quartus must be used to create the 'generated' Qsys system.
# However, the generated files are pretty much independent of
# of the FPGA type. Unfortunately, Quartus needs an FPGA type
# to create a project, from which Qsys can be run.
# Use the qsys_system files from the BeMicro-SDK project.
#
# Edit the board variable if you want to test code generated
# for the BeMicro or DE2, or just use the BeMicro-SDK project
# for simulation, since Quartus generates the same 
# simulation source.
#
set board $hdl/boards/bemicro_sdk
set qwork $board/qsys_system/qwork
if {![file exists $qwork]} {
	echo [concat \
		"\nError:\nThis simulation script needs to compile source " \
		"code generated by Quartus for the BeMicro-SDK project. "\
		"Please use Quartus to run the synthesis script for that "\
		"project. This script can be run after Qsys has been "\
		"used to 'generate' the Qsys system (full synthesis "\
		"of the Quartus project is not required)."]
	return
}

# -----------------------------------------------------------------
# Qsys system files
# -----------------------------------------------------------------
#
# The Qsys generator creates an msim_setup.tcl script that is
# used by this script to setup the simulation.
#
# Check the script exists, and then source it
set msim_setup $qwork/qsys_system/simulation/mentor/msim_setup.tcl
if {![file exists $msim_setup]} {
	echo [concat \
		"\nError:\nThis simulation script $msim_setup was not found." \
		"Please check the Qsys 'Generation' tab setting for "\
		"'Create Simulation Model' is set to 'Verilog'."]
	return
}

# Setup the path to the simulation folder
set QSYS_SIMDIR $board/qsys_system/qwork/qsys_system/simulation

# Source the setup script
source $msim_setup

# Build the Qsys components
dev_com
com

# -----------------------------------------------------------------
# Testbenches
# -----------------------------------------------------------------
#
# The msim_setup.tcl script com procedure compiles the verbosity
# package into the library qsys_system_bfm_master. The qsys_system
# component is compiled into the work library.
#
# The following compiles the testbench into the work library too.
# The -L option is required so that the verbosity package is
# located by vlog.
#
vlog -sv $hdl/qsys_system/test/qsys_system_bfm_master_tb.sv -L qsys_system_bfm_master
vlog -sv $hdl/qsys_system/test/qsys_system_jtag_master_tb.sv -L qsys_system_bfm_master

# Change back to the original top-level folder
#  * so that using up-arrow to repeat 'source scripts/sim.tcl' works
#  * wait until after compiling the testbench since msim_setup.tcl
#    sets up the Modelsim library mappings to use relative paths,
#    eg., use vmap to see the library mappings relative to
#    the ./libraries subfolder (created in the mwork/ folder).
#  * Actually, do not change directories, since the testbench
#    procedures will not work, since the library mappings
#    cannot be resolved. Yet another issue with the Altera script.
#    It should setup mappings with absolute paths.
#
#cd $hdl/qsys_system

# -----------------------------------------------------------------
# Testbench procedures
# -----------------------------------------------------------------
#
echo ""
echo "JTAG-to-Avalon-MM tutorial testbench procedures"
echo "-----------------------------------------------"
echo ""
echo "  qsys_system_bfm_master_tb  - run the Avalon-MM BFM testbench"
echo "  qsys_system_jtag_master_tb - run the JTAG-to-Avalon-MM testbench"

proc qsys_system_bfm_master_tb {} {
	global hdl QSYS_SIMDIR

	# Set the setup script top-level variable
	set TOP_LEVEL_NAME qsys_system_bfm_master_tb

	# Use elab to call vsim with all the library paths
	elab +nowarnTFMPC
	do $hdl/qsys_system/scripts/qsys_system_bfm_master_tb.do
	run -a
}

proc qsys_system_jtag_master_tb {} {
	global hdl QSYS_SIMDIR

	# Set the setup script top-level variable
	set TOP_LEVEL_NAME qsys_system_jtag_master_tb

	# Use elab to call vsim with all the library paths
	elab +nowarnTFMPC
	do $hdl/qsys_system/scripts/qsys_system_jtag_master_tb.do
	run -a
}

#
# This file provides default settings for a HAL extended BSP.
#

# check if the BSP is a HAL based BSP for which the defaults make sense, else exit
if { [is_bsp_hal_extension] } {
 log_verbose "This Tcl script will apply default settings for an Altera HAL extended BSP"
} else {
 log_verbose "The default Altera HAL settings Tcl script will be skipped because this BSP is not Altera HAL extended."
 return 0
}

# Set default values for command-line options.
set default_stdio "CHOOSE_DEFAULT"
set default_sys_timer "CHOOSE_DEFAULT"
set default_memory_regions "CHOOSE_DEFAULT"
set default_sections_mapping "CHOOSE_DEFAULT"
set use_bootloader "CHOOSE_DEFAULT"
set section_mappings ""
set default_exception "CHOOSE_DEFAULT"

# Parse optional command line arguments
# All command line arguments are treated as name/value pairs.
foreach {name value} $argv {
    if { $name == "add_section_mapping" } {
        # Accumulate any add_section_mapping commands.
        # The section mapping value has the following format:
        #   <section_name>=<region_name>
        lappend section_mappings $value
    } else {
        # Make sure a variable with the specified name exists.
        if { [info exists $name] } {
            # Set the variable to the specified value.
            set $name $value
        } else {
            error "Bad argument name: $name"
        }
    }
}

# Get the path to this script.
# This uses the $argv0 pre-set variable which contains the
# complete path to this script.
set mydir [file dirname $argv0]

# Read in required utility scripts.
source $mydir/bsp-stdio-utils.tcl
source $mydir/bsp-timer-utils.tcl
source $mydir/bsp-linker-utils.tcl
source $mydir/bsp-bootloader-utils.tcl
source $mydir/bsp-exception-utils.tcl

# Call procedures defined in utility scripts to set the defaults.
set_stdio_defaults $default_stdio
set_timer_defaults $default_sys_timer
set_default_memory_regions $default_memory_regions
set_default_sections_mapping $default_sections_mapping
set_specified_section_mappings $section_mappings
set_bootloader_defaults $use_bootloader
set_exception_defaults $default_exception

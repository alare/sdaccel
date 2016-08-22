# SDAccel command script
# Design = smithwaterman example

# Define a solution name
create_solution -name baseline_solution -dir . -force

# Define the target platform of the application
add_device -vbnv xilinx:adm-pcie-7v3:1ddr-ppc64le:2.1

# Host source files
add_files "main.cpp"
add_files "oclErrorCodes.cpp"
add_files "oclHelper.cpp"
add_files "soft.cpp"

# Header files
add_files "oclHelper.h"
set_property file_type "c header files" [get_files "oclHelper.h"]

# Kernel definition
create_kernel smithwaterman -type clc
add_files -kernel [get_kernels smithwaterman] "kernel.cl"

# Define binary containers
create_opencl_binary test
set_property region "OCL_REGION_0" [get_opencl_binary test]
create_compute_unit -opencl_binary [get_opencl_binary test] -kernel [get_kernels smithwaterman] -name K1

# Compile the design for CPU based emulation
compile_emulation -flow cpu -opencl_binary [get_opencl_binary test]

# Generate the system estimate report
report_estimate

file copy baseline_genbin baseline.xclbin
file copy baseline_genexe baseline.exe

# Run the design in CPU emulation mode
run_emulation -flow cpu -args "-d acc -k test.xclbin"

# XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
file delete -force baseline_solution
    
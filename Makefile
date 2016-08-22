XILINX_OPENCL := $(XILINX_SDACCEL)
DSA := xilinx:adm-pcie-7v3:1ddr:2.1
XOCC := $(XILINX_SDACCEL)/bin/xocc
CPP := g++

OPENCL_INC := $(XILINX_OPENCL)/runtime/include/1_2
OPENCL_LIB := $(XILINX_OPENCL)/runtime/lib/x86_64

CXXFLAGS := -Wall -Werror 
CLFLAGS := -g --xdevice $(DSA)

.PHONY: all
all: exe xclbin

.PHONY: xclbin
xclbin: kernel.xclbin

.PHONY: exe
exe: smithwaterman

smithwaterman: main.cpp oclErrorCodes.cpp oclHelper.cpp soft.cpp oclHelper.h
	$(CXX) $(CXXFLAGS) -I$(OPENCL_INC) -L$(OPENCL_LIB) -lOpenCL -o $@ main.cpp oclErrorCodes.cpp oclHelper.cpp soft.cpp

kernel.xclbin: kernel.cl
	$(XOCC) $(CLFLAGS) $< -o $@

clean:
	rm -rf kernel.xclbin smithwaterman xocc* sdaccel*

# Open-Source AXI4 Cores #

This repository is for storing open-source Verilog modules that use the AXI4, 
AXI4-Lite, and AXI4-Stream interfaces. 

When a core is optimized around a specific architecture, there shall be an 
additional parameter, ARCH, which will contain the name of the architecture 
used. A list of architecture names shall be maintained in top-level 
documentation.

## Simulation & Test Synthesis ##

Simulation of any module can be run in Vivado using `./simulate.sh unit_tb`, 
where unit_tb is replaced with the testbench name.

Synthesis can be tested by running Vivado with the `-mode tcl` argument and 
executing the following commands:

```
add_files ./src
synth_design -mode out_of_context -part xc7a35ticsg324-1l -top unit_wrapper
report_utilization
```

The `unit_wrapper` should be replaced with the appropriate wrapper. 
Parameterized wrappers that break out all interfaces are recommended, so that 
all parameters can be set for synthesis.

## ARCH Parameter Values ##

| ARCH         | Architecture            |
| ---          | ---                     |
| GENERIC      | Any device              |
| XIL_SPARTAN6 | Xilinx Spartan 6 series |
| XIL_VIRTEX6  | Xilinx Virtex 6 series  |
| XIL_7SERIES  | Xilinx 7 series parts   |

## Important Note on Resets ##

Although the ARESETn signal of an AXI bus can, according to the spec, be 
asserted asychronously, the cores in this repository assume it is always 
synchronous.

## AXI4-Lite Notes ##

Although AXI4-Lite technically permits both 64-bit and 32-bit bus widths, 

## Licensing ##

This set of modules is released under the Apache License, Version 2.0.

Modules that replicate proprietary IP Cores are designed only around public 
descriptions of them (i.e. guides & datasheets). This is to avoid violating any
licensing agreement for the IP Core, which often forbids reverse engineering the 
source code.

The AXI4 interface standard set is licensed such that it can be freely used 
without paying for a licensing agreement with ARM. There is an exception for if 
the developed product (this library) is used with a CPU that is advertised as 
being compatible with an ARM instruction set. In this particular case, the CPU 
must be licensed from ARM. See ARM Document IHI0022E for the Licensing Agreement 
in full.

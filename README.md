# Open-Source AXI4 Cores #

This repository is for storing open-source Verilog modules that use the AXI4, 
AXI4-Lite, and AXI4-Stream interfaces. They are explicitly geared towards 
reproducing the functionality offered by proprietary IP Cores - starting with IP 
offered by Xilinx.

- If emulating a proprietary IP Core, it shall be strive to be port-compatible 
	with the IP it emulates. Signal name changes are acceptable, as is the 
	bundling of bus interfaces (like AXI).
- When a core is optimized around a specific architecture, there shall be an 
  additional parameter, ARCH, which will contain the name of the architecture 
	used. A list of architecture names shall be maintained in top-level 
	documentation.

## ARCH Parameter Values ##

| ARCH         | Architecture            |
| ---          | ---                     |
| GENERIC      | Any device              |
| XIL_SPARTAN6 | Xilinx Spartan 6 series |
| XIL_VIRTEX6  | Xilinx Virtex 6 series  |
| XIL_7SERIES  | Xilinx 7 series parts   |

## Important Note on Resets ##

Although the ARESETn signal of an AXI bus can, according to the spec, be 
asserted asychronously, many IP Cores assume it is always synchronous.  The 
cores present in this repository will do the same.

## Licensing ##

This set of modules is released under the Apache License, Version 2.0.

Modules that replicate proprietary IP Cores are designed only around public 
descriptions of them (i.e. guides & datasheets). This is to avoid violating any
licensing agreement for the IP Core, which often forbids reverse engineering the 
source code.

The AXI4 interface standard is licensed such that it can be freely used without 
paying for a licensing agreement with ARM. There is an exception for if the 
developed product (this library) is used with a CPU that is advertised as being 
compatible with an ARM instruction set. In this particular case, the CPU must be 
licensed from ARM. See ARM Document IHI0022E for the Licensing Agreement in full.

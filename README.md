# Open-Source AXI4 Cores #

This folder is for storing open-source Verilog modules that use the AXI4, 
AXI4-Lite, and AXI4-Stream interfaces. They are explicitly geared towards 
reproducing the functionality offered by proprietary IP Cores - starting with IP 
offered by Xilinx.

- If emulating a proprietary IP Core, it shall be port-compatible with the IP it 
	emulates. Signal name changes are acceptable, as is the bundling of bus 
	interfaces (like AXI).
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

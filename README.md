# Xilinx IP Core Clones #

This folder is for storing open-source, Verilog modules that exactly replicate 
the functionality of a Xilinx IP Core.

- Each module shall be port-compatible with the Xilinx IP it emulates
- The module shall accept parameters that reproduce the configuration options in 
  Xilinx Coregen / IP Integrator.
- ISE-compatible IP Cores shall be written in Verilog-2001
- Vivado-only IP Cores may be written in SystemVerilog instead of Verilog
- When Xilinx-specific primitives / design trade-offs are present, there shall 
  be an additional parameter, ARCH, which will contain the name of the Xilinx 
	architecture used. A list of architecture names shall be maintained in 
	top-level documentation.


## ARCH Parameter Values ##

| ARCH     | Architecture       |
| --       | --                 |
| SPARTAN6 | Spartan 6 series   |
| VIRTEX6  | Virtex 6 series    |
| 7SERIES  | All 7 series parts |

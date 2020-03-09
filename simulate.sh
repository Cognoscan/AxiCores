#!/bin/sh

# Setup and run a simulation in Vivado
xelab -incr -debug typical ${1} -s top_sim
xsim top_sim -gui #-t xsim_run.tcl

# Setup and run a simulation in Modelsim
#vsim -gui work.axi_gpio_tb

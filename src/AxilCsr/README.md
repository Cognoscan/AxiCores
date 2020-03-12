AxilCsr
=======

This module provides a set of control & status registers on an AXI4-Lite bus, 
with an optional interrupt handling unit. The write strobes to the control 
registers are also registered and available. Control registers are read/write; 
status registers are read-only.

This module is primarily meant for building other modules without having to 
think about the bus interface.

Register Map
------------

Registers are ordered as follows: the control registers are in the lowest 
addresses, followed by the status registers, then the optional IRQ_EN register, 
and finally the optional IRQ_STAT register.

For example, with 3 control registers, 2 status registers, and interrupts 
enabled, the address space will be:

| Address | Register |
| --      | --       |
| 0x00    | CTRL0    |
| 0x04    | CTRL1    |
| 0x08    | CTRL2    |
| 0x0C    | STAT0    |
| 0x10    | STAT1    |
| 0x14    | IRQ_EN   |
| 0x18    | IRQ_STAT |

Behavior outside of this address space range is undefined, and should not be 
relied upon. To meet the AXI4-Lite specification, it will always return 
a response, but the contents of that response are undefined.

### Interrupt Registers

The first interrupt register, IRQ_EN, is the interrupt enable register. Setting 
a bit enables the corresponding interrupt, if it exists. They start off 
disabled.

The second interrupt register, IRQ_STAT, is the interrupt status register. 
A high bit indicates that interrupt has been asserted since it was last cleared, 
or that it was being asserted while being cleared. Writing a 1 to a bit in this 
register clears the interrupt, or sets it if it is already clear.

If any of the bits in IRQ_STAT are set, the output line `irq` is also set.

Interrupt Handling
------------------

After enabling interrupts, the expected interrupt handler is:

1. Wait for `irq` to be set.
2. Read the contents of IRQ_STAT
3. Write the value of IRQ_STAT back to the register to acknowledge all interrupts.
4. Handle the set interrupts as appropriate.
5. Return

Provided the interrupt handler takes several clock cycles, the write-back in 
step 3 should have sufficient time to clear IRQ_STAT and clear the `irq` line.

It is recommended that the interrupt handler know which interrupts are enabled 
and ignore flagged interrupts that are disabled. When an interrupt is disabled, 
the corresponding bit in IRQ_STAT is not immediately cleared. This is 
intentional, as some devices may require handling an interrupt one final time 
after it has been disabled. Devices not requiring this behavior can safely 
ignore the condition and clear the bit.

Writing a 1 to a interrupt bit that is not set will set it. This is meant for 
debugging purposes only; specifically, to forcibly trigger interrupt handling 
code during testing.

Utilization
-----------

Utilization in Xilinx 7-Series LUTs can be approximated by summing the below 
list. the number of registers `NUM_REG` is equal to `CTRL + STAT + 
(HAS_INTERRUPTS ? 2 : 0)`.

- 4 * CTRL
- 32 * (size of read multiplexer)
	- Somewhere around log2(NUM_REG)-1
- 8 if HAS_INTERRUPTS
- 1 * INTERRUPTS
- 8 (interface logic)

For example, for CTRL=4, STAT=4, and no interrupts, 88 LUTs are used:

```
4 * CTRL = 4 * 4 = 16
32 * (size of read multiplexer) = 32 * (log2(4+4)-1) = 64
8 if HAS_INTERRUPTS = 0
1 * INTERRUPTS = 0
8 (interface logic) = 8

16 + 64 + 8 = 88 LUTs
```

This is a lower bound; as the register space grows, additional LUTs will be 
required for wider multiplexers and larger address decoders.






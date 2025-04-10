NOTE: DESIGN NOT ADDED DUE TO COPYRIGHT 

APB Testbench in SystemVerilog
Overview
This repository contains a SystemVerilog Testbench designed to verify an APB (Advanced Peripheral Bus) compliant slave device.
The testbench stimulates the DUT with APB read/write transactions and checks for correct responses according to the AMBA APB protocol.

Testbench Architecture
APB Interface:
Defines all APB signals such as PCLK, PRESETn, PADDR, PWDATA, PWRITE, PENABLE, PSEL, and PRDATA.

Transaction : Container for the signal ports.

Generator, Driver:
Generates APB read and write transactions by driving the interface signals according to the APB protocol timing.

Monitor:
Observes APB transactions on the bus and collects them for checking or coverage purposes.

Scoreboard:
Compares expected results against actual DUT outputs to ensure correctness.

Testcases:

Random write and read tests(with and without wait states)

Back-to-back transactions (with and without wait state)

Slave error transaction (with and without wait state)

Reset behavior test

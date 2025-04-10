`include "environment.sv"

`ifndef APB_ERR_WAIT_TEST_SV
`define APB_ERR_WAIT_TEST_SV

class err_wait_test;

    environment e;
  
  task set_read_write;
    e.g.tr.paddr.rand_mode(0);
    e.g.tr.c_addr_rng.constraint_mode(0);
    e.g.tr.paddr = 32'hffff_ffff;
  endtask

  task run(virtual apb_interface vif);
    e = new(vif,10);
	fork
      set_read_write;
      e.run();
    join_none
    endtask

endclass

`endif 
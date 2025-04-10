`include "environment.sv"

`ifndef APB_RST_TEST_SV
`define APB_RST_TEST_SV

class rst_test;

    environment e;
  
  task set_read_write;
//     e.g.tr.paddr.rand_mode(0);
//     e.g.tr.c_addr_rng.constraint_mode(0);
//     e.g.tr.paddr = 32'hffff_ffff;
    e.g.tr.preset.rand_mode(0);
    e.g.tr.c_preset.constraint_mode(0);
    repeat(10) begin
      e.g.tr.preset = 1'b0;
      @(e.sco_done);
    end
  endtask

  task run(virtual apb_interface vif);
    e = new(vif,11);
	fork
      set_read_write;
      e.run();
    join_none
    endtask

endclass

`endif 
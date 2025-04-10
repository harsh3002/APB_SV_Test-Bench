`include "environment.sv"

`ifndef APB_RND_WAIT_TEST_SV
`define APB_RND_WAIT_TEST_SV

class rnd_wait_test;

    environment e;
  
//   task set_read_write;
//     e.g.tr.pwrite.rand_mode(0);
//     repeat(5) begin
//     e.g.tr.pwrite = 1;
//       @(e.sco_done);
//     end
//     repeat(5) begin
//     e.g.tr.pwrite = 0;
//       @(e.sco_done);
//     end
//   endtask

  task run(virtual apb_interface vif);
    e = new(vif,20);
// 	fork
//       set_read_write;
      e.run();
//     join_none
    endtask

endclass

`endif 
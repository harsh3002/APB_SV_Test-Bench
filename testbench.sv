`include "rnd_rd_wrt_wait_test.sv"
`include "base_test.sv"
`include "wrt_wait_test.sv"
`include "rd_wt_test.sv"
`include "err_wt_test.sv"
`include "rnd_zero_wt.sv"
`include "wrt_zero_wait.sv"
`include "rd_zero_wait.sv"
`include "err_zero_wait.sv"
`include "reset_test.sv"

// `ifndef APB_TB_TOP
// `define APB_TB_TOP

module tb;
  
  apb_interface apb_if();
  base_test test_b;
  rnd_wait_test rw_test;
  wrt_wait_test w_wt_test;
  rd_wait_test r_wt_test;
  err_wait_test err_wt_test;
  
  rnd_zero_wait_test rnd_zero_t;
  wrt_zero_wait_test wrt_zero_t;
  rd_zero_wait_test  rd_zero_t;
  err_zero_wait_test err_zero_t;
  
  rst_test rst_t;
  
  apb_slave dut(apb_if);
//   always @(negedge apb_if.pclk) if(apb_if.pwrite)$display("%p",dut.mem);

  
  initial apb_if.pclk = 0;
  always #5  apb_if.pclk = ~apb_if.pclk;
  
  environment e;
  
  initial begin
//     test_b = new;
//     test_b.run(apb_if);
    
    rw_test = new;
    rw_test.run(apb_if);
    
//     rst_t = new;
//     rst_t.run(apb_if);
    
//     w_wt_test = new;
//     w_wt_test.run(apb_if);
    
//     r_wt_test = new;
//     r_wt_test.run(apb_if);
    
//     err_wt_test = new;
//     err_wt_test.run(apb_if);
    
//     rnd_zero_t = new;
//     rnd_zero_t.run(apb_if);
    
//     wrt_zero_t = new;
//     wrt_zero_t.run(apb_if);
    
//     rd_zero_t = new;
//     rd_zero_t.run(apb_if);
    
//     err_zero_t = new;
//     err_zero_t.run(apb_if);
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars;
  end
endmodule

// `endif
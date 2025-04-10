`include "interface.sv"
`include "transaction.sv"

`ifndef DRV_APB_SV
`define DRV_APB_SV

import transaction_pkg::*;

class driver;
  
  transaction tr;
  virtual apb_interface vif;
  mailbox #(transaction) mbx;
  event sco_done;
  
  function new(mailbox #(transaction) mbx, virtual apb_interface vif, event sco_done);
    this.mbx = mbx;
    this.vif = vif;
    this.sco_done = sco_done;
  endfunction
  
  task pre_reset;
    $display("[DRV] : APPLYING INITIAL RESET TO THE SYSTEM");
    @(vif.drv_cb);
    vif.drv_cb.preset <= 1'b0;
    vif.drv_cb.psel <= 1'b0;
    vif.drv_cb.penable <= 1'b0;
    vif.drv_cb.pwrite <= 1'b0;
    vif.drv_cb.paddr <= 'h0;
    vif.drv_cb.pwdata <= 'h0;
    repeat(2) @(vif.drv_cb);
    vif.drv_cb.preset <= 1'b1;
    @(vif.drv_cb);
    $display("[DRV] : INITIAL RESET SUCCESSFULLY APPLIED");
    $display("------------------------------------------------");
  endtask
  
  task read_wt;
    $display($time,"[DRV] : READ OPERATION");
    vif.drv_cb.psel <= 1'b1;
    vif.drv_cb.penable <= 1'b0;
    vif.drv_cb.pwrite <= tr.pwrite;
    vif.drv_cb.paddr <= tr.paddr;
    vif.drv_cb.pwdata <= 'h0;
    @(vif.drv_cb);
    vif.drv_cb.penable <= 1'b1;
    $display($time,"[DRV] : APPLIED DATA TO STIMULUS");
    @(posedge vif.pready);
    @(negedge vif.pclk);
    vif.drv_cb.psel <= 1'b0;
    vif.drv_cb.penable <= 1'b0;
    repeat (2)@(vif.drv_cb);
  endtask
  
  task read_zero_wt;
    $display($time,"[DRV] : READ OPERATION");
    vif.drv_cb.psel <= 1'b1;
    vif.drv_cb.penable <= 1'b0;
    vif.drv_cb.pwrite <= tr.pwrite;
    vif.drv_cb.paddr <= tr.paddr;
    vif.drv_cb.pwdata <= 'h0;
    @(vif.drv_cb);
    vif.drv_cb.penable <= 1'b1;
    $display($time,"[DRV] : APPLIED DATA TO STIMULUS");
    @(vif.drv_cb);
    vif.drv_cb.psel <= 1'b0;
    vif.drv_cb.penable <= 1'b0;
    @(sco_done);
	@(vif.drv_cb);
  endtask
  
  task write_wt;
    $display($time,"[DRV] : WRITE OPERATION");
    vif.drv_cb.preset <= 1'b1;
    vif.drv_cb.psel <= 1'b1;
    vif.drv_cb.penable <= 1'b0;
    vif.drv_cb.pwrite <= tr.pwrite;
    vif.drv_cb.paddr <= tr.paddr;
    vif.drv_cb.pwdata <= tr.pwdata;
    @(vif.drv_cb);
    vif.drv_cb.penable <= 1'b1;
    $display($time,"[DRV] : APPLIED DATA TO STIMULUS");
    @(posedge vif.pready);
    @(negedge vif.pclk);
    vif.drv_cb.psel <= 1'b0;
    vif.drv_cb.penable <= 1'b0;
    repeat(2)@(vif.drv_cb);
  endtask
  
  task write_zero_wt;
    $display($time,"[DRV] : WRITE OPERATION");
    vif.drv_cb.psel <= 1'b1;
    vif.drv_cb.penable <= 1'b0;
    vif.drv_cb.pwrite <= tr.pwrite;
    vif.drv_cb.paddr <= tr.paddr;
    vif.drv_cb.pwdata <= tr.pwdata;
    @(vif.drv_cb);
    vif.drv_cb.penable <= 1'b1;
    $display($time,"[DRV] : APPLIED DATA TO STIMULUS");
    @(vif.drv_cb);
    vif.drv_cb.psel <= 1'b0;
    vif.drv_cb.penable <= 1'b0;
    @(sco_done);
    @(vif.drv_cb);
  endtask
  
  task reset;
//     repeat (5) @(vif.drv_cb);
    $display($time,"[DRV] : APPLYING RESET TO THE SYSTEM");
    vif.drv_cb.preset <= 1'b0;
    vif.drv_cb.psel <= 1'b0;
    vif.drv_cb.penable <= 1'b0;
    vif.drv_cb.pwrite <= 1'b0;
    vif.drv_cb.paddr <= 'h0;
    vif.drv_cb.pwdata <= 'h0;
    @(vif.drv_cb);
    vif.drv_cb.preset <= 1'b1;
    $display($time,"[DRV] : RESET APPLIED");
    @(sco_done);
    repeat(2) @(vif.drv_cb);
  endtask
  
  task display();
    $display($time,"[DRV] : RECEIVED STIMULUS VALUES");
    $display($time,"[DRV] : PRESET: %0d  PSEL: %0d  PENABLE: %0d  PWRITE: %0d  PADDR: %0h  PWDATA: %0h",tr.preset, tr.psel, tr.penable, tr.pwrite, tr.paddr, tr.pwdata);
  endtask
  
  task run;
    forever begin
      mbx.get(tr);
      display();
      
      if(tr.preset) begin
        if(tr.pwrite) begin
          if($test$plusargs("zerowaitstate"))
          	write_zero_wt();
          else
            write_wt();
        end
        else begin
          if($test$plusargs("zerowaitstate"))
          	read_zero_wt();
          else 
            read_wt();
        end
      end
      else 
        reset();
    end
  endtask
  
endclass


`endif
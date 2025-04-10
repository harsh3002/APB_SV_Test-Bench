`include "transaction.sv"

`ifndef GEN_APB_SV
`define GEN_APB_SV

import transaction_pkg::*;

class generator;
  
  transaction tr;
  mailbox #(transaction) mbx;
  event gen_done, sco_done;
  int count;
  
  function new(mailbox #(transaction) mbx,event sco_done, int count);
    tr = new;
    this.mbx = mbx;
    this.sco_done = sco_done;
    this.count = count;
  endfunction
  
  task display();
    $display("%0t[GEN] : GENERATED VALUES",$time);
    $display("%0t[GEN] : PRESET: %0d  PSEL: %0d  PENABLE: %0d  PWRITE: %0d  PADDR: %0h  PWDATA: %0h",$time,tr.preset, tr.psel, tr.penable, tr.pwrite, tr.paddr, tr.pwdata);
  endtask
  
  task run;
    
    repeat(count) begin
      assert(tr.randomize);
      display();
      mbx.put(tr.copy);
      $display("[GEN] : DATA SENT TO DRIVER");
      @(sco_done);
    end
    ->gen_done;
  endtask
  
endclass

`endif
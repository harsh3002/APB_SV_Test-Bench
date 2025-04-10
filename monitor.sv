`include "transaction.sv"
`include "interface.sv"

`ifndef MON_APB_SV
`define MON_APB_SV

import transaction_pkg::*;

class monitor;
  
  transaction tr;
  virtual apb_interface vif;
  mailbox #(transaction) mbx;
  event sco_done;
  
  function new(mailbox #(transaction) mbx, virtual apb_interface vif, event sco_done);
    tr = new;
    this.mbx = mbx;
    this.vif = vif;
    this.sco_done = sco_done;
    apb_cover = new;
  endfunction
  
  task read_op;
    tr.preset = vif.mon_cb.preset;
    tr.pwrite = vif.pwrite;
    tr.paddr = vif.paddr;
    tr.prdata = vif.prdata;
    tr.pslverr = vif.pslverr;
    $display($time,"[MON] : SAMPLED RDATA FROM DUT");
    $display("[MON] : PSEL: %0d  PENABLE: %0d  PWRITE: %0d  PADDR: %0h  PRDATA: %0h", tr.psel, tr.penable, tr.pwrite, tr.paddr, tr.prdata);
    mbx.put(tr);
  endtask
  
  task write_op;
    tr.preset = vif.mon_cb.preset;
    tr.pwrite = vif.pwrite;
    tr.paddr = vif.paddr;
    tr.pwdata = vif.pwdata;
    tr.pslverr = vif.pslverr;
    $display($time,"[MON] : SAMPLED WDATA FROM DUT");
    $display("[MON] : PSEL: %0d  PENABLE: %0d  PWRITE: %0d  PADDR: %0h  PWDATA: %0h", tr.psel, tr.penable, tr.pwrite, tr.paddr, tr.pwdata);
    mbx.put(tr);
  endtask
  
  task reset_sample;
    tr.preset = vif.mon_cb.preset;
    tr.pready = vif.mon_cb.pready;
    tr.pslverr = vif.mon_cb.pslverr;
    $display($time,"[MON] : SYSTEM RESET ENCOUNTERED");
    $display("[MON] : PRESET: %0d  PREADY: %0d  PSLVERR: %0d", tr.preset, tr.pready, tr.pslverr);
    mbx.put(tr);
  endtask
  
  covergroup apb_cover;			// Defining the cover group
    
    option.per_instance = 1;
    
    cp1 : coverpoint vif.paddr {
      bins b1 = {[0:127]};
      bins b2 = {32'hffff_ffff};
      illegal_bins ibin = default;
    		}
    
    cp2 : coverpoint vif.pwdata {
      bins b3 = {[0:255]};
    		}
    
    cp3 : coverpoint vif.prdata {
      bins b4 = {[0:255]};
    		}
    
    cp4: coverpoint vif.psel {ignore_bins b5 = {0};  bins b6 = {1};}
    
    cp5: coverpoint vif.pwrite {bins b7 = {0};  bins b8 = {1};}
    
    cp2_X_cp5: cross cp2 ,cp5{ bins b8 = binsof(cp2.b3)&&binsof(cp5.b8); }
    cp3_X_cp5: cross cp3 ,cp5{ bins b9 = binsof(cp3.b4)&&binsof(cp5.b8); }
    
  endgroup
  
  task run_wt;
    repeat(1) @(vif.mon_cb);
    if(!vif.mon_cb.preset) begin  
      reset_sample();
      @(sco_done);
      repeat(2) @(vif.mon_cb);
    end
      else begin
        @(posedge vif.pready);
        if(vif.mon_cb.pwrite) begin
          apb_cover.sample();
          write_op();
        end
      else begin
        @(negedge vif.pclk);
        #1;
        apb_cover.sample();
        read_op();
      end
      end
      $display($time,"[MON] : SAMPLED DATA SENT TO SCOREBOARD");
  endtask
  
  task run_zero_wt;
    repeat (1) @(vif.mon_cb);
    if(!vif.mon_cb.preset) begin
        reset_sample();
    @(sco_done);
      repeat(1) @(vif.mon_cb);
    end
      else begin
        repeat(2)@(vif.mon_cb);
        if(vif.pwrite) begin
          apb_cover.sample();
          write_op();
        end
      else begin
        #1;
        apb_cover.sample();
        read_op();
      end
      end
      $display($time,"[MON] : SAMPLED DATA SENT TO SCOREBOARD");
    @(sco_done);
  endtask
  
  
  
  task run;
    forever begin
      if($test$plusargs("zerowaitstate"))
        run_zero_wt();
      else 
        run_wt();
    end
  endtask
  
endclass


`endif
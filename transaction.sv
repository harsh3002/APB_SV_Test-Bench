`ifndef TRANS_APB_SV
`define TRANS_APB_SV

package transaction_pkg;

class transaction;
  
  rand bit preset;
   bit psel;
  rand bit pwrite;
   bit penable;
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;

  bit [31:0] prdata;
  bit pready;
  bit pslverr;

  
  constraint c_addr_rng {paddr inside {[0:127], 'hffff_ffff}; }
  constraint c_addr {paddr dist {[0:127]:/ 30, 'hffff_ffff:= 70}; }
  
  constraint c_preset {preset == 1; }

  constraint c_wdata_rng {pwdata inside {[0:255]}; }
  
  function transaction copy;
    copy = new;
    copy.preset = this.preset;
    copy.psel = this.psel;
    copy.pwrite = this.pwrite;
    copy.penable = this.penable;
    copy.paddr = this.paddr;
    copy.pwdata = this.pwdata;
  endfunction

endclass
  
endpackage


`endif
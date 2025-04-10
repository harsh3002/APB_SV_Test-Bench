`ifndef INTERFACE_SV
`define INTERFACE_SV


interface apb_interface();
  
  logic pclk;
  logic preset;
  logic psel;
  logic pwrite;
  logic penable;
  logic pready;
  logic pslverr;
  
  logic [31:0] paddr;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  
//   modport DUT (
//   	input pclk, preset,
//     input psel, penable,
// 	input pwrite,
//     input paddr,
//     input pwdata,
    
//     output prdata,
//     output pready,
//     output pslverr
//   );
  
  clocking drv_cb @(posedge pclk);
    default output #2;
    output preset;
    output psel, penable;
    output pwrite;
    output paddr;
    output pwdata;
  endclocking
  
  clocking mon_cb @(negedge pclk);
    input preset;
    input psel, penable;
	input pwrite;
    input paddr;
    input pwdata;
    input prdata;
    input pready;
    input pslverr;
  endclocking
  
//   property prop_st_trans;
//     psel |=> penable ##[0:5] pready;
//   endproperty
  
//   property prop_stable_addr;
//     psel |=> ##[0:5] ($stable(paddr));
//   endproperty 
  
//   property prop_stable_wdata;
//     psel |=> ##[0:5] ($stable(pwdata));
//   endproperty
      
//   property prop_stable_write;
//     psel |=> ##[0:5] ($stable(pwrite));
//   endproperty
    
// //   property prop_slverr;
//   //     (paddr== 32'ffff_ffff)   ##[0:5]  pslevrr;
// //   endproperty
  
//   assert property (@(posedge pclk) prop_st_trans)
//     else $error("[ASSERT] : State transition unsuccessful at time %0t",$time);
  
    
//     assert property (@(posedge pclk) prop_stable_addr)
//       else $error("[ASSERT] : PADDR not stable during transaction at time %0t",$time);
  
//       assert property (@(posedge pclk) prop_stable_wdata)
//         else $error("[ASSERT] : PWDATA not stable during transaction at time %0t",$time);
  
    
//         assert property (@(posedge pclk) prop_stable_write)
//     else $error("[ASSERT] : PWRITE not stable during transaction at time %0t",$time);
  
    
//           assert property (@(posedge pclk) prop_slverr)
//     else $error("[ASSERT] :  at time %0t",$time);
  
endinterface

`endif
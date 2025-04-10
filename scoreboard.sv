`include "transaction.sv"

`ifndef APB_SCORE_SV
`define APB_SCORE_SV

import transaction_pkg::*;

class scoreboard;

    transaction tr;
    mailbox #(transaction) mbx;
    event sco_done;
  int arr[];
    int err_count;
    int temp_rdata;

    function new(mailbox #(transaction) mbx, event sco_done);
        this.mbx = mbx;
        this.sco_done = sco_done;
      arr=new[128];
      foreach(arr[i]) begin
        if((i == 'h0) || (i == 'h4) || ( i== 'h8) || ( i== 'hC) ) begin
          case (i)
            'h0   : arr[i] = 'h0;
               'h4   : arr[i] = 'h0;
            'h8   : arr[i] = 'hcafe_1234;
            'hc   : arr[i] = 'hface_5678;
              endcase
            end 
        else 
          arr[i] = i;
        end
    endfunction 

    task error;
        if(tr.paddr == 32'hffff_ffff)
            $display("[SCO] : SLAVE ERROR CONDITION MATCHED");
        else  begin
           $display("[SCO] : UNIDENTIFIED SLAVE ERROR ENCOUNTERED");
            err_count++;
        end
    endtask 

    task write;
      $display($time,"[SCO] : WRITE OPERATION TO DUT");
        $display("[SCO] : WRITTEN DATA: %0h TO ADDRESS: %0h",tr.pwdata, tr.paddr);
      arr[tr.paddr] = tr.pwdata;
      
      $displayh("MEMORY : %p",arr);
    endtask

    task read;
      $display($time,"[SCO] : READ OPERATION FROM DUT");
        $display("[SCO] : READ DATA: %0h FROM ADDRESS: %0h",tr.prdata, tr.paddr);
        temp_rdata = arr[tr.paddr];
      $displayh("MEMORY : %p",arr);
    endtask

    task compare;
        if(temp_rdata == tr.prdata)
            $display("[SCO] : DATA READ MATCHED");
        else begin
            $display("[SCO] : DATA MISMATCHED");
            err_count++;
        end
    endtask

    task run;
        forever begin
            mbx.get(tr);
          #5;
          if(tr.preset) begin
            if(tr.pslverr)
                error;
            else begin
                if(tr.pwrite)
                    write;
                else begin
                    read;
                    compare;
                end
            end
          end
          else begin
            #5;
            $display("%0t [SCO]: RESET VERIFIED",$time);
          end
          $display("--------------------------------------------------------------------");
            ->sco_done;
        end
    endtask
endclass
`endif 
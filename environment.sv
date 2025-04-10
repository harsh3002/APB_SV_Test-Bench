`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
// `include "interface.sv"

`ifndef APB_ENV_SV
`define APB_ENV_SV

    class environment;

        generator g;
        driver d;
        monitor m;
        scoreboard s;
//       virtual apb_interface;

        event sco_done, mon_ack;
//         virtual apb_interface vif;

        mailbox #(transaction) gd_mbx;
        mailbox #(transaction) ms_mbx;

        function new(virtual apb_interface vif, int count);
             gd_mbx = new(1);
             ms_mbx = new(1);

             g = new(gd_mbx, sco_done, count);
          d = new(gd_mbx, vif, sco_done);
          m = new(ms_mbx, vif, sco_done);
             s = new(ms_mbx, sco_done);

        endfunction

        task pre_test;
            d.pre_reset();
        endtask

        task test;
            fork
                g.run();
                d.run();
                m.run();
                s.run();
            join_none
        endtask

        task post_test;
            wait(g.gen_done.triggered);
//           #100; 
            $display("[ENV] : TERMINATING TEST BENCH");
            $display("[ENV] : TOTAL MISMATCHED TRANSACTIONS: %0d", s.err_count);
          $display("[ENV] : Coverage percentage %0f",m.apb_cover.get_coverage());
            $finish;
        endtask

        task run;
            pre_test();
            test();
            post_test();
        endtask

    endclass

`endif 
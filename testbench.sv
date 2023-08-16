`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

module tb;
  
  monitor mon;
  generator gen;
  driver drv;
  scoreboard sco;
  
  event done;
  event drvnext;
  event sconext;
  
  int count;
  
  mailbox #(transaction) mbxgd, mbxms;
  
  axi_if vif();
  
  axi_slave dut (vif.clk, vif.resetn, vif.awvalid, vif.awready,  vif.awid, vif.awlen, vif.awsize, vif.awaddr,  vif.awburst, vif.wvalid, vif.wready, vif.wid, vif.wdata, vif.wstrb, vif.wlast, vif.bready, vif.bvalid, vif.bid, vif.bresp , vif.arready, vif.arid, vif.araddr, vif.arlen, vif.arsize, vif.arburst, vif.arvalid, vif.rid, vif.rdata, vif.rresp, vif.rlast,  vif.rvalid, vif.rready);
  
  initial begin
    vif.clk <= 0;
  end
  
  always #5 vif.clk <= ~vif.clk;
  
  initial begin
    count = 5;
    mbxgd = new();
    mbxms = new();
    gen = new(mbxgd, done, drvnext, sconext, count);
    drv = new(mbxgd, drvnext, vif);
    mon = new(mbxms, sconext, vif);
    sco = new(mbxms);
  end
  
  initial begin
    drv.reset();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any
    wait(gen.done.triggered);
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;  
  end
  
  assign vif.addr_wrapwr = dut.retaddr;
  assign vif.addr_wraprd = dut.rdretaddr;  
  
  
endmodule
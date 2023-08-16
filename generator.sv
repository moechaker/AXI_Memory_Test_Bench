class generator;
  
  transaction trans;
  mailbox #(transaction) mbxgd;
  
  event done; 
  event drvnext; 
  event sconext; 
 
   int count = 0;
  
  function new( mailbox #(transaction) mbxgd, event done, event drvnext, event sconext, int count);
    this.mbxgd = mbxgd;   
    this.done = done;
    this.drvnext = drvnext;
    this.sconext = sconext;
    this.count = count;
    trans = new();
  endfunction
  
    task run();
    
    for(int i=0; i <= count; i++) begin
      assert(trans.randomize) else $error("Randomization Failed!"); 
      
      if(trans.awburst == 2'b10)
          trans.awlen = 4'b0111;
      
      
      if(trans.arburst == 2'b10)
          trans.arlen = 4'b0111;
      $display("===================================");
      $display("[GEN] : WR :%0b RD:%0b WRBUR : %0d RDBUR: %0d WRADDR :%0d RDADDR : %0d WLEN :%0d RLEN :%0d",trans.awvalid, trans.arvalid, trans.awburst, trans.arburst, trans.awaddr, trans.araddr, trans.awlen, trans.arlen);
      
      mbxgd.put(trans);
      
      @(drvnext);
      @(sconext);
    end
    ->done;
  endtask
  
  
endclass
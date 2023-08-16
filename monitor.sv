class monitor;
  
  virtual axi_if vif;
  transaction trans;
  
  event sconext;
  int len = 0;
  
  mailbox #(transaction) mbxms;
  
  
  function new(mailbox #(transaction) mbxms, event sconext, virtual axi_if vif);
    this.mbxms = mbxms;
    this.sconext = sconext;
    this.vif = vif;
  endfunction
  
  task run();
    
    trans = new();
    
    forever 
      begin
        
        
      @(posedge vif.clk);
        
      //////////////////////////write logic  
        
    if(vif.awvalid == 1'b1) begin 
         len = vif.awlen + 1;  
         trans.awvalid = vif.awvalid;
         trans.arvalid = vif.arvalid;
         
         
      for(int i = 0; i< len; i++) begin
       @(posedge vif.wready); 
       @(posedge vif.clk);
       trans.awaddr = vif.awaddr;
       trans.wdata  = vif.wdata;
       trans.awburst = vif.awburst;   
       mbxms.put(trans);
       $display("[MON] : ADDR : %0x DATA : %0x BURST TYPE : %0d",trans.awaddr, trans.wdata, trans.awburst);    
      end
       
      @(posedge vif.clk);
      @(negedge vif.bvalid);
      @(posedge vif.clk);
      $display("[MON] : Transaction Complete");  
   end
 
     /////////////////////read logic   
        
       if(vif.arvalid == 1'b1)
        begin
         len = vif.arlen + 1;    
         trans.awvalid = vif.awvalid;
         trans.arvalid = vif.arvalid;
         
     
      for(int i = 0; i< len; i++) begin  
       @(posedge  vif.rvalid);
       @(posedge vif.clk);
       trans.rdata  = vif.rdata;
       trans.arburst = vif.arburst;
       trans.araddr = vif.araddr;
       mbxms.put(trans); 
       $display("[MON] : ADDR : %0x DATA : %0x BURST TYPE : %0d",trans.araddr, trans.rdata, trans.arburst);
       end
       
      @(posedge vif.clk);
      @(negedge vif.rlast);
      @(posedge vif.clk);
      $display("[MON] : Transaction Complete");
      end
       ->sconext; 
      end 
  endtask
  
  
  
endclass
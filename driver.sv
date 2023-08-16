class driver;
  
  virtual axi_if vif;
  
  transaction trans;
  
  mailbox #(transaction) mbxgd;
  
  event drvnext;
  
  function new(mailbox #(transaction) mbxgd, event drvnext, virtual axi_if vif);
    this.mbxgd = mbxgd;
    this.drvnext = drvnext;
    this.vif = vif;
  endfunction
  
  task reset();
    vif.resetn <= 1'b0; //active low
    
    vif.awvalid <= 0;
    vif.awid <= 0;
    vif.awlen <= 0;
    vif.awsize <= 0;
    vif.awaddr <= 0;
    vif.awburst <= 0;
    
    vif.wvalid <= 0;
    vif.wid <= 0;
    vif.wdata <= 0;
    vif.wstrb <= 0;
    vif.wlast <= 0;
    
    vif.bready <= 0;
    
    vif.arvalid <= 0;
    vif.arid <= 0;
    vif.arlen <= 0;
    vif.arsize <= 0;
    vif.araddr <= 0;
    vif.arburst <= 0;
    
    repeat(5) @(posedge vif.clk);
    vif.resetn <= 1'b1;
    
    $display("[DRV] RESET DONE!"); 
  endtask
  
 task fixed_write(input transaction trans);
      int len = 0;
      len = trans.awlen + 1;  //8
      $display("[DRV] : FIXED MODE -> DATA WRITE DONE");
      @(posedge vif.clk);     
      vif.resetn <= 1'b1;
      vif.awvalid <= 1'b1;
      vif.arvalid <= 1'b0;  ////disable read
      vif.awid    <= trans.id;
      vif.awlen   <= trans.awlen;
      vif.awsize  <= 3'b010;   ///4 byte 
      vif.awburst <= 2'b00;   //00
      vif.wvalid <= 1'b1;
      vif.wid    <= trans.id; 
      vif.wstrb  <= 4'b1111;
      vif.bready <= 1'b1;
      vif.awaddr  <= trans.awaddr;
      vif.wdata  <= $urandom_range(1,100);
      
      @(posedge vif.wready);
      @(posedge vif.clk);
    
    
    for(int i = 1; i< len ; i++) begin /// 1 2 3 4 5 6 7
      vif.awaddr  <= trans.awaddr;
      vif.wdata  <= $urandom_range(1,100);
      @(posedge vif.wready);
      @(posedge vif.clk);
      end
      
      vif.wlast  <= 1'b1;
      vif.awvalid <= 1'b0;
      vif.arvalid <= 1'b0;
      vif.wvalid   <= 1'b0;
      @(posedge vif.clk);
      vif.wlast  <= 1'b0;
      @(negedge vif.bvalid);
      ->drvnext;
     endtask
  
  ///////////////////////////Write data in Incr Mode //////
   
  task incr_write(input transaction trans);
      int len = 0;
      len = trans.awlen + 1;  //8
       $display("[DRV] : INCR MODE -> DATA WRITE DONE");
      @(posedge vif.clk);
      vif.resetn <= 1'b1;
      vif.arvalid <= 1'b0; ////disable read 
      vif.awvalid <= 1'b1;
      vif.awid    <= trans.id;
      vif.awlen   <= trans.awlen;
      vif.awsize  <= 3'b010;    
      vif.awburst <= 2'b01;   
      vif.wvalid <= 1'b1;
      vif.wid    <= trans.id; 
      vif.wstrb  <= 4'b1111;
      vif.bready <= 1'b1;
      vif.awaddr  <= trans.awaddr;
      vif.wdata  <= $urandom_range(1,100);
      
      @(posedge vif.wready);
      @(posedge vif.clk);
    
   for(int i = 1; i< len; i++) begin  ///i < 8  1 2 3 4 5 6 7
      vif.awaddr  <= trans.awaddr + 4*i;
      vif.wdata  <= $urandom_range(1,100);
      @(posedge vif.wready);
      @(posedge vif.clk);
    end
      
      vif.wlast   <= 1'b1;  
      vif.awvalid <= 1'b0;
      vif.arvalid <= 1'b0;
      vif.wvalid  <= 1'b0;
      @(posedge vif.clk);
      vif.wlast  <= 1'b0;
      @(negedge vif.bvalid);
   
    
      ->drvnext;
     endtask
  
  
  
  
  
  
   //////////////////////////////Write data in Wrap Mode
  
    task wrap_write(input transaction trans);
      int len = 0;
      len = trans.awlen + 1;  //8
      $display("[DRV] : WRAP MODE -> DATA WRITE DONE");
      @(posedge vif.clk);
      vif.arvalid <= 1'b0;  ///disable read
      vif.resetn <= 1'b1;
      vif.awvalid <= 1'b1;
      vif.awid    <= trans.id;
      vif.awlen   <= trans.awlen;
      vif.awsize  <= 3'b010;    
      vif.awburst <= 2'b10;   
      vif.wvalid <= 1'b1;
      vif.wid    <= trans.id; 
      vif.wstrb  <= 4'b1111;
      vif.bready <= 1'b1;
      
      
      vif.awaddr <= trans.awaddr;
      vif.wdata  <= $urandom_range(1,100);
      @(posedge vif.wready);
      @(posedge vif.clk);
    
      for(int i = 0; i < 7; i++) begin  ///0 1 2 3 4 5 6
      vif.awaddr  <= vif.addr_wrapwr;
      vif.wdata  <= $urandom_range(1,100);
      @(posedge vif.wready);
      @(posedge vif.clk);
      end
      
      vif.wlast  <= 1'b1;  
      @(posedge vif.clk);
      vif.wlast  <= 1'b0;
      vif.awvalid <= 1'b0;
      vif.arvalid <= 1'b0;
      vif.wvalid  <= 1'b0;
      @(negedge vif.bvalid);
   
      ->drvnext;
     endtask
  
  /////////////////////////////////read fixed mode
  
  task fixed_read(input transaction trans);
    
    int len = 0;
    len = trans.arlen + 1; //8
    $display("[DRV] : FIXED MODE -> DATA READ");
      @(posedge vif.clk);
      vif.awvalid <= 1'b0;  /////disable write transaction
      vif.resetn  <= 1'b1;
      vif.arvalid <= 1'b1;
      vif.arid    <= trans.id;
      vif.arlen   <= trans.arlen;
      vif.arsize  <= 3'b010;    
      vif.arburst <= 2'b00;
      vif.rready  <= 1'b1;
        
      for(int i = 0; i < len; i++) begin // 0 1  2 3 4 5 6 7
       vif.araddr  <= trans.araddr;
       @(posedge vif.arready);
       @(posedge vif.clk);
      end
       
     @(negedge vif.rlast);
     vif.arvalid <= 1'b0;
     vif.rready  <= 1'b0;
     
    ->drvnext;
    
    
    
  endtask
  
  
  
  ///////////////////////////////read incr mode
  
    task incr_read(input transaction trans);
      
      int len = 0;
      len = trans.arlen + 1;
      $display("[DRV] : INCR MODE -> DATA READ");
      @(posedge vif.clk);
      vif.awvalid <= 1'b0;  /////disable write transaction
      vif.resetn  <= 1'b1;
      vif.arvalid <= 1'b1;
      vif.arid    <= trans.id;
      vif.arlen   <= trans.arlen;
      vif.arsize  <= 3'b010;    
      vif.arburst <= 2'b01;
      vif.rready  <= 1'b1;
      
  
        
      for(int i = 0; i< len; i++) begin
       vif.araddr  <= trans.araddr + 4*i;
       @(posedge vif.arready);
       @(posedge vif.clk);
      end
       
     @(negedge vif.rlast);
     vif.arvalid <= 1'b0;
     vif.rready  <= 1'b0;
      
     ->drvnext;
    
    
    
  endtask
  
  
  
  //////////////////////////////////////////wrap mode
  
    task wrap_read(input transaction trans);
    
      int len = 0;
      len = 8;
      $display("[DRV] : WRAP MODE -> DATA READ COMPLETE");
      @(posedge vif.clk);
      vif.awvalid <= 1'b0;  /////disable write transaction
      vif.resetn  <= 1'b1;
      vif.arvalid <= 1'b1;
      vif.arid    <= trans.id;
      vif.arlen   <= 4'b0111;
      vif.arsize  <= 3'b010;    
      vif.arburst <= 2'b10;
      vif.rready  <= 1'b1;     
      vif.araddr  <= trans.araddr;
      @(posedge vif.rvalid);
      @(posedge vif.clk);
      
 
  
        
      for(int i = 0; i< 7; i++) begin /// 0123456  
        vif.araddr  <= vif.addr_wraprd;      
        @(posedge vif.rvalid);
        @(posedge vif.clk);
      end
       
     @(negedge vif.rlast);
     vif.arvalid <= 1'b0;
     vif.rready  <= 1'b0;
 
     ->drvnext;
    
  endtask
  
  
  
 
  
  ///////////////////////////////////////////////////////main task
  
  
  task run();
    
    forever begin
             
      mbxgd.get(trans);
     /////////////////////////write mode check and sig gen 
      if(trans.awvalid == 1'b1) begin
              if(trans.awburst == 2'b00)
                begin
                 fixed_write(trans);
                end
              else if (trans.awburst == 2'b01)
                begin
                incr_write(trans);
                end
              else if (trans.awburst == 2'b10)
                begin
                wrap_write(trans);
                end
 
      end   
     
     
   /////////////////////////////read mode check and sig gen
      
       if(trans.arvalid == 1'b1) begin
                 if(trans.arburst  == 2'b00)
                begin
                  fixed_read(trans);
                end
            else if (trans.arburst == 2'b01)
                begin
                incr_read(trans);
                end
            else if (trans.arburst == 2'b10)
                begin
                wrap_read(trans);
                end
                
          end  
    end
  endtask
  
  
endclass
class transaction;  
  
  rand bit [3:0] id;
  
  rand bit awvalid;
  bit awready;
  rand bit [3:0] awid;
  rand bit [3:0] awlen;
  rand bit [2:0] awsize; //4byte = 010
  rand bit [31:0] awaddr;
  rand bit [1:0] awburst;
  
  bit wvalid;
  bit wready;
  rand bit [3:0] wid;
  rand bit [31:0] wdata;
  rand bit [3:0] wstrb;
  bit wlast;
  
  bit bready;
  bit bvalid;
  bit [3:0] bid;
  bit [1:0] bresp;
  
  
  rand bit arvalid;  /// master is sending new address  
  bit arready;  /// slave is ready to accept request
  rand bit [3:0] arid; ////// unique ID for each transaction
  rand bit [3:0] arlen; ////// burst length AXI3 : 1 to 16, AXI4 : 1 to 256
  bit [2:0] arsize; ////unique transaction size : 1,2,4,8,16 ...128 bytes
  rand bit [31:0] araddr; ////write adress of transaction
  rand bit [1:0] arburst; ////burst type : fixed , INCR , WRAP
  
  /////////// read data channel (r)
  
  bit rvalid; //// master is sending new data
  bit rready; //// slave is ready to accept new data 
  rand bit [3:0] rid; /// unique id for transaction
  bit [31:0] rdata; //// data 
  bit [3:0] rstrb; //// lane having valid data
  bit rlast; //// last transfer in write burst
  bit [1:0] rresp; ///status of read transfer
  
  constraint valid_ct {awvalid != arvalid;}
  
  constraint addr_ct {
  	//awaddr > 0;
    //awaddr < 11;
    //araddr > 0;
    //araddr < 11;
    awaddr == 5;
    araddr > 3;
    araddr < 6;
  }
  
  constraint awsize_ct{
  	awsize >= 0;
    awsize < 3;
  }
  
  constraint burst_ct {
    awburst == 0;
    arburst == 0;
  }
  
  constraint arlen_ct{
    awlen >0;
  	arlen > 0;
    arlen <= 7;
  }
  
  /*constraint size_ct{
  	awsize == 3'b010; //4byte
  }*/
  
  constraint strb_ct{
  	wstrb == 4'b1111;
  }
  
  
endclass
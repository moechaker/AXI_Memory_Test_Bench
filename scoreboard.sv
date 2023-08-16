class scoreboard;
  transaction trans;
  
  mailbox #(transaction) mbxms;
  
  bit [31:0] temp;
  
  bit [7:0] data [128] = '{default:0};
  
  
  function new(mailbox #(transaction) mbxms);
    this.mbxms = mbxms;
  endfunction
  
  task run();
    
    forever 
      begin  
        
      
      mbxms.get(trans);
 
      
     if(trans.awvalid == 1'b1) begin
        data[trans.awaddr]     = trans.wdata[7:0];
        data[trans.awaddr + 1] = trans.wdata[15:8];
        data[trans.awaddr + 2] = trans.wdata[23:16];
        data[trans.awaddr + 3] = trans.wdata[31:24]; 
        
        $display("[SCO] : DATA STORED ADDR :%0x and DATA :%0x", trans.awaddr, trans.wdata[7:0]);
        end     
        
        if(trans.arvalid == 1'b1) begin
            temp = {data[trans.araddr + 3],data[trans.araddr + 2],data[trans.araddr + 1],data[trans.araddr] };
           
        $display("[SCO] : DATA READ ADDR :%0x and DATA :%0x MEM :%0x", trans.araddr, trans.rdata, temp);
          if(trans.rdata == 32'hc0c0c0c) 
          begin
           $display("[SCO] : DATA MATCHED : EMPTY LOCATION");
          end
          else if (trans.rdata == temp)
          begin
           $display("[SCO] : DATA MATCHED");
          end
          else
           begin
           $display("[SCO] : DATA MISMATCHED");
           end
       
        end
        
     
    end
  endtask
  
endclass
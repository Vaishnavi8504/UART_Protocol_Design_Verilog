`timescale 1ns/1ps
module test_bench_uart();
  reg clk,rst,d1_tx_start,d2_tx_start;
  reg [7:0]d1_tx_data;
  reg [7:0]d2_tx_data;
  wire d1_tx,d2_tx,d1_tx_done,d2_tx_done,d1_rx_done,d2_rx_done;
  wire[7:0]d1_rx_data;
  wire [7:0]d2_rx_data;
  device dut3(.clk(clk),.rst(rst),.tx_start(d1_tx_start),.tx_data(d1_tx_data),.rx(d2_tx),.tx_done(d1_tx_done),.rx_done(d1_rx_done),.rx_data(d1_rx_data),.tx(d1_tx));
device dut4(.clk(clk),.rst(rst),.tx_start(d2_tx_start),.tx_data(d2_tx_data),.rx(d1_tx),.tx_done(d2_tx_done),.rx_done(d2_rx_done),.rx_data(d2_rx_data),.tx(d2_tx));
 
 
 
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars(0,test_bench_uart);
  end
  initial begin
    clk=0;
    rst=0;
    d1_tx_start=0;
d2_tx_start=0;
  end 
  always #5 clk=~clk;
  initial begin
    rst=1'b1;
   d1_tx_start=1'b0;
     d2_tx_data=8'h00;
    d2_tx_start=1'b0;
     d1_tx_data=8'h00;
    #20
    rst=1'b0;
   
    //send the data 
    @(negedge  clk)
    d1_tx_data=8'haf;
    d1_tx_start=1'b1;
     d2_tx_data=8'hbc;
    d2_tx_start=1'b1;
    @(negedge  clk)
    d1_tx_start=1'b0;
    d2_tx_start=1'b0;
    wait (d1_rx_done );
    wait (d2_rx_done );
    if (d1_rx_data==d2_tx_data && d2_rx_data==d1_tx_data) begin
      $display("data is transfered succesfull from device 2 to device 1 %b to %b ",d1_rx_data,d2_tx_data);
      $display("data  is transfered  succesfull from device 1 to device 2 %b to %b ",d2_rx_data, d1_tx_data);
      // data is succesfully transfered from device 1 ro device 2 and vice versa 
  end
    else 
      $display("the transmission is not succesfull %d",d1_rx_data,d2_rx_data);
  
#50;
    $finish;
  end
  
endmodule 
           
       
   

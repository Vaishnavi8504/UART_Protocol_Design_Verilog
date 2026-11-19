`timescale 1ns / 1ps

module device(input clk,rst,tx_start,rx,input [7:0]tx_data,output tx,tx_done, rx_done ,output  [7:0]rx_data);
transmitter_uart dut1 (.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx(tx),.tx_done(tx_done));
  reciever_uart dut2(.clk(clk),.rst(rst),.rx_data(rx_data),.rx_done(rx_done),.rx(rx));
endmodule 



 

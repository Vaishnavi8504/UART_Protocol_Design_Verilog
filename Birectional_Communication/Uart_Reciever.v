module reciever_uart(input clk,rst,rx,
               output reg rx_done ,output reg [7:0]rx_data);
  parameter clk_per_cycle=8;
  parameter idle=0;
  parameter start=1;
  parameter data=2;
  parameter stop=3;
  parameter cleanup=4;
  reg [2:0]state;
  reg [7:0]clk_count ;
  reg [2:0]bit_index;
  always @(posedge clk or posedge rst)
    begin
      if (rst)
        begin 
          state<=idle;
          rx_done<=0;
          clk_count<=0;
          bit_index<=0;
          rx_data=8'b00000000;
        end
           else 
             begin
               case(state)
                 idle :
                   begin 
                     rx_done<=0;
          clk_count<=0;
          bit_index<=0;
                  if(rx==1'b0)
                         state<=start;
            
                   end
                 start:
                   begin 
                     if(clk_count<(clk_per_cycle/2)-1)
                      clk_count<=clk_count+1;
                     else 
                       begin
                       clk_count<=1'b0;
                       state<=data;
                       end
                   end
                 data:
                   begin
                    if(clk_count<clk_per_cycle-1)
                       clk_count<=clk_count+1;
                 else 
                   begin 
                     clk_count<=1'b0;
                     rx_data[bit_index]=rx;
                     if(bit_index<7)
                       bit_index<=bit_index+1;
                     else 
                       begin 
                       bit_index<=1'b0;
                         state<=stop;
                       end
                   end 
                   end 
                   stop:
                     begin
                       if(clk_count<clk_per_cycle-1)
                       clk_count<=clk_count+1;
                       else
                         begin
                         clk_count<=0;
                       rx_done<=1'b1;
                       state<=cleanup;
                         end
                     end
                 cleanup:
                   begin 
                     rx_done<=1'b0;
                    state<=idle;
                   end 
                     
               endcase
             end 
      end 
endmodule

`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Baudrate_Gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Baudrate_Gen
  #(
    parameter BAUDRATE = 19200,
    parameter CLOCK = 50000000, //revisar constraint
    parameter TICK_RATE = CLOCK / (BAUDRATE * 16),
    parameter N_TICK_COUNTER = $clog2(TICK_RATE)
    )
   (
    output wire tick,
    input wire clk,
    input wire reset
    );
    
    reg [N_TICK_COUNTER - 1 : 0] tick_counter;
    reg tick_flag;
    
    initial begin
        tick_counter = 0;
        tick_flag = 0;
    end
    
    always @(posedge clk) begin
       if(reset) begin
            tick_counter <= {N_TICK_COUNTER{1'b0}};
        end
       else begin
         if( tick_counter == TICK_RATE ) begin
            tick_counter <= 0;
            tick_flag <= 1;
            end 
       else begin
            tick_counter <= tick_counter + 1;
            tick_flag <= 0;
            end
       end
    end
    
    assign tick = tick_flag;
endmodule

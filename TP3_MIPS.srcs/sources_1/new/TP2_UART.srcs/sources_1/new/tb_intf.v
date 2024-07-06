`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: tb_intf
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


module tb_intf
#(
    parameter periodo = 20,
    parameter tick_time = 163,
    parameter ticks = 16,
    parameter test_time = periodo * tick_time * ticks,
    parameter bits = 10,
    parameter N_BITS = 8,
    parameter N_OPS = 6
 );
 
     wire [N_BITS - 1 : 0] Data_A;
     wire [N_BITS - 1 : 0] Data_B;
     wire [N_OPS - 1 : 0] Op;
     wire [N_BITS - 1 : 0] result;
     wire tx_start;
     reg clk;
     reg  [N_BITS - 1 : 0] uart;
     wire [N_BITS - 1 : 0] ALU;
     reg rx_done_tick;
     
    
    
    initial begin
        clk = 0;
        rx_done_tick = 0;
       
       #(test_time/bits);
       uart = 15;
       rx_done_tick = 1;
       #2;
       rx_done_tick = 0;
       #(test_time/bits);
       uart = 20;
       rx_done_tick = 1;
       #2;
       rx_done_tick = 0;
       #(test_time/bits);
       uart = 8'b00100000;
       rx_done_tick = 1;
       #2;
       rx_done_tick = 0;
        
    end
    
    always #1 clk = ~clk;
    
    Intf instance_Intf(
    .Data_A (Data_A), 
    .Data_B (Data_B), 
    .Op(Op),
    .result (result),
    .tx_start (tx_start),
    .clk (clk),
    .uart (uart),
    .ALU (ALU),
    .rx_done_tick (rx_done_tick)
    );
    
    ALU instance_ALU(
    .LEDS(ALU), 
    .Data_A (Data_A), 
    .Data_B (Data_B), 
    .Op(Op)
    );
    
    
endmodule
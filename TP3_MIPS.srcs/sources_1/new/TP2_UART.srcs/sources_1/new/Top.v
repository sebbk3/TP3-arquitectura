`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Top
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

module Top_UART
#(
    parameter N_BITS = 8,
    parameter N_OPS = 6
)
(
    output wire solution,
    output wire [N_BITS-1:0] o_rx_data,
	output wire o_rx_done_tick,
	output wire o_tx_done_tick,
    input wire clk,
    input wire  i_rx_data,
    input wire use_parity,
    input wire i_reset,
    input wire start,
    input wire [N_BITS-1:0] i_tx_data // Desde la ALU
    );
    
    //wire [N_BITS - 1 : 0] dout;
    wire solution_aux;
    wire tick;
    //wire rx_done_tick;
    //wire start;
    //wire [N_BITS - 1 : 0] result;
    //wire [N_BITS - 1 : 0] Data_A;
    //wire [N_BITS - 1 : 0] Data_B;
    //wire [N_OPS - 1 : 0] Op;
    //wire [N_BITS - 1 : 0] ALU;
    
    
    Baudrate_Gen instance_Baudrate_Gen(
    .clk (clk), 
    .tick (tick),
    .reset(i_reset)
    );
   
 /*   Rx instance_Rx(
    .dout (dout), 
    .rx_done_tick (rx_done_tick), 
    .clk (clk), 
    .s_tick (tick),
    .rx (data)
    );*/
    
    Rx_parity instance_Rx_parity(
    .dout (i_rx_data), 
    .rx_done_tick (o_rx_done_tick), 
    .clk (clk), 
    .s_tick (tick),
    .rx (i_rx_data),
    .use_parity (use_parity),
    .reset(i_reset)
    );

    Tx instance_Tx(
    .dout (solution_aux), 
    .clk (clk), 
    .s_tick (tick),
    .tx (i_tx_data),
    .start (start),
    .reset(i_reset),
    .o_tx_done_tick(o_tx_done_tick)
    );
    
/*    Intf instance_Intf(
    .Data_A (Data_A), 
    .Data_B (Data_B), 
    .Op(Op),
    .result (result),
    .tx_start (start),
    .clk (clk),
    .uart (dout),
    .ALU (ALU),
    .rx_done_tick (rx_done_tick)
    );
    
    ALU instance_ALU(
    .LEDS(ALU), 
    .Data_A (Data_A), 
    .Data_B (Data_B), 
    .Op(Op)
    );*/
    
    assign solution = solution_aux;
       
endmodule
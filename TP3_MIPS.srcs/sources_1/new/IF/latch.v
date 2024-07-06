`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: latch
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

// Guarda el valor del PC+4, puede ser distinto del que recibe el instruction memory que pasa por multiplexores
module latch#(
    parameter WIDTH = 32
)(
    input i_clock,
    input [WIDTH-1:0] i_next_pc,   
    output reg [WIDTH-1:0] o_next_pc
    );
    
    always@(posedge i_clock)begin
        o_next_pc <= i_next_pc;
    end
    
endmodule

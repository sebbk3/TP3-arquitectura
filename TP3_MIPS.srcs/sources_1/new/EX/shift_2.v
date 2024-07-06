`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: shift_2
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

//Este modulo hace un shift a la izquierda en 2, para los branches
module shift_2 #(
        parameter WIDTH = 32
    )
    (
        input [WIDTH-1:0] i_immediate,    
        output [WIDTH-1:0] o_shifted_left
    );
    
    assign o_shifted_left = i_immediate << 2;
endmodule

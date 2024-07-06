`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: mux_4_1
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

//Modulo de multiplexor 4 a 1 creado para que no se creen latchs en el sistema
module mux_4_1#(
        parameter WIDTH = 32
    )
    (
        input [1:0] i_SEL,
        input [WIDTH-1:0] i_A,
        input [WIDTH-1:0] i_B,
        input [WIDTH-1:0] i_C,
        input [WIDTH-1:0] i_D,
        output reg [WIDTH-1:0] o_Result
    );
    
    always @ (*) begin
        case (i_SEL)
            1'b00 : o_Result <= i_A;
            1'b01 : o_Result <= i_B;
            1'b10 : o_Result <= i_C;
            1'b11 : o_Result <= i_D;
        endcase
    end
    
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: mux_2_1
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

//Modulo de multiplexor 2 a 1 creado para que no se creen latchs en el sistema
module mux_2_1#(
        parameter WIDTH = 32
    )
    (
        input i_SEL,
        input [WIDTH-1:0] i_A,
        input [WIDTH-1:0] i_B,
        output reg [WIDTH-1:0] o_Result
    );
    
    always @ (*) begin
        case (i_SEL)
            1'b0 : o_Result <= i_A;
            1'b1 : o_Result <= i_B;
        endcase
    end
    
endmodule

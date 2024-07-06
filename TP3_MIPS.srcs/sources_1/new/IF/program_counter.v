`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: program_counter
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


module program_counter #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] i_next_pc,
    input i_clock,
    input i_enable,   // desde PC
    input i_reset,
    input i_pc_stall, // desde STALL - > (normal 0) - > (stall pc 1)
    output reg [WIDTH-1:0] o_pc
    );
    
    initial begin
        // Si no ponemos esto la salida
        // esta indefinida antes de que pase
        // el primer posedge en los tests
        o_pc = 0;
    end
    
    always@(posedge i_clock)
        if(i_reset) begin
            o_pc <= {WIDTH{1'b0}};
        end
        else if(i_enable) begin  
            if(!i_pc_stall)begin
                // Si pc_stall es 1, significa que tengo un stall, negado, vale 0, que es true
                o_pc <= o_pc;
            end
            else begin
                o_pc <= i_next_pc;
            end
        end
        else begin
            // Este es un default
            o_pc <= o_pc;
        end
    
endmodule

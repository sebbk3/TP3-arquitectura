`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: extend_bus
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


module extend_bus#(
        parameter WIDTH_IN = 5,
        parameter WIDTH_OUT = 32
    )(
        input [WIDTH_IN-1:0] i_data,
        output reg [WIDTH_OUT-1:0] o_data
    );
    
    always@(*) begin
        o_data = {27'b0, i_data};
    end
endmodule
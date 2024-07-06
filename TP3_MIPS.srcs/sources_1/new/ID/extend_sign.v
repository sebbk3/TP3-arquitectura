`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: extend_sign
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


module extend_sign#(
        parameter WIDTH_IN = 16,
        parameter WIDTH_OUT = 32
    )(
        input [WIDTH_IN-1:0] i_data,
        output reg [WIDTH_OUT-1:0] o_data
    );
    
    always@(*) begin
        o_data[WIDTH_IN-1:0] = i_data[WIDTH_IN-1:0];
        o_data[WIDTH_OUT-1:WIDTH_IN] = {WIDTH_IN{i_data[WIDTH_IN-1]}};  // se extiende el signo de i_data[15]
    end    
endmodule

`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: tb_baudrate
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


module tb_baudrate(

    );
    reg clk;
    wire tick;
    
    initial begin
        clk = 0;
    end
    
    always #1 clk = ~clk;
    
    
    Baudrate_Gen instance_Baudrate_Gen(
    .clk (clk), 
    .tick (tick)
    );
endmodule

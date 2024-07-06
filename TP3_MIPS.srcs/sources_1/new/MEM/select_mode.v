`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: select_mode
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


module select_mode#(
        parameter ADDRESS_BYTES = 5
)
(
        input i_debug_unit_flag,
        input i_memory_data_read_enable,
        input [ADDRESS_BYTES-1:0] i_memory_data_read_addr,
        input i_mem_read,
        input i_mem_write,
        input [ADDRESS_BYTES-1:0] i_alu_result,
        output reg [ADDRESS_BYTES-1:0] o_address,
        output reg o_mem_read_enable,
        output reg o_mem_write_enable
    );
    
    always @(*) begin
        if (i_debug_unit_flag) begin
            o_mem_read_enable = i_memory_data_read_enable;
            o_mem_write_enable = 1'b0;
            o_address = i_memory_data_read_addr;
        end else begin
            o_mem_read_enable = i_mem_read;
            o_mem_write_enable = i_mem_write;
            o_address = i_alu_result;
        end
    end
    
endmodule

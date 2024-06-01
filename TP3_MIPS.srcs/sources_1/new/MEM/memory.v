`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: memory
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


module memory#(
    parameter MEM_CELL_SIZE = 32,
    parameter MAX_ADDRESS = 16,
    parameter ADDRESS_BYTES = 4,
    parameter DATA_WIDTH = 32,
    parameter TYPE_WIDTH = 2
  )(
  
    input i_signed,
    input i_write,
    input i_read,
    input [TYPE_WIDTH-1:0] i_word_size,
    input [DATA_WIDTH-1:0] i_write_data,
    input i_clock,
    input i_enable,
    input i_read_enable,
    input i_write_enable,
    input [ADDRESS_BYTES-1:0] i_address,
    input [MEM_CELL_SIZE-1:0] i_value_to_write,
    
    output [DATA_WIDTH-1:0] o_ctr_read_data,
    output [MEM_CELL_SIZE-1:0] o_mem_read_value
    );
    
    wire [DATA_WIDTH-1:0] write_data;
    wire [DATA_WIDTH-1:0] read_data;
    wire [DATA_WIDTH-1:0] o_ctr_read_data_aux;
    
    memory_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .TYPE_WIDTH(TYPE_WIDTH)
    ) memory_controller(
        .i_signed(i_signed),
        .i_write(i_write),
        .i_read(i_read),
        .i_word_size(i_word_size),
        .i_write_data(i_write_data),
        .i_read_data(read_data),
        .o_write_data(write_data),
        .o_read_data(o_ctr_read_data_aux)
    );
    
    
    memory_data #(
        .MEM_CELL_SIZE(MEM_CELL_SIZE),
        .MAX_ADDRESS(MAX_ADDRESS),
        .ADDRESS_BYTES(ADDRESS_BYTES)
    ) memory_data (
        .i_clock(i_clock), 
        .i_enable(i_enable),
        .i_read_enable(i_read_enable),
        .i_write_enable(i_write_enable),
        .i_address(i_address),
        .i_value_to_write(write_data),
        .o_read_value(read_data)
    );
    
    assign o_ctr_read_data = o_ctr_read_data_aux;
    assign o_mem_read_value = read_data;
    
endmodule

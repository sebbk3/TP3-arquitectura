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
    parameter MAX_ADDRESS = 32,
    parameter ADDRESS_BYTES = 5,
    parameter DATA_WIDTH = 32,
    parameter REG_WIDTH = 5,
    parameter TYPE_WIDTH = 3,
    parameter WIDTH_PC = 32
  )(
  
    input i_signed,
    input i_complete_word,              // Indica si es completa la palabra 32 bits
    input i_halfword_enable,          // Indica si es media palabra 16 bits
    input i_byte_enable,              // Indica que es solo 8 bits
    input [DATA_WIDTH-1:0] i_write_data,
    input i_clock,
    input i_debug_unit_flag,                            // Flag de read y addr para DEBUG UNIT
    input i_memory_data_enable,                         // Enable Mem data          DEBUG UNIT
    input i_memory_data_read_enable,                    // Enable Memory Read       DEBUG UNIT
    input [ADDRESS_BYTES-1:0] i_memory_data_read_addr,    // Addr for data to read    DEBUG UNIT
    input i_mem_read,                                   // read data memory flag
    input i_mem_write, 
    input [MAX_ADDRESS-1:0] i_alu_result,
    input i_branch,
    input i_zero,
    input [WIDTH_PC-1:0] i_branch_addr,
    input [REG_WIDTH-1:0] i_selected_reg,
    input i_reg_write,
    input i_mem_to_reg,
    input i_last_register_ctrl,
    input [WIDTH_PC-1:0] i_pc,
    input i_halt,
    
    output [DATA_WIDTH-1:0] o_ctr_read_data,
    output [MEM_CELL_SIZE-1:0] o_mem_read_value,
    output [MAX_ADDRESS-1:0] o_alu_result,
    output o_branch_zero,
    output [WIDTH_PC-1:0] o_branch_addr,
    output [REG_WIDTH-1:0] o_selected_reg,
    output o_reg_write,
    output o_mem_to_reg,
    output o_last_register_ctrl,
    output [WIDTH_PC-1:0] o_pc,
    output o_halt
    );
    
    wire [DATA_WIDTH-1:0] write_data;
    wire [DATA_WIDTH-1:0] read_data;
    wire [ADDRESS_BYTES-1:0] address;
    wire mem_read_enable;
    wire mem_write_enable;
    
    select_mode#(
        .ADDRESS_BYTES(ADDRESS_BYTES)
        )
        select_mode(
        .i_debug_unit_flag(i_debug_unit_flag),
        .i_memory_data_read_enable(i_memory_data_read_enable),
        .i_memory_data_read_addr(i_memory_data_read_addr),
        .i_mem_read(i_mem_read),
        .i_mem_write(i_mem_write),
        .i_alu_result(i_alu_result[ADDRESS_BYTES-1:0]),
        .o_address(address),
        .o_mem_read_enable(mem_read_enable),
        .o_mem_write_enable(mem_write_enable)
    );
    
    memory_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .TYPE_WIDTH(TYPE_WIDTH)
    ) memory_controller(
        .i_signed(i_signed),
        .i_write(mem_write_enable),
        .i_read(mem_read_enable),
        .i_word_size({i_complete_word,i_halfword_enable,i_byte_enable}),
        .i_write_data(i_write_data),
        .i_read_data(read_data),
        .o_write_data(write_data),
        .o_read_data(o_ctr_read_data)
    );
    
    
    memory_data #(
        .MEM_CELL_SIZE(MEM_CELL_SIZE),
        .MAX_ADDRESS(MAX_ADDRESS),
        .ADDRESS_BYTES(ADDRESS_BYTES)
    ) memory_data (
        .i_clock(i_clock), 
        .i_enable(i_memory_data_enable),
        .i_read_enable(mem_read_enable),
        .i_write_enable(mem_write_enable),
        .i_address(address),
        .i_value_to_write(write_data),
        .o_read_value(read_data)
    );
    
    
    assign o_branch_zero = i_zero & i_branch;
    assign o_branch_addr = i_branch_addr;
    assign o_alu_result = i_alu_result;
    assign o_selected_reg = i_selected_reg; 
    assign o_reg_write = i_reg_write;
    assign o_mem_to_reg = i_mem_to_reg;
    assign o_last_register_ctrl = i_last_register_ctrl;
    assign o_pc = i_pc;
    assign o_halt = i_halt;
    assign o_mem_read_value = read_data;
    
endmodule

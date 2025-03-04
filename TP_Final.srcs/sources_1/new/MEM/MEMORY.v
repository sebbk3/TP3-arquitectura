`timescale 1ns / 1ps

module MEMORY#(
        parameter NB_ADDR       = 32,
        parameter NB_DATA       = 32,
        parameter NB_PC         = 32,
        parameter NB_MEM_ADDR   = 5,
        parameter MEMORY_WIDTH  = 32,
        parameter NB_REG        = 5
    )
    (
        input                       i_clock,
        input                       i_debug_unit_flag,          // Flag de read y addr para DEBUG UNIT
        input                       i_signed,                   
        input                       i_memory_data_enable,       // Habilita la memoria de datos, viene de la DEBUG UNIT
        input                       i_memory_data_read_enable,  // Habilita la lectura de la memoria para la DEBUG UNIT (select_mode)
        input [NB_MEM_ADDR-1:0]     i_memory_data_read_addr,    // Direccion de lectura, viene de DEBUG UNIT
        input                       i_reg_write,                // Registro a escribir, pasamanos a WB
        input                       i_mem_to_reg,               // Pasamanos a WB, le indica si el valor viene de la memoria
        input                       i_mem_read,                 // Flag de lectura de la memoria
        input                       i_mem_write,                // Flag de escritura de la memoria
        input                       i_complete_word,            // Indica si es completa la palabra 32 bits
        input                       i_halfword_enable,          // Indica si es media palabra 16 bits
        input                       i_byte_enable,              // Indica que es solo 8 bits
        input                       i_branch,                   
        input                       i_zero,                      
        input [NB_PC-1:0]           i_branch_addr,              
        input [NB_ADDR-1:0]         i_alu_result,               
        input [NB_DATA-1:0]         i_write_data,               // Dato a escribir en la memoria 
        input [NB_REG-1:0]          i_selected_reg,             // Pasa a WB para que pase a ID, sobre si es registro RD or RT
        input                       i_last_register_ctrl,       // Cuando se usa el ultimo REG para almacenar la direccion o PC
        input [NB_PC-1:0]           i_pc,
        input                       i_halt,

        output [NB_DATA-1:0]        o_mem_data,                 // Hacia banco de registros o DEBUG UNIT
        output [NB_DATA-1:0]        o_read_dm,
        output [NB_REG-1:0]         o_selected_reg,             
        output [NB_ADDR-1:0]        o_alu_result,               // Lo usan los de tipo R o store (pero no los loads)
        output [NB_PC-1:0]          o_branch_addr,              // PC = o_branch_addr
        output                      o_branch_zero,              // Selector para el mux del IF
        output                      o_reg_write,                // WB flag
        output                      o_mem_to_reg,               // WB flag
        output                      o_last_register_ctrl,
        output [NB_PC-1:0]          o_pc,
        output                      o_halt);

    wire [NB_DATA-1:0]      write_data;
    wire [NB_DATA-1:0]      read_data;

    wire [NB_MEM_ADDR-1:0]   addr;
    wire                     mem_read;
    wire                     mem_write;

    select_mode select_mode
    (
        .i_debug_unit_flag(i_debug_unit_flag),
        .i_memory_data_read_enable(i_memory_data_read_enable),
        .i_memory_data_read_addr(i_memory_data_read_addr),
        .i_mem_read(i_mem_read),
        .i_mem_write(i_mem_write),
        .i_alu_result(i_alu_result[NB_MEM_ADDR-1:0]),

        .o_addr(addr),
        .o_mem_read(mem_read),
        .o_mem_write(mem_write)
    );

    mem_controller mem_controller
    (
        .i_signed(i_signed),
        .i_write(mem_write),
        .i_read(mem_read),
        .i_word_size({i_complete_word,i_halfword_enable,i_byte_enable}),
        .i_write_data(i_write_data),
        .i_read_data(read_data),                                            // Desde MEM para reg/debug
        
        .o_write_data(write_data),                                          // Escribir en MEM
        .o_read_data(o_mem_data)
    ); 

    mem_data mem_data
    (
        .i_clock(i_clock),
        .i_enable(i_memory_data_enable),
        .i_write(mem_write),
        .i_read(mem_read),
        .i_read_addr(addr),
        .i_write_data(write_data),
        
        .o_read_data(read_data)
    ); 
    
    // IF
    assign o_branch_zero = i_zero & i_branch;
    assign o_branch_addr = i_branch_addr;

    // WB
    assign o_alu_result             = i_alu_result;
    assign o_selected_reg           = i_selected_reg; 
    assign o_reg_write              = i_reg_write;
    assign o_mem_to_reg             = i_mem_to_reg;
    assign o_last_register_ctrl     = i_last_register_ctrl;
    assign o_pc                     = i_pc;
    assign o_halt                   = i_halt;

    // DEBUG UNIT
    assign o_read_dm        = read_data;

endmodule
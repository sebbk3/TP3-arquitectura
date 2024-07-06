`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch #(
    parameter WIDTH = 32,
    parameter WIDTH_PC = 32,
    parameter MAX_NUM_OF_INSTRUCTIONS = 32,
    parameter MAX_NUM_OF_INSTRUCTIONS_BINARY = 6
) (
    input i_clock,
    input i_branch,                                 // 1 -> Hay branch, 0 -> No hay branch
    input i_j_jal,                                  // 1 -> Hay jump, 0 -> No hay jump
    input i_jr_jalr,                                // 1 -> Hay jump, 0 -> No hay jump
    input i_pc_enable,                              // Enable PC
    input i_pc_reset,                               // Reset PC
    input i_read_enable,                            // Enable para leer en instruccion_memory
    input i_instru_mem_enable,                      // Enable para el modulo instruccion_memory
    input i_write_enable,                           // Enable para escribir en instruccion_memory 
    input [WIDTH-1:0] i_write_data,                                     // Data a escribir en instruccion_memory 
    input [MAX_NUM_OF_INSTRUCTIONS_BINARY-1:0] i_write_addr,           // Direccion [0-31] que se escribira en instruccion_emory 
    input [WIDTH_PC-1:0] i_branch_addr,             // Branching
    input [WIDTH_PC-1:0] i_jump_addr,               // J y JAL
    input [WIDTH_PC-1:0] i_data_last_register,      // JR y JALR
    input i_pc_stall,             
        
    output [WIDTH_PC-1:0] o_last_pc,              // PC
    output [WIDTH_PC-1:0] o_adder_result,         // PC+4
    output [WIDTH-1:0] o_instruction
);
    wire [WIDTH-1:0] i_A;
    reg [WIDTH-1:0] i_B = 32'd4;
    wire [WIDTH-1:0] o_pc;
    wire [WIDTH_PC-1:0] adder_result;   
    reg [WIDTH_PC-1:0] case_1;
    reg [WIDTH_PC-1:0] case_2;
    reg [WIDTH_PC-1:0] case_3;
    wire [WIDTH-1:0] instruction;

    adder adder (
        .i_A(o_pc),
        .i_B(i_B),
        .o_Result(adder_result)
    );
     
     always @ (*) begin
        case (i_branch)
            1'b0 : case_1 <= adder_result;
            1'b1 : case_1 <= i_branch_addr;
        endcase
        
        case (i_j_jal)
            1'b0 : case_2 <= case_1;
            1'b1 : case_2 <= i_jump_addr;
        endcase
        
        case (i_jr_jalr)
            1'b0 : case_3 <= case_2;
            1'b1 : case_3 <= i_data_last_register;
        endcase
    end
     
     
   program_counter program_counter(
        .i_next_pc(case_3),
        .i_clock(i_clock),
        .i_enable(i_pc_enable),   // desde PC
        .i_reset(i_pc_reset),
        .i_pc_stall(i_pc_stall),
        .o_pc(o_pc)
    );
    
    instruction_memory instruction_memory(
        .i_clock(i_clock),
        .i_enable(i_instru_mem_enable),    // Debug Unit Control                            
        .i_read_enable(i_read_enable),  
        .i_write_enable(i_write_enable),   // Debug Unit Control, cargar instrucciones desde UART
        .i_write_data(i_write_data),       // Debug Unit Control, la instruccion que viene de la UART
        .i_write_addr(i_write_addr),
        .i_instruction_address(o_pc),
        .o_instruction(instruction)
    );
    
    latch latch(
        .i_clock(i_clock),
        .i_next_pc(adder_result),   
        .o_next_pc(o_adder_result)
    );
    
    assign o_last_pc = o_pc;
    assign o_instruction = instruction;
endmodule

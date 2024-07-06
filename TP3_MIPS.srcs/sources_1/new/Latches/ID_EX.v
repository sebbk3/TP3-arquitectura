`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: ID_EX
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


module ID_EX#(
        parameter WIDTH_ALU_OP = 6,
        parameter WIDTH_IMM = 32,
        parameter WIDTH_PC = 32,
        parameter WIDTH_DATA = 32,
        parameter WIDTH_REG = 5
    )
    (
        input i_clock,
        input i_reset,
        input i_pipeline_enable,
        input i_signed,
        input i_reg_write,
        input i_mem_to_reg,
        input i_mem_read,
        input i_mem_write,
        input i_branch,
        input i_alu_src,
        input i_reg_dest,
        input [WIDTH_ALU_OP-1:0] i_alu_op,
        input [WIDTH_PC-1:0] i_pc,
        input [WIDTH_DATA-1:0] i_data_a,
        input [WIDTH_DATA-1:0] i_data_b,
        input [WIDTH_IMM-1:0] i_immediate,
        input [WIDTH_DATA-1:0] i_shamt,
        input [WIDTH_REG-1:0] i_rt,
        input [WIDTH_REG-1:0] i_rd,
        input [WIDTH_REG-1:0] i_rs,
        input i_byte_enable,
        input i_halfword_enable,
        input i_word_enable,
        input i_halt,
        input i_jump,
        input i_jr_jalr,
        
        output reg o_signed,
        output reg o_reg_write,
        output reg o_mem_to_reg,
        output reg o_mem_read,
        output reg o_mem_write,
        output reg o_branch,
        output reg o_alu_src,
        output reg o_reg_dest,
        output reg [WIDTH_ALU_OP-1:0] o_alu_op,
        output reg [WIDTH_PC-1:0] o_pc,
        output reg [WIDTH_DATA-1:0] o_data_a,
        output reg [WIDTH_DATA-1:0] o_data_b,
        output reg [WIDTH_IMM-1:0] o_immediate,
        output reg [WIDTH_DATA-1:0] o_shamt,
        output reg [WIDTH_REG-1:0] o_rt,
        output reg [WIDTH_REG-1:0] o_rd,
        output reg [WIDTH_REG-1:0] o_rs,
        output reg o_byte_enable,
        output reg o_halfword_enable,
        output reg o_word_enable,
        output reg o_halt,
        output reg o_jump,
        output reg o_jr_jalr
    );

    always @(negedge i_clock) begin
        if(i_reset) begin                                       // Si hay reset, todo a 0
            o_signed              <= 1'b0;
            o_reg_write           <= 1'b0;
            o_mem_to_reg          <= 1'b0;
            o_mem_read            <= 1'b0;
            o_mem_write           <= 1'b0;
            o_branch              <= 1'b0;
            o_alu_src             <= 1'b0;
            o_reg_dest            <= 1'b0;
            o_alu_op              <= 6'b0;
            o_pc                  <= 32'b0;
            o_data_a              <= 32'b0;
            o_data_b              <= 32'b0;
            o_immediate           <= 32'b0;
            o_shamt               <= 32'b0;
            o_rt                  <= 5'b0;
            o_rd                  <= 5'b0;
            o_rs                  <= 5'b0;
            o_byte_enable         <= 1'b0;
            o_halfword_enable     <= 1'b0;
            o_word_enable         <= 1'b0;
            o_halt                <= 1'b0;
            o_jump                <= 1'b0;
            o_jr_jalr             <= 1'b0;
        end
        else begin
            if(i_pipeline_enable) begin                         // Si el pipeline esta habilitado, la entrada pasa a la salida
                o_signed              <= i_signed;
                o_reg_write           <= i_reg_write;
                o_mem_to_reg          <= i_mem_to_reg;
                o_mem_read            <= i_mem_read;
                o_mem_write           <= i_mem_write;
                o_branch              <= i_branch;
                o_alu_src             <= i_alu_src;
                o_reg_dest            <= i_reg_dest;
                o_alu_op              <= i_alu_op;
                o_pc                  <= i_pc;
                o_data_a              <= i_data_a;
                o_data_b              <= i_data_b;
                o_immediate           <= i_immediate;
                o_shamt               <= i_shamt;
                o_rt                  <= i_rt;
                o_rd                  <= i_rd;
                o_rs                  <= i_rs;
                o_byte_enable         <= i_byte_enable;
                o_halfword_enable     <= i_halfword_enable;
                o_word_enable         <= i_word_enable;
                o_halt                <= i_halt;
                o_jump                <= i_jump;
                o_jr_jalr             <= i_jr_jalr;
            end
            else begin                                         // Caso contrario, se mantiene el valor
                o_signed              <= o_signed;
                o_reg_write           <= o_reg_write;
                o_mem_to_reg          <= o_mem_to_reg;
                o_mem_read            <= o_mem_read;
                o_mem_write           <= o_mem_write;
                o_branch              <= o_branch;
                o_alu_src             <= o_alu_src;
                o_reg_dest            <= o_reg_dest;
                o_alu_op              <= o_alu_op;
                o_pc                  <= o_pc;
                o_data_a              <= o_data_a;
                o_data_b              <= o_data_b;
                o_immediate           <= o_immediate;
                o_shamt               <= o_shamt;
                o_rt                  <= o_rt;
                o_rd                  <= o_rd;
                o_rs                  <= o_rs;
                o_byte_enable         <= o_byte_enable;
                o_halfword_enable     <= o_halfword_enable;
                o_word_enable         <= o_word_enable;
                o_halt                <= o_halt;
                o_jump                <= o_jump;
                o_jr_jalr             <= o_jr_jalr;
            end
        end
    end
    
endmodule

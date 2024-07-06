`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM#(
        parameter WIDTH_PC = 32,
        parameter WIDTH_REG = 5
    )
    (
        input i_clock,
        input i_reset,
        input i_pipeline_enable,                        // DEBUG UNIT
        input i_flush,                                  // UNIT STALL:  1 -> Flush control signals 0 -> !flush
        input i_signed,
        input i_reg_write,
        input i_mem_to_reg,
        input i_mem_read,
        input i_mem_write,
        input i_branch,
        input [WIDTH_PC-1:0] i_branch_addr,
        input i_zero,
        input [WIDTH_PC-1:0] i_alu_result,
        input [WIDTH_PC-1:0] i_data_b,
        input [WIDTH_REG-1:0] i_selected_reg,
        input i_byte_enable,
        input i_halfword_enable,
        input i_word_enable,
        input i_last_register_ctrl,
        input [WIDTH_PC-1:0] i_pc,
        input i_halt,
        input i_jump,
        input i_jr_jalr,

        output reg o_signed,
        output reg o_reg_write,
        output reg o_mem_to_reg,
        output reg o_mem_read,
        output reg o_mem_write,
        output reg o_branch,
        output reg [WIDTH_PC-1:0] o_branch_addr,
        output reg o_zero,
        output reg [WIDTH_PC-1:0] o_alu_result,
        output reg [WIDTH_PC-1:0] o_data_b,
        output reg [WIDTH_REG-1:0] o_selected_reg,
        output reg o_byte_enable,
        output reg o_halfword_enable,
        output reg o_word_enable,
        output reg o_last_register_ctrl,
        output reg [WIDTH_PC-1:0] o_pc,
        output reg o_halt,
        output reg o_jump,
        output reg o_jr_jalr
    );

    always @(negedge i_clock) begin
        if(i_reset) begin                                   // Si hay reset, todo a 0
            o_signed                  <= 1'b0;
            o_reg_write               <= 1'b0;
            o_mem_to_reg              <= 1'b0;
            o_mem_read                <= 1'b0;
            o_mem_write               <= 1'b0;
            o_branch                  <= 1'b0;
            o_branch_addr             <= 32'b0;
            o_zero                    <= 1'b0;
            o_alu_result              <= 32'b0;
            o_data_b                  <= 32'b0;
            o_selected_reg            <= 5'b0;
            o_byte_enable             <= 1'b0;
            o_halfword_enable         <= 1'b0;
            o_word_enable             <= 1'b0;
            o_last_register_ctrl      <= 1'b0;
            o_pc                      <= 32'b0;
            o_halt                    <= 1'b0;
            o_jump                    <= 1'b0;
            o_jr_jalr                 <= 1'b0;
        end
        else begin
            if(i_pipeline_enable) begin
                if(i_flush)begin                                            // Si hay flush, todo a 0, excepto lo que me es util 
                    o_signed                  <= 1'b0;
                    o_reg_write               <= 1'b0;
                    o_mem_to_reg              <= 1'b0;
                    o_mem_read                <= 1'b0;
                    o_mem_write               <= 1'b0;
                    o_branch                  <= 1'b0;
                    o_branch_addr             <= i_branch_addr;
                    o_zero                    <= 1'b0;
                    o_alu_result              <= i_alu_result;
                    o_data_b                  <= i_data_b;
                    o_selected_reg            <= i_selected_reg;
                    o_byte_enable             <= 1'b0;
                    o_halfword_enable         <= 1'b0;
                    o_word_enable             <= 1'b0;
                    o_last_register_ctrl      <= 1'b0;
                    o_pc                      <= i_pc;
                    o_halt                    <= 1'b0;
                    o_jump                    <= 1'b0;
                    o_jr_jalr                 <= 1'b0;
                end
                else begin                                                  // No hay Reset, esta habilitada la pipeline, no hay flush, es decir, todo normal
                    o_signed                  <= i_signed;
                    o_reg_write               <= i_reg_write;
                    o_mem_to_reg              <= i_mem_to_reg;
                    o_mem_read                <= i_mem_read;
                    o_mem_write               <= i_mem_write;
                    o_branch                  <= i_branch;
                    o_branch_addr             <= i_branch_addr;
                    o_zero                    <= i_zero;
                    o_alu_result              <= i_alu_result;
                    o_data_b                  <= i_data_b;
                    o_selected_reg            <= i_selected_reg;
                    o_byte_enable             <= i_byte_enable;
                    o_halfword_enable         <= i_halfword_enable;
                    o_word_enable             <= i_word_enable;
                    o_last_register_ctrl      <= i_last_register_ctrl;
                    o_pc                      <= i_pc;
                    o_halt                    <= i_halt;
                    o_jump                    <= i_jump;
                    o_jr_jalr                 <= i_jr_jalr;
                end
            end
            else begin                                                      // No esta habilitado el pipeline, Debug Unit
                o_signed                  <= o_signed;
                o_reg_write               <= o_reg_write;
                o_mem_to_reg              <= o_mem_to_reg;
                o_mem_read                <= o_mem_read;
                o_mem_write               <= o_mem_write;
                o_branch                  <= o_branch;
                o_branch_addr             <= o_branch_addr;
                o_zero                    <= o_zero;
                o_alu_result              <= o_alu_result;
                o_data_b                  <= o_data_b;
                o_selected_reg            <= o_selected_reg;
                o_byte_enable             <= o_byte_enable;
                o_halfword_enable         <= o_halfword_enable;
                o_word_enable             <= o_word_enable;
                o_last_register_ctrl      <= o_last_register_ctrl;
                o_pc                      <= o_pc;
                o_halt                    <= o_halt;
                o_jump                    <= o_jump;
                o_jr_jalr                 <= o_jr_jalr;
            end
        end
    end
endmodule

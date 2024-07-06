`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB#(
        parameter WIDTH_DATA = 32,
        parameter WIDTH_REG  = 5,
        parameter WIDTH_PC   = 32
    )
    (
        input i_clock,
        input i_reset,
        input i_pipeline_enable,                      //  DEBUG UNIT

        input i_reg_write,                            // Si se necesita escribir en un registro
        input i_mem_to_reg,                           // Si es de Memoria a Registro
        input [WIDTH_DATA-1:0] i_mem_data,            // Valor que viene de la Memoria
        input [WIDTH_DATA-1:0] i_alu_result,          // Resultado de la ALU
        input [WIDTH_REG-1:0] i_selected_reg,         // Valor de la addr del registro donde escribir
        input i_last_register_ctrl,                   // Si es necesario el ULTIMO REG
        input [WIDTH_PC-1:0] i_pc,                    // Valor de o_pc
        input i_halt,                                 // o_halt

        output reg o_reg_write,
        output reg o_mem_to_reg,           
        output reg [WIDTH_DATA-1:0] o_mem_data,             
        output reg [WIDTH_DATA-1:0] o_alu_result,           
        output reg [WIDTH_REG-1:0] o_selected_reg,
        output reg o_last_register_ctrl,
        output reg [WIDTH_PC-1:0] o_pc,
        output reg o_halt
    );
    
    always@(negedge i_clock) begin
        if(i_reset) begin                                                 // Si hay reset, todo a 0
            o_reg_write               <= 1'b0;
            o_mem_to_reg              <= 1'b0;
            o_mem_data                <= 32'b0;
            o_alu_result              <= 32'b0;
            o_selected_reg            <= 5'b0;
            o_last_register_ctrl      <= 1'b0;
            o_pc                      <= 32'b0;
            o_halt                    <= 1'b0;
        end
        else begin
            if(i_pipeline_enable) begin                                   // Todo normal
                o_reg_write           <= i_reg_write;
                o_mem_to_reg          <= i_mem_to_reg;
                o_mem_data            <= i_mem_data;
                o_alu_result          <= i_alu_result;
                o_selected_reg        <= i_selected_reg;
                o_last_register_ctrl  <= i_last_register_ctrl;
                o_pc                  <= i_pc;
                o_halt                <= i_halt;
            end
            else begin                                                   // Debug unit
            o_reg_write               <= o_reg_write;
            o_mem_to_reg              <= o_mem_to_reg;
            o_mem_data                <= o_mem_data;
            o_alu_result              <= o_alu_result;
            o_selected_reg            <= o_selected_reg;
            o_last_register_ctrl      <= o_last_register_ctrl;
            o_pc                      <= o_pc;
            o_halt                    <= o_halt;
        end
        end
    end
endmodule

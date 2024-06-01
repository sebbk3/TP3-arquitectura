`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: write_back
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


`timescale 1ns / 1ps

module write_back#(
        parameter NB_DATA = 32,
        parameter NB_REG  = 5,
        parameter NB_PC   = 32
    )
    (   input                   i_reg_write,            // Pasamano de que SI se escribe en un registro
        input                   i_mem_to_reg,           // MUX selector de ALU RESULT y VALOR OBTENIDO DE LA MEMORIA
        input [NB_DATA-1:0]     i_mem_data,             // i_mem_to_reg = 1
        input [NB_DATA-1:0]     i_alu_result,           // i_mem_to_reg = 0
        input [NB_REG-1:0]      i_selected_reg,         // Direccion del registro donde escribir
        input                   i_last_register_ctrl,   // Si se escribe en el ultimo registro debido a JAL y JALR
        input [NB_PC-1:0]       i_pc,                   // Valor de Program Counter
        input                   i_halt,                 // Si se genero un HALT

        output                  o_reg_write,            // Indica si se escribe en un REGISTRO
        output [NB_DATA-1:0]    o_selected_data,        // Valor que se escribe
        output [NB_REG-1:0]     o_selected_reg,         // Valor de la direccion DONDE se escribe
        output                  o_halt                  // HALT
    );
      
    reg [NB_DATA-1:0] aux_reg;
    reg [NB_DATA-1:0] aux_reg_2;
    
    always @ (*) begin
        case (i_mem_to_reg)
            1'b0 : aux_reg <= i_alu_result;
            1'b1 : aux_reg <= i_mem_data;
        endcase
        case (i_last_register_ctrl)
            1'b0 : aux_reg_2 <= aux_reg;
            1'b1 : aux_reg_2 <= i_pc;
        endcase
    end
    
    assign o_selected_data   = aux_reg_2;    
    assign o_reg_write       = i_reg_write;
    assign o_selected_reg    = i_selected_reg;
    assign o_halt            = i_halt;
endmodule
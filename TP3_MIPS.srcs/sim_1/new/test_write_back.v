`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: test_write_back
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


module test_write_back;

    parameter NB_DATA = 32;
    parameter NB_REG  = 5;
    parameter NB_PC   = 32;
    
    reg                   i_reg_write;            // Pasamano de que SI se escribe en un registro
    reg                   i_mem_to_reg;           // MUX selector de ALU RESULT y VALOR OBTENIDO DE LA MEMORIA
    reg [NB_DATA-1:0]     i_mem_data;             // i_mem_to_reg = 1
    reg [NB_DATA-1:0]     i_alu_result;           // i_mem_to_reg = 0
    reg [NB_REG-1:0]      i_selected_reg;         // Direccion del registro donde escribir
    reg                   i_last_register_ctrl;   // Si se escribe en el ultimo registro debido a JAL y JALR
    reg [NB_PC-1:0]       i_pc;                   // Valor de Program Counter
    reg                   i_halt;                 // Si se genero un HALT

    wire                  o_reg_write;            // Indica si se escribe en un REGISTRO
    wire [NB_DATA-1:0]    o_selected_data;        // Valor que se escribe
    wire [NB_REG-1:0]     o_selected_reg;         // Valor de la direccion DONDE se escribe
    wire                  o_halt;                  // HALT
    
    write_back #(.NB_DATA(NB_DATA), .NB_REG(NB_REG), .NB_PC(NB_PC)) UUT(
    .i_reg_write(i_reg_write),            // Pasamano de que SI se escribe en un registro
    .i_mem_to_reg(i_mem_to_reg),           // MUX selector de ALU RESULT y VALOR OBTENIDO DE LA MEMORIA
    .i_mem_data(i_mem_data),             // i_mem_to_reg = 1
    .i_alu_result(i_alu_result),           // i_mem_to_reg = 0
    .i_selected_reg(i_selected_reg),         // Direccion del registro donde escribir
    .i_last_register_ctrl(i_last_register_ctrl),   // Si se escribe en el ultimo registro debido a JAL y JALR
    .i_pc(i_pc),                   // Valor de Program Counter
    .i_halt(i_halt),                 // Si se genero un HALT

    .o_reg_write(o_reg_write),            // Indica si se escribe en un REGISTRO
    .o_selected_data(o_selected_data),        // Valor que se escribe
    .o_selected_reg(o_selected_reg),         // Valor de la direccion DONDE se escribe
    .o_halt(o_halt)                  // HALT
    );
    
    always #10;
    initial begin
        i_reg_write = 8'b1;
        i_mem_to_reg = 1'b0;
        i_last_register_ctrl = 1'b0;
        i_mem_data = 32'b11111;
        i_alu_result = 32'b11110;
        i_selected_reg = 4'b0;
        i_pc = 32'b11101;
        i_halt = 1'b0;
    end;
    
    initial begin
        #10
        if (o_reg_write != 8'b1) begin
           $display("Valor esperado: %b - valor obtenido: %b", 8'b1, o_reg_write);
            $finish;
        end
        if (o_selected_reg != 4'b0) begin
           $display("Valor esperado: %b - valor obtenido: %b", 4'b0, o_selected_reg);
            $finish;
        end
        if (o_halt != 1'b0) begin
           $display("Valor esperado: %b - valor obtenido: %b", 1'b0, o_halt);
            $finish;
        end
        if (o_selected_data != 32'b11110) begin
           $display("Valor esperado: %b - valor obtenido: %b", 32'b11110, o_selected_data);
            $finish;
        end
        i_mem_to_reg = 1'b1;
        #10
       if (o_selected_data != 32'b11111) begin
           $display("Valor esperado: %b - valor obtenido: %b", 32'b11111, o_selected_data);
            $finish;
        end
        
        i_mem_to_reg = 1'b0;
        i_last_register_ctrl= 1'b1;
        #10
        if (o_selected_data != 32'b11101) begin
           $display("Valor esperado: %b - valor obtenido: %b", 32'b11101, o_selected_data);
            $finish;
        end
        
        i_mem_to_reg = 1'b1;
        i_last_register_ctrl= 1'b1;
        #10
        if (o_selected_data != 32'b11101) begin
           $display("Valor esperado: %b - valor obtenido: %b", 32'b11101, o_selected_data);
            $finish;
        end
        
        $display("Todos los tests exitosos");
        $finish;
    end;
    

endmodule

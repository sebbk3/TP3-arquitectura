`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: test_alu_control
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

`define RTYPE_OPCODE 6'b000000
// Loads
`define LB_OPCODE    6'b100000
`define LH_OPCODE    6'b100001
`define LHU_OPCODE   6'b100010
`define LW_OPCODE    6'b100011
`define LWU_OPCODE   6'b100100
`define LBU_OPCODE   6'b100101
// Stores
`define SB_OPCODE    6'b101000
`define SH_OPCODE    6'b101001
`define SW_OPCODE    6'b101011

`define ADDI_OPCODE  6'b001000
`define ANDI_OPCODE  6'b001100
`define ORI_OPCODE   6'b001101
`define XORI_OPCODE  6'b001110
`define BEQ_OPCODE   6'b000100

`define BNE_OPCODE   6'b000101
`define SLTI_OPCODE  6'b001010
`define LUI_OPCODE   6'b001111
`define JAL_OPCODE   6'b000011
// Function codes
`define SLL_FCODE    6'b000000
`define SRL_FCODE    6'b000010
`define SRA_FCODE    6'b000011
`define SLLV_FCODE   6'b000100
`define SRLV_FCODE   6'b000110
`define SRAV_FCODE   6'b000111
`define JALR_FCODE   6'b001001
`define ADD_FCODE    6'b100000
`define ADDU_FCODE   6'b100001
`define SUB_FCODE    6'b100010
`define SUBU_FCODE   6'b100011
`define AND_FCODE    6'b100100
`define OR_FCODE     6'b100101
`define XOR_FCODE    6'b100110
`define NOR_FCODE    6'b100111
`define SLT_FCODE    6'b101010

module test_alu_control;

    // Parameters
    parameter   WIDTH_FCODE        = 6;
    parameter   WIDTH_OPCODE       = 6;
    parameter   WIDTH_ALU_CTRLI    = 4;
    
    // Inputs
    reg [WIDTH_FCODE-1     : 0] i_funct_code;
    reg [WIDTH_OPCODE-1    : 0] i_op_code;
    
    // Outputs
    wire [WIDTH_ALU_CTRLI-1 : 0] o_alu_ctrl;

    // Unit under test
    alu_control #(
    .WIDTH_FCODE(WIDTH_FCODE), 
    .WIDTH_OPCODE(WIDTH_OPCODE), 
    .WIDTH_ALU_CTRLI(WIDTH_ALU_CTRLI)
    ) uut(
        .i_funct_code(i_funct_code),
        .i_op_code(i_op_code),
        .o_alu_ctrl(o_alu_ctrl)
    );
    
    initial begin
        i_funct_code = 6'b000000;
        i_op_code = 6'b000000;
    end

    initial begin
        
        i_op_code = `RTYPE_OPCODE;
        i_funct_code = `SLL_FCODE;
        #1;
        if (o_alu_ctrl != 4'b1101) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1101, o_alu_ctrl);
            $finish;
        end
        #10;
        
        i_funct_code = `SRL_FCODE;
        #10;
        if (o_alu_ctrl != 4'b1110) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1110, o_alu_ctrl);
            $finish;
        end

        #10;
        i_funct_code = `SRA_FCODE;
        #10;
        if (o_alu_ctrl != 4'b1111) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1111, o_alu_ctrl);
            $finish;
        end
       
        #10;
        i_funct_code = `SLLV_FCODE;
        #10;
        if (o_alu_ctrl != 4'b1101) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1101, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `SRLV_FCODE;
        #10;
        if (o_alu_ctrl != 4'b1110) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1110, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `SRAV_FCODE;
        #10;
        if (o_alu_ctrl != 4'b1111) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1111, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `ADD_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `ADDU_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `SUB_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0110) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0110, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `SUBU_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0110) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0110, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `AND_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0000) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0000, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `OR_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0001) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0001, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `XOR_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0011) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0011, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `NOR_FCODE;
        #10;
        if (o_alu_ctrl != 4'b1100) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1100, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `SLT_FCODE;
        #10;
        if (o_alu_ctrl != 4'b0100) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0100, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_funct_code = `JALR_FCODE;
        #10;
        if (o_alu_ctrl != 4'h00) begin
            $display("Valor esperado: 0 - valor obtenido: %b", o_alu_ctrl);
            $finish;
        end

        
        
        //AHORA CAMBIO LOS OPCODES, EN VEZ DE FUNCTION CODE
        
        #10;
        i_op_code = `LB_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `LH_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `LW_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `LWU_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `LBU_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `LHU_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `SB_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `SH_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `SW_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `ADDI_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0010) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0010, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `ANDI_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0000) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0000, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `ORI_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0001) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0001, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `XORI_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0011) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0011, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `LUI_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b1001) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1001, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `SLTI_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0100) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0100, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `BEQ_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b0111) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b0111, o_alu_ctrl);
            $finish;
        end
        
        #10;
        i_op_code = `BNE_OPCODE;
        #10;
        if (o_alu_ctrl != 4'b1000) begin
            $display("Valor esperado: %b - valor obtenido: %b", 4'b1000, o_alu_ctrl);
            $finish;
        end
        
        $display("Tests ok");
        $finish;
    end


endmodule

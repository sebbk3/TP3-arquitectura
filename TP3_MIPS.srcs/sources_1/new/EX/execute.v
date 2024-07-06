`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: execute
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


module execute #(
    parameter WIDTH = 32,
    parameter WIDTH_FCODE = 6,
    parameter WIDTH_OPCODE = 6,
    parameter WIDTH_ALU_CTRLI = 4,
    parameter WIDTH_PC = 32,   
    parameter WIDTH_REG = 5,
    parameter WIDTH_SEL = 2
)(
    input [WIDTH-1:0] i_data_A,
    input [WIDTH-1:0] i_data_B,
    input [WIDTH_OPCODE-1:0] i_op_code,  //input [NB_ALU_OP-1:0]   i_alu_op,
    input i_signed,
    input i_reg_write,                  // WB flag
    input i_mem_to_reg,                 // WB flag
    input i_mem_read,                   // MEM flag
    input i_mem_write,                  // MEM flag
    input i_branch,                     // MEM flag
    input i_alu_src,
    input i_reg_dest,
    input [WIDTH_PC-1:0] i_pc,
    input [WIDTH-1:0] i_immediate,
    input [WIDTH-1:0] i_shamt,
    input [WIDTH_REG-1:0] i_rt,
    input [WIDTH_REG-1:0] i_rd,
    input i_byte_enable,
    input i_halfword_enable,
    input i_word_enable,
    input i_halt,
    input [WIDTH-1:0] i_mem_fwd_data,       // forwarding
    input [WIDTH-1:0] i_wb_fwd_data,        // forwarding
    input [WIDTH_SEL-1:0] i_fwd_a,          // forwarding
    input [WIDTH_SEL-1:0] i_fwd_b,          // forwarding
    input [WIDTH_SEL-1:0] i_forwarding_mux, // forwarding
    input i_jump,
  
    output [WIDTH-1:0] o_alu_result,
    output o_signed,
    output o_reg_write,
    output o_mem_to_reg,
    output o_mem_read,
    output o_mem_write,
    output o_branch,
    output [WIDTH_PC-1:0] o_branch_addr,
    output o_zero,
    output [WIDTH-1:0] o_data_b,
    output [WIDTH_REG-1:0] o_selected_reg,
    output o_byte_enable,
    output o_halfword_enable,
    output o_word_enable,
    output o_last_register_ctrl,
    output [WIDTH_PC-1:0] o_pc,
    output o_halt,
    output o_jump
    );
    
    wire [WIDTH_ALU_CTRLI-1:0] alu_ctrl;
    wire [WIDTH-1:0] shifted_imm;
    wire [WIDTH_PC-1:0] branch_addr;
    wire [WIDTH-1:0] out_mux2_shamt_OR_dataA;
    wire [WIDTH-1:0] dataB_or_Inm;
    wire [WIDTH-1:0] alu_data_a;
    wire [WIDTH-1:0] alu_data_b;
    wire zero;
    wire [WIDTH-1:0] alu_result;
    wire [WIDTH_REG-1:0] RT_or_RD;
    wire [WIDTH_REG-1:0] selected_reg;
    wire [WIDTH_FCODE-1:0] funct_code;
    wire [WIDTH-1:0] data_b;
    wire select_shamt;
    wire last_register_ctrl;
    reg [WIDTH_REG-1:0] last_register = 5'd31;
    
    assign funct_code = i_immediate [WIDTH_FCODE-1:0];
    
    adder #(
        .WIDTH(WIDTH)
    )adder_EX
    (
        .i_A(i_pc),
        .i_B(shifted_imm),
        .o_Result(branch_addr)
    );
    
    alu_control #(
        .WIDTH_FCODE(WIDTH_FCODE),
        .WIDTH_OPCODE(WIDTH_OPCODE),
        .WIDTH_ALU_CTRLI(WIDTH_ALU_CTRLI)
    ) alu_control(
        .i_funct_code(funct_code),
        .i_op_code(i_op_code),
        .o_alu_ctrl(alu_ctrl),
        .o_shamt_ctrl(select_shamt),
        .o_last_register_ctrl(last_register_ctrl)
    );
    
    ALU #(
        .BUS_SIZE(WIDTH)
    ) ALU (
        .i_A(alu_data_a), 
        .i_B(alu_data_b),
        .i_alu_ctrl(alu_ctrl),
        .o_zero(zero),
        .o_salida(alu_result)
    );
    
    shift_2 #(
        .WIDTH(WIDTH)
    )shift_2(
        .i_immediate(i_immediate),    
        .o_shifted_left(shifted_imm)
    );
    
    mux_2_1 #(
        .WIDTH(WIDTH)
    ) mux_dataB__Immediate
    (
        .i_SEL(i_alu_src),
        .i_A(i_data_B),
        .i_B(i_immediate),
        .o_Result(dataB_or_Inm)
    );

    mux_2_1 #(
        .WIDTH(WIDTH_REG)
    ) mux_RT_RD
    (
        .i_SEL(i_reg_dest),
        .i_A(i_rt),
        .i_B(i_rd),
        .o_Result(RT_or_RD)
    );

    mux_2_1 #(
        .WIDTH(WIDTH_REG)    
    ) mux_RTvRD_LASTREG
    (
        .i_SEL(last_register_ctrl),
        .i_A(RT_or_RD),
        .i_B(last_register),
        .o_Result(selected_reg)
    );

    mux_2_1 #(
        .WIDTH(WIDTH)
    ) mux_shamt_dataA
    (
        .i_SEL(select_shamt),
        .i_A(i_shamt),
        .i_B(i_data_A),
        .o_Result(out_mux2_shamt_OR_dataA)
    );
        
    mux_4_1 #(
        .WIDTH(WIDTH)
    ) mux_shamtVdataA_memData_forwardData
    (
        .i_SEL(i_fwd_a),
        .i_A(out_mux2_shamt_OR_dataA), 
        .i_B(i_mem_fwd_data),  
        .i_C(i_wb_fwd_data),  
        .i_D(),
        .o_Result(alu_data_a)
    );

    mux_4_1 #(
        .WIDTH(WIDTH)
    ) mux_dataBvInm_memData_forwarDdata
    (
        .i_SEL(i_fwd_b),
        .i_A(dataB_or_Inm),         
        .i_B(i_mem_fwd_data),    
        .i_C(i_wb_fwd_data),     
        .i_D(),
        .o_Result(alu_data_b)
    );

    mux_4_1 #(
        .WIDTH(WIDTH)
    ) mux_memData_wbData_dataB
    (   //Dato normal, Dato de WriteBack, Dato de Memoria
        .i_SEL(i_forwarding_mux),
        .i_A(i_mem_fwd_data),  
        .i_B(i_wb_fwd_data),  
        .i_C(i_data_B), 
        .i_D(),
        .o_Result(data_b)
    );

    assign o_signed = i_signed;
    assign o_reg_write = i_reg_write;
    assign o_mem_to_reg = i_mem_to_reg;
    assign o_mem_read = i_mem_read;
    assign o_mem_write = i_mem_write;
    assign o_branch = i_branch;
    assign o_branch_addr = branch_addr;
    assign o_zero = zero;
    assign o_alu_result = alu_result;
    assign o_data_b = data_b; 
    assign o_selected_reg = selected_reg;
    assign o_byte_enable = i_byte_enable;
    assign o_halfword_enable = i_halfword_enable;
    assign o_word_enable = i_word_enable;
    assign o_last_register_ctrl = last_register_ctrl;
    assign o_pc = i_pc;
    assign o_halt = i_halt;
    assign o_jump = i_jump;

endmodule

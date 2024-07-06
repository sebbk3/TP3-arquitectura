`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2024 11:55:58 PM
// Design Name: 
// Module Name: test_debug_unit
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

// Estados
`define INITIAL            4'b0000
`define WRITE_IM           4'b0001
`define READY              4'b0010
`define START              4'b0011
`define STEP_BY_STEP       4'b0100
`define SEND_PC            4'b0101
`define READ_BR            4'b0110
`define SEND_BR            4'b0111
`define READ_MEM           4'b1000
`define SEND_MEM           4'b1001


// Comandos UART
`define CMD_WRITE_IM        8'b00000001 // Escribir programa
`define CMD_CONTINUE        8'b00000010 // Ejecucion continua
`define CMD_STEP_BY_STEP    8'b00000011 // Step-by-step
`define CMD_SEND_PC         8'b00000100 // Leer TODO
`define CMD_STEP            8'b00000101 // Send step

module test_debug_unit;

    // Definición de parámetros
    parameter WIDTH_STATE = 4;
    parameter WIDTH_DATA = 8;
    parameter IM_CELL_SIZE = 32;
    parameter MAX_NUM_OF_INSTRUCTIONS_BINARY = 6;
    parameter WIDTH_ADDR = 32;
    parameter WIDTH_ADDR_REG = 5;
    parameter WIDTH_BYTE_CTR = 2;
    parameter WIDTH_ADDR_MEM = 5;
    parameter MEM_MAX_ADDRESS = 32;
    parameter MEM_CELL_SIZE = 32;
    parameter REG_MAX_ADDRESS = 32;
    parameter WIDTH_PC_CTR = 2;

    // Señales de entrada
    reg i_clock;
    reg i_reset;
    reg i_halt;
    reg i_rx_done;
    reg i_tx_done;
    reg [WIDTH_DATA-1:0] i_rx_data;
    reg [WIDTH_ADDR-1:0] i_pc_value;
    reg [MEM_CELL_SIZE-1:0] i_mem_data;
    reg [WIDTH_ADDR-1:0] i_bank_reg_data;

    // Señales de salida
    wire [IM_CELL_SIZE-1:0] o_instru_mem_data;
    wire [MAX_NUM_OF_INSTRUCTIONS_BINARY-1:0] o_instru_mem_addr;
    wire [WIDTH_ADDR_REG-1:0] o_rb_addr;
    wire [WIDTH_ADDR_MEM-1:0] o_mem_data_addr;
    wire [WIDTH_DATA-1:0] o_tx_data;
    wire o_tx_start;
    wire o_instru_mem_write_enable;
    wire o_instru_mem_read_enable;
    wire o_instru_mem_enable;
    wire o_rb_read_enable;
    wire o_rb_enable;
    wire o_mem_data_enable;
    wire o_mem_data_read_enable;
    wire o_mem_data_debug_unit;
    wire o_unit_control_enable;
    wire o_pc_enable;
    wire [WIDTH_STATE-1:0] o_state;
    wire o_pipeline_enable;

    // Instanciación del módulo a testear
    debug_unit #(
        .WIDTH_STATE(WIDTH_STATE),
        .WIDTH_DATA(WIDTH_DATA),
        .IM_CELL_SIZE(IM_CELL_SIZE),
        .MAX_NUM_OF_INSTRUCTIONS_BINARY(MAX_NUM_OF_INSTRUCTIONS_BINARY),
        .WIDTH_ADDR(WIDTH_ADDR),
        .WIDTH_ADDR_REG(WIDTH_ADDR_REG),
        .WIDTH_BYTE_CTR(WIDTH_BYTE_CTR),
        .WIDTH_ADDR_MEM(WIDTH_ADDR_MEM),
        .MEM_MAX_ADDRESS(MEM_MAX_ADDRESS),
        .MEM_CELL_SIZE(MEM_CELL_SIZE),
        .REG_MAX_ADDRESS(REG_MAX_ADDRESS),
        .WIDTH_PC_CTR(WIDTH_PC_CTR)
    ) uut (
        .i_clock(i_clock),
        .i_reset(i_reset),
        .i_halt(i_halt),
        .i_rx_done(i_rx_done),
        .i_tx_done(i_tx_done),
        .i_rx_data(i_rx_data),
        .i_pc_value(i_pc_value),
        .i_mem_data(i_mem_data),
        .i_bank_reg_data(i_bank_reg_data),
        .o_instru_mem_data(o_instru_mem_data),
        .o_instru_mem_addr(o_instru_mem_addr),
        .o_rb_addr(o_rb_addr),
        .o_mem_data_addr(o_mem_data_addr),
        .o_tx_data(o_tx_data),
        .o_tx_start(o_tx_start),
        .o_instru_mem_write_enable(o_instru_mem_write_enable),
        .o_instru_mem_read_enable(o_instru_mem_read_enable),
        .o_instru_mem_enable(o_instru_mem_enable),
        .o_rb_read_enable(o_rb_read_enable),
        .o_rb_enable(o_rb_enable),
        .o_mem_data_enable(o_mem_data_enable),
        .o_mem_data_read_enable(o_mem_data_read_enable),
        .o_mem_data_debug_unit(o_mem_data_debug_unit),
        .o_unit_control_enable(o_unit_control_enable),
        .o_pc_enable(o_pc_enable),
        .o_state(o_state),
        .o_pipeline_enable(o_pipeline_enable)
    );

    // Generación del reloj
    initial begin
        i_clock = 0;
        forever #5 i_clock = ~i_clock;
    end

    // Secuencia de prueba
    initial begin
        // Inicialización de señales
        i_reset = 1;
        i_halt = 0;
        i_rx_done = 0;
        i_tx_done = 0;
        i_rx_data = 0;
        i_pc_value = 0;
        i_mem_data = 0;
        i_bank_reg_data = 0;

        // Liberar reset después de 10 ns
        #10 i_reset = 0;

        // Enviar comando CMD_WRITE_IM para cambiar al estado WRITE_IM
        #10 i_rx_data = `CMD_WRITE_IM; i_rx_done = 1;
        #10 i_rx_done = 0;
        
        // Enviar 3 valores de 32 bits como bytes individuales
        // Valor 1: 32'hAABBCCDD
        #10 i_rx_data = 8'hAA; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'hBB; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'hCC; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'hDD; i_rx_done = 1; #10 i_rx_done = 0;
        
        // Verificar que o_instru_mem_data tenga el valor correcto
        #10 if (o_instru_mem_data !== 32'hAABBCCDD) $display("Error: instru_mem_data no es correcto para el valor 1");

        // Valor 2: 32'h11223344
        #10 i_rx_data = 8'h11; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'h22; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'h33; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'h44; i_rx_done = 1; #10 i_rx_done = 0;

        // Verificar que o_instru_mem_data tenga el valor correcto
        #10 if (o_instru_mem_data !== 32'h11223344) $display("Error: instru_mem_data no es correcto para el valor 2");

        // Valor 3: 32'h55667788
        #10 i_rx_data = 8'h55; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'h66; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'h77; i_rx_done = 1; #10 i_rx_done = 0;
        #10 i_rx_data = 8'h88; i_rx_done = 1; #10 i_rx_done = 0;

        // Verificar que o_instru_mem_data tenga el valor correcto
        #10 if (o_instru_mem_data !== 32'h55667788) $display("Error: instru_mem_data no es correcto para el valor 3");

        // Finalización de la simulación
        #100 $stop;
    end

endmodule
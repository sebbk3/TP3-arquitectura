`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Intf
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

module Intf
#(
    parameter N_BITS = 8,
    parameter N_OPS = 6,
    parameter N_INPUTS = 3
)
(
    output wire [N_BITS - 1 : 0] Data_A,
    output wire [N_BITS - 1 : 0] Data_B,
    output wire [N_OPS - 1 : 0] Op,
    output wire [N_BITS - 1 : 0] result,
    output wire tx_start,
    input wire clk,
    input wire  [N_BITS - 1 : 0] uart,
    input wire [N_BITS - 1 : 0] ALU,
    input wire rx_done_tick
    );
  

    localparam N_STATES = 4;
    localparam [N_STATES - 1 : 0] FIRST_DATA = 4'b0001;
    localparam [N_STATES - 1 : 0] SECOND_DATA = 4'b0010;
    localparam [N_STATES - 1 : 0] OPERATION = 4'b0100;
    localparam [N_STATES - 1 : 0] SEND = 4'b1000;

    reg [N_STATES - 1 : 0] state_alu;
    reg [N_STATES - 1 : 0] state_alu_next;
    reg [N_BITS - 1 : 0] first_data;
    reg [N_BITS - 1 : 0] second_data;    
    reg [N_OPS - 1 : 0] operation;

    reg first_flag;
    reg second_flag;
    reg op_flag;

    reg tx_result;
    reg tx_start_aux;
    reg tx_start_next;
         
    always @(posedge clk) begin
        state_alu =  state_alu_next;
    end

    always @(posedge clk) begin
        if(first_flag)
            first_data = uart;
    end

    always @(posedge clk) begin
       if(second_flag)
          second_data = uart;
    end

    always @(posedge clk) begin
        if(op_flag) 
            operation = uart[N_OPS - 1 : 0];  
    end

    always @(posedge clk) begin
        tx_start_aux = tx_start_next;
    end

    always @(*) begin
        state_alu_next = state_alu;
        first_flag = 0;
        second_flag = 0;
        op_flag = 0;
        tx_start_next = 0;

        case (state_alu)
            FIRST_DATA: begin
                if(rx_done_tick) begin
                    state_alu_next = SECOND_DATA;
                    first_flag = 1;
                end
            end
            SECOND_DATA: begin
                if(rx_done_tick) begin
                    state_alu_next = OPERATION;
                    second_flag = 1;
                end
            end
            OPERATION: begin
                if(rx_done_tick) begin
                    state_alu_next = SEND;
                    op_flag = 1;
                end
            end
            SEND: begin
                state_alu_next = FIRST_DATA;
                tx_start_next = 1;
            end
            default: begin
                state_alu_next = FIRST_DATA;
            end
        endcase
    end
       
    assign Data_A = first_data;
    assign Data_B = second_data;
    assign Op = operation;
    assign tx_start = tx_start_aux;
    assign result = ALU;

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Rx
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


module Rx
  #(
    parameter N_DATA = 8,
    parameter N_STOP = 1,
    parameter BAUDRATE = 19200,
    parameter CLOCK = 100000000,
    parameter TICK_RATE = CLOCK / (BAUDRATE * 16),
    parameter N_TICK_COUNTER = $clog2(TICK_RATE),
    parameter N_DATA_COUNTER = $clog2(N_DATA)                  
    )
   (
    output wire [N_DATA - 1 : 0] dout,
    output reg rx_done_tick,
    input wire clk,
    input wire s_tick,
    input wire rx
    );
  
    localparam N_STATES = 4;
    localparam N_TICKS = 16;
    localparam N_STOP_TICKS = N_STOP * N_TICKS;
   
    localparam [N_STATES - 1 : 0] IDLE = 4'b0001;
    localparam [N_STATES - 1 : 0] START = 4'b0010;
    localparam [N_STATES - 1 : 0] DATA = 4'b0100;
    localparam [N_STATES - 1 : 0] STOP = 4'b1000;

    reg [N_STATES - 1 : 0] state;
    reg [N_STATES - 1 : 0] state_next;

    reg [N_TICK_COUNTER - 1 : 0] tick_counter;
    reg reset_tick_counter;
    
    reg [N_DATA - 1 : 0] data;
    reg [N_DATA - 1 : 0] data_next;
    reg [N_DATA_COUNTER - 1 : 0] data_bit_counter;
    reg reset_data_counter;
    reg data_counter_flag;
    
  
    always @(posedge clk) begin
        state <= state_next;
        data <= data_next;
    end
    
    always @ (posedge clk) begin
        if (reset_tick_counter)
            tick_counter <= 0;
        else if (s_tick)
            tick_counter <= tick_counter + 1;
    end

    always @ (posedge clk)
    begin
        if (reset_data_counter)
            data_bit_counter <= 0;
        else if(data_counter_flag)
            data_bit_counter <= data_bit_counter + 1;
    end

    always @(*) begin
        state_next = state;
        data_next = data;
        reset_tick_counter = 0;
        reset_data_counter = 0;
        data_counter_flag = 0;
        rx_done_tick = 0;

        case(state)
            IDLE: begin
                if(rx == 0) begin
                    state_next = START;
                    reset_tick_counter = 1;
                end
            end
            START: begin
                if(tick_counter == 7) begin
                    state_next = DATA;
                    reset_tick_counter = 1;
                    reset_data_counter = 1;
                end         
            end
            DATA: begin
                if(tick_counter == 15) begin
                    data_next = {rx, data[N_DATA - 1 : 1]};
                    reset_tick_counter = 1;
                    data_counter_flag = 1;              
                    if( data_bit_counter == N_DATA - 1 ) begin
                        state_next = STOP;
                        reset_data_counter = 1;
                    end
                end
            end
            STOP: begin
                if( tick_counter == N_STOP_TICKS - 1 ) begin
                    state_next = IDLE;
                    rx_done_tick = 1;
                end
            end
            default: begin
                state_next = IDLE;
                data_next = 0;
            end
        endcase
    end
    
    assign dout = data;
  
endmodule
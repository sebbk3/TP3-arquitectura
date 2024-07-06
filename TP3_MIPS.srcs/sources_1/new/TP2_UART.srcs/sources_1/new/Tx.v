`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Tx
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


module Tx
  #(
    parameter N_DATA = 8,
    parameter N_STOP = 1,
    parameter BAUDRATE = 19200,
    parameter CLOCK = 50000000,
    parameter TICK_RATE = CLOCK / (BAUDRATE * 16),
    parameter N_TICK_COUNTER = $clog2(TICK_RATE),
    parameter N_DATA_COUNTER = $clog2(N_DATA)                  
    )
   (
    output wire dout,
    output reg o_tx_done_tick,
    input wire clk,
    input wire s_tick,
    input wire [N_DATA - 1 : 0] tx,
    input wire start,
    input wire reset
    );
  
    localparam N_STATES = 3;
    localparam N_TICKS = 16;
    localparam N_STOP_TICKS = N_STOP * N_TICKS;
   
    localparam [N_STATES - 1 : 0] IDLE = 3'b001;
    localparam [N_STATES - 1 : 0] DATA = 3'b010;
    localparam [N_STATES - 1 : 0] STOP = 3'b100;

    reg [N_STATES - 1 : 0] state;
    reg [N_STATES - 1 : 0] state_next;

    reg [N_TICK_COUNTER - 1 : 0] tick_counter;
    reg reset_tick_counter;
    
    reg [N_DATA - 1 : 0] data;
    reg [N_DATA - 1 : 0] data_next;
    reg [N_DATA_COUNTER - 1 : 0] data_bit_counter;
    reg reset_data_counter;
    reg data_counter_flag;
    
    reg bit;
    reg bit_next;
    
  
    always @(posedge clk) begin
        if(reset)begin
            state           <= IDLE;
            tick_counter    <= 0;
            data            <= 0;
            bit             <= 1'b1;
        end
        else begin
            state <= state_next;
            data <= data_next;
            bit <= bit_next;
        end
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
        bit_next = bit;
        o_tx_done_tick = 0;

        case(state)
            IDLE: begin
                if(start) begin
                    state_next = DATA;
                    reset_tick_counter = 1;
                    data_next = tx;
                end
            end
            DATA: begin
                bit_next = data[0];
                if(tick_counter == 15) begin
                    data_next = data >> 1;   
                    reset_tick_counter = 1; 
                    if( data_bit_counter == N_DATA - 1 ) begin
                        state_next = STOP;
                        reset_data_counter = 1;
                    end
                    else
                        data_counter_flag = 1;
                end
            end
            STOP: begin
                data_next = 1;
                if( tick_counter == N_STOP_TICKS - 1 ) 
                    state_next = IDLE;
                    o_tx_done_tick = 1'b1;
            end
            default: begin
                state_next = IDLE;
                data_next = 0;
                reset_data_counter = 1;
            end
        endcase
    end
    
    assign dout = bit;
  
endmodule
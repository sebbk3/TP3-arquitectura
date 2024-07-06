`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: Rx_parity
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


module Rx_parity
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
    output wire [N_DATA - 1 : 0] dout,
    output reg rx_done_tick,
    input wire clk,
    input wire s_tick,
    input wire rx,
    input wire use_parity,
    input reset
    );
  
    localparam N_STATES = 5;
    localparam N_TICKS = 16;
    localparam N_STOP_TICKS = N_STOP * N_TICKS;
   
    localparam [N_STATES - 1 : 0] IDLE = 5'b00001;
    localparam [N_STATES - 1 : 0] START = 5'b00010;
    localparam [N_STATES - 1 : 0] DATA = 5'b00100;
    localparam [N_STATES - 1 : 0] STOP = 5'b01000;
    localparam [N_STATES - 1 : 0] PARITY = 5'b10000;  //Paridad par -- si viene un numero con cantidad impar de 1, debo recibir un 1, si tengo una cantidad par de 1, debo recibir un 0

    reg [N_STATES - 1 : 0] state;
    reg [N_STATES - 1 : 0] state_next;

    reg [N_TICK_COUNTER - 1 : 0] tick_counter;
    reg reset_tick_counter;
    
    reg [N_DATA - 1 : 0] data;
    reg [N_DATA - 1 : 0] data_next;
    reg [N_DATA_COUNTER - 1 : 0] data_bit_counter;
    reg reset_data_counter;
    reg data_counter_flag;
    
    reg parity_check;
    
  
    always @(posedge clk) begin
        if (reset) begin
            state           <= IDLE;
            tick_counter    <= 0;
            data            <= 0;
        end
        else begin
            state <= state_next;
            data <= data_next;
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
                    parity_check = 0;
                end         
            end
            DATA: begin
                if(tick_counter == 15) begin
                    data_next = {rx, data[N_DATA - 1 : 1]};
                    parity_check = ~(parity_check ^ rx);
                    reset_tick_counter = 1;
                   data_counter_flag = 1;
                    if( data_bit_counter == N_DATA - 1 ) begin
                        if( use_parity)
                            state_next = PARITY;
                        else
                            state_next = STOP;
                        reset_data_counter = 1;
                    end
                end
            end
            PARITY: begin
                if(tick_counter == 15) begin
                    if(parity_check != rx) begin 
                        state_next = STOP;
                        reset_tick_counter = 1;
                     end
                 end
                 if(tick_counter == 15 + N_STOP_TICKS - 1) begin
                     state_next = IDLE;
                     data_next = 0;
                     reset_tick_counter = 1;
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

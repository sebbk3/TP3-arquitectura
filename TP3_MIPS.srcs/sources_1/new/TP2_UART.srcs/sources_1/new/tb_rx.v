`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: tb_rx
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


module tb_rx
#(
    parameter periodo = 20,
    parameter tick_time = 163,
    parameter ticks = 16,
    parameter test_time = periodo * tick_time * ticks,
    parameter bits = 10,
    parameter N_DATA = 8
 );
 
    wire tick;
    wire [N_DATA - 1 : 0] dout;
    wire rx_done_tick;
    reg clk;
    reg data;
    reg use_parity;
    
    initial begin
        clk = 0;
        data = 1;
        use_parity = 0;
        
    
            data = 0;  //bit de start
        #(test_time/bits)
            data = 1;  //primer bit
        #(test_time/bits)
            data = 1;  //segundo bit
        #(test_time/bits)
            data = 1;  //tercer bit
        #(test_time/bits)
            data = 1;  //cuarto bit
        #(test_time/bits)
            data = 0;  //quinto bit
        #(test_time/bits)
            data = 0;  //sexto bit
        #(test_time/bits)
            data = 0;  //septimo bit
        #(test_time/bits)
            data = 0;  //octavo bit
        #(test_time/(bits+bits)) 
            data = 1;  //bit de stop
        //Esperado un 15
      
            
        #(test_time/bits)
        
        use_parity = 1; 
        
            data = 0;  //bit de start
        #(test_time/bits)
            data = 0;  //primer bit
        #(test_time/bits)
            data = 0;  //segundo bit
        #(test_time/bits)
            data = 1;  //tercer bit
        #(test_time/bits)
            data = 0;  //cuarto bit
        #(test_time/bits)
            data = 1;  //quinto bit
        #(test_time/bits)
            data = 0;  //sexto bit
        #(test_time/bits)
            data = 0;  //septimo bit
        #(test_time/bits)
            data = 0;  //octavo bit
        #(test_time/(bits+bits))
            data = 1; //bit de paridad
        #(test_time/(bits+bits))
            data = 1;  //bit de stop
        //Esperado un 20
        
        #(test_time/bits)
            data = 0;  //bit de start
        #(test_time/bits)
            data = 1;  //primer bit
        #(test_time/bits)
            data = 1;  //segundo bit
        #(test_time/bits)
            data = 1;  //tercer bit
        #(test_time/bits)
            data = 1;  //cuarto bit
        #(test_time/bits)
            data = 0;  //quinto bit
        #(test_time/bits)
            data = 0;  //sexto bit
        #(test_time/bits)
            data = 0;  //septimo bit
        #(test_time/bits)
            data = 0;  //octavo bit
        #(test_time/bits)
            data = 0; //bit de paridad
        #(test_time/(bits+bits)) 
            data = 1;  //bit de stop
        //Espero que no active el rx_done y se reinica
        
    end
    
    always #1 clk = ~clk;
    
    Baudrate_Gen instance_Baudrate_Gen(
    .clk (clk), 
    .tick (tick)
    );
    
    Rx_parity instance_Rx_parity(
    .dout (dout), 
    .rx_done_tick (rx_done_tick), 
    .clk (clk), 
    .s_tick (tick),
    .rx (data),
    .use_parity (use_parity)
    );
endmodule
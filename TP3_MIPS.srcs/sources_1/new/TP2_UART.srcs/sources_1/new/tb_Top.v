`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: tb_Top
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


module tb_Top
#(
    parameter periodo = 20,
    parameter tick_time = 163,
    parameter ticks = 16,
    parameter test_time = periodo * tick_time * ticks,
    parameter bits = 10,
    parameter N_DATA = 8
)
();

    wire solution;
    reg clk;
    reg data;
    reg use_parity;

    initial begin
        clk = 0;
        data = 1;
        use_parity = 0;
        //Vamos a sumar 15 y 20   
        //Paso un 15: 1111
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
        #(test_time/(bits+bits)) 
            data = 1;  //bit de stop
 
        #test_time
       //Paso un 20: 1 0100
        #(test_time/bits)
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
            data = 1;  //bit de stop
       
       #test_time
       //Paso operation suma: 100000 -- 35d = 10 0011b
        #(test_time/bits)
            data = 0;  //bit de start
        #(test_time/bits)
            data = 0;  //primer bit
        #(test_time/bits)
            data = 0;  //segundo bit
        #(test_time/bits)
            data = 0;  //tercer bit
        #(test_time/bits)
            data = 0;  //cuarto bit
        #(test_time/bits)
            data = 0;  //quinto bit
        #(test_time/bits)
            data = 1;  //sexto bit
        #(test_time/bits)
            data = 0;  //septimo bit
        #(test_time/bits)
            data = 0;  //octavo bit
        #(test_time/(bits+bits))
            data = 1;  //bit de stop
            
    end
    
    
  always #1 clk = ~clk;
    
  Top_UART instance_Top(
        .solution(solution), 
        .clk(clk), 
        .data(data), 
        .use_parity(use_parity)
  );
endmodule

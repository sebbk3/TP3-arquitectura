`timescale 1ns / 1ps

// Guarda el valor del PC+4, puede ser distinto del que recibe el instruction memory que pasa por multiplexores
module latch#(
        parameter NB = 32
    )
    (   
        input            i_clock,
        input   [NB-1:0] i_next_pc,
        
        output  [NB-1:0] o_next_pc
    );
    
    reg [NB-1:0] next_pc;

    always@(posedge i_clock)begin
        next_pc <= i_next_pc;
    end

    assign o_next_pc = next_pc;
    
endmodule
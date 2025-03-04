`timescale 1ns / 1ps

//Este modulo hace un shift a la izquierda en 2, para los branches
module shifter#(
        parameter NB = 32
    )
    (
        input   [NB-1:0] i_data,
        
        output  [NB-1:0] o_result
    );
    
    assign o_result = i_data << 2;
    
endmodule
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: instruction_memory
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

/*
* Un requerimiento de este módulo es que las instrucciones estén alineadas de a 4 bytes y comiencen
* en algun address multiplo de 4 (no se pueden poner address que no sean multiplos de 4)
*/
module instruction_memory #(
    parameter WIDTH = 32,
    parameter MAX_NUM_OF_INSTRUCTIONS = 32,
    parameter MAX_NUM_OF_INSTRUCTIONS_BINARY = 6
)(
    input i_clock,
    input i_enable,                                                 // Debug Unit Control                            
    input i_read_enable,  
    input i_write_enable,                                           // Debug Unit Control, cargar instrucciones desde UART
    input [WIDTH-1:0] i_write_data,                                 // Debug Unit Control, la instruccion que viene de la UART
    input [MAX_NUM_OF_INSTRUCTIONS_BINARY-1:0] i_write_addr,        // Debug Unit Control, [0-32] Que numero de instruccion es
    input [WIDTH-1:0] i_instruction_address,  // Seria "el PC" de la instruccion
    output reg [WIDTH-1:0] o_instruction
);

    reg [WIDTH-1:0] memory [0:MAX_NUM_OF_INSTRUCTIONS];
    
     generate
        integer index;
        initial
          for (index = 0; index < MAX_NUM_OF_INSTRUCTIONS; index = index + 1)
            memory[index] = {WIDTH{1'b0}};
      endgenerate
    
    initial begin
        o_instruction = 0;
    end;
    
    always @(posedge i_clock) begin
    if(i_enable) begin
		if (i_read_enable) begin
		  // Esto hace memory [i_instruccion_address % 4] para buscar en la memoria de a multiplos de 4
			o_instruction <= memory[i_instruction_address >> 2];
		end
		else begin
			o_instruction <= {WIDTH{1'b0}};
		end
		
		if(i_write_enable) begin
		     // Viene la instruccion del debug unit
		    memory[i_write_addr] <= i_write_data;
		end
    end
  end

endmodule

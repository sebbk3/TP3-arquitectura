`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: concat_jump_addr
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


module concat_jump_addr#(
        parameter WIDTH_ADDR = 26,    //  Direccion de salto en la instruccion (J)      
		parameter WIDTH_PC = 32,            
		parameter WIDTH_UPPER_PC = 4,     // Bits mas significativos de PC+1
		parameter WIDTH_LOWER_BITS = 2
    )(
        input i_clock,
		input i_reset,
		input i_enable,
		input [WIDTH_ADDR-1:0] i_instruction,                           
		input [WIDTH_UPPER_PC-1:0] i_next_pc,   // PC+1[31:28]                
		output [WIDTH_PC-1:0] o_jump_address  
       );
       
    reg [WIDTH_PC-1:0]  jump_address;

    always@(posedge i_clock) begin
		if(i_reset) begin
			jump_address <= 0;
		end  
		else if(i_enable) begin
			jump_address[WIDTH_LOWER_BITS-1:0] <= 2'b00; 		                 // [1:0]
			jump_address[WIDTH_ADDR+1:WIDTH_LOWER_BITS] <= i_instruction; 		// [27:2]
			jump_address[WIDTH_PC-1:WIDTH_ADDR+2] <= i_next_pc; 	            // [31:28]
		end
		else begin
			jump_address <= jump_address;
		end  
    end

	assign o_jump_address = jump_address;
       
endmodule
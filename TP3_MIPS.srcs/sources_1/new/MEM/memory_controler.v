`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: memory_controler
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

`define BYTE_WORD 3'b001
`define HALF_WORD 3'b010
`define COMPLETE_WORD 3'b100
 

module memory_controller#(
    parameter DATA_WIDTH = 32,
    parameter TYPE_WIDTH = 3
) 
(   
    input i_signed,
    input i_write,
    input i_read,
    input [TYPE_WIDTH-1:0] i_word_size,
    input [DATA_WIDTH-1:0] i_write_data,
    input [DATA_WIDTH-1:0] i_read_data,
    output reg [DATA_WIDTH-1:0] o_write_data,
    output reg [DATA_WIDTH-1:0] o_read_data
);

    //reg [DATA_WIDTH-1:0]   write_data;

	always@(*) begin
        // Lectura
        // El especio de memoria es de 32 bits, si me llega algo de menor tamanio, tengo que alargarlo
        if(i_read)begin 
            // Signo?
            if(i_signed)begin  
            // Con signo me tengo que hacer que el bit mas significativo se mantenga siendolo          
                case(i_word_size)
                    `BYTE_WORD:
                        o_read_data = {{24{i_read_data[7]}}, i_read_data[7:0]};
                    `HALF_WORD:
                        o_read_data = {{16{i_read_data[15]}}, i_read_data[15:0]};
                    `COMPLETE_WORD:
                        o_read_data = i_read_data;
                    default:
                        o_read_data = 32'b0;
                endcase
            end
            else begin
                case(i_word_size)
                    `BYTE_WORD:
                        o_read_data = {{24'b0}, i_read_data[7:0]};
                    `HALF_WORD:
                        o_read_data = {{16'b0}, i_read_data[15:0]};
                    `COMPLETE_WORD:
                        o_read_data = i_read_data;
                    default:
                        o_read_data = 32'b0;
                endcase
            end
        end
        else
            o_read_data = 32'b0;
        
        // Escritura
        if(i_write)begin
            case(i_word_size)
                `BYTE_WORD:
                    o_write_data = i_write_data[7:0];
                `HALF_WORD:
                    o_write_data = i_write_data[15:0];
                `COMPLETE_WORD:
                    o_write_data = i_write_data;
                default:
                    o_write_data = 32'b0;
            endcase
        end
        else
            o_write_data = 32'b0;
	end

endmodule
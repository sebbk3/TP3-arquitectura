`timescale 1ns / 1ps

module instru_mem#(
  parameter MEMORY_WIDTH    = 8,                 // Ancho, 1 byte
  parameter MEMORY_DEPTH    = 256,               // Largo, 256 ubicaciones de 1byte, hacen a 32 palabras de 32 bits
  parameter NB_ADDR_DEPTH   = 8,
  parameter NB_ADDR         = 32,
  parameter NB_INSTRUCTION  = 32
  ) 
(
  input                       i_clock,
  input                       i_enable,         // Debug Unit Control                            
  input                       i_read_enable,  
  input                       i_write_enable,   // Debug Unit Control, cargar instrucciones desde UART   
  input  [MEMORY_WIDTH-1:0]   i_write_data,     // Debug Unit Control, la instruccion que viene de la UART
  input  [NB_ADDR_DEPTH-1:0]  i_write_addr,     // Debug Unit Control, [0-7] Que numero de instruccion es
  input  [NB_ADDR-1:0]        i_read_addr,      // Seria "el PC" de la instruccion
  output [NB_INSTRUCTION-1:0] o_read_data       // Instruccion leida
);

  reg [MEMORY_WIDTH-1:0] BRAM [MEMORY_DEPTH-1:0];
  reg [NB_INSTRUCTION-1:0] ram_data = {NB_INSTRUCTION{1'b0}};

  generate
    integer ram_index;
    initial
      for (ram_index = 0; ram_index < MEMORY_DEPTH; ram_index = ram_index + 1)
        BRAM[ram_index] = {MEMORY_WIDTH{1'b0}};
  endgenerate

  always @(posedge i_clock) begin
    if(i_enable) begin
		if (i_read_enable) begin
			ram_data[31:24] <= BRAM[i_read_addr];
			ram_data[23:16] <= BRAM[i_read_addr+1];
			ram_data[15:8]  <= BRAM[i_read_addr+2];
			ram_data[7:0]   <= BRAM[i_read_addr+3];
		end
		else begin
			ram_data <= {NB_INSTRUCTION{1'b0}};
		end
		
		if(i_write_enable) begin
			// Viene la instruccion del debug unit
			BRAM[i_write_addr]   <= i_write_data;
		end
    end
  end

  assign o_read_data = ram_data;

endmodule						
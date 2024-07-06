`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: register_bank
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

module register_bank#(
    parameter REG_CELL_SIZE = 32,
    parameter MAX_REGISTERS = 32,
    parameter ADDRESS_BYTES = 5 // Address size determinado x la cant de direcciones que podemos tener
    )(
        input i_clock,
        input i_reset,
        input i_reg_write,    // Señal de control reg_write proveniente del WB
        input [ADDRESS_BYTES-1:0] i_read_reg_a,
        input [ADDRESS_BYTES-1:0] i_read_reg_b,
        input [ADDRESS_BYTES-1:0] i_write_reg_addr,    // direccion del registro al que escribir 
        input [REG_CELL_SIZE-1:0] i_write_reg_data,   // data que se va a escribir en el registro

        input i_enable,       // Debug Unit
        input i_read_enable,  // Debug Unit
        input [ADDRESS_BYTES-1:0] i_read_addr,    // Debug Unit
              
        output reg [REG_CELL_SIZE-1:0] o_data_reg_a,
        output reg [REG_CELL_SIZE-1:0] o_data_reg_b 
    );
    
    reg [REG_CELL_SIZE-1:0] registers [MAX_REGISTERS-1:0];

    generate
        integer reg_index;
        initial
            for (reg_index = 0; reg_index < MAX_REGISTERS; reg_index = reg_index + 1)
                registers[reg_index] = reg_index; 
    endgenerate
    
    always@(posedge i_clock)begin
        if(i_reset)begin
            o_data_reg_a  <=  {REG_CELL_SIZE{1'b0}};
            o_data_reg_b  <=  {REG_CELL_SIZE{1'b0}};
        end 
        else begin
            if(i_enable) begin // Funcionamiento normal
                
                // Escritura de regs por WB
                if (i_reg_write) begin
                    registers[i_write_reg_addr] = i_write_reg_data;
                end

                // Lectura para evitar raw hazards en el 3er ciclo de clock
                if(i_read_reg_a == i_write_reg_addr && i_reg_write) begin
                    o_data_reg_a <= i_write_reg_data;
                    o_data_reg_b <= registers[i_read_reg_b];
                end
                else if (i_read_reg_b == i_write_reg_addr && i_reg_write) begin
                    o_data_reg_a <= registers[i_read_reg_a];
                    o_data_reg_b <= i_write_reg_data;
                end
                else begin
                    // Lectura normal
                    o_data_reg_a <= registers[i_read_reg_a];
                    o_data_reg_b <= registers[i_read_reg_b];
                end
            end
            else if(i_read_enable) begin     // Lectura del RA desde la Debug Unit
                o_data_reg_a = registers[i_read_addr];
            end
        end
    end
endmodule
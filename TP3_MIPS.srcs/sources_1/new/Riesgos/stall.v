`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: stall
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


module stall #(
        parameter WIDTH_DATA = 32,
        parameter WIDTH_REG = 5
    )    
    (   
        input i_reset,
        input i_MEM_halt,                               // STOP WRITE MEM 
        input i_WB_halt,                                // STOP WRITE REG
        input i_branch_taken,                           // CUANDO SE TOMA UN BRANCH
        input i_ID_EX_mem_read,                         // PARA SOLO CON LOADS
        input i_EX_jump,                                // Salto de Execute
        input i_MEM_jump,                               // Salto en Memory
        input [WIDTH_REG-1 : 0] i_ID_EX_rt,             // Valor de rt entre DECODE y EXECUTE
        input [WIDTH_REG-1 : 0] i_IF_ID_rt,             // Valor de rt entre FETCH y DECODE
        input [WIDTH_REG-1 : 0] i_IF_ID_rs,             // Valor de rs entre FETCH y DECODE
        output reg o_flush_ID,                          // 0 -> control_signals DECODE  1 -> flush signals
        output reg o_enable_IF_ID_reg,                  // 0 -> disable             1 -> enable
        output reg o_enable_pc,                         // 0 -> disable             1 -> enable
        output reg o_flush_IF,                          // 0 -> o_instruction       1 -> flush 
        output reg o_flush_EX                           // 0 -> control signals EX  1 -> flush 
    ); 

    always@(*) begin
        if(i_reset)begin
            o_enable_IF_ID_reg = 1'b1;
            o_enable_pc = 1'b1;
            o_flush_ID = 1'b0;
            o_flush_IF = 1'b0;           
            o_flush_EX = 1'b0;           
        end
        else if(i_branch_taken) begin   // Riesgos con branches
            // Flush all
            o_flush_IF = 1'b1;
            o_flush_EX = 1'b1;
            o_flush_ID = 1'b1; // DECODE
            o_enable_IF_ID_reg = 1'b1;
            o_enable_pc = 1'b1;
        end
        else if(i_EX_jump || i_MEM_jump) begin // Riesgos con jumps
            // Al tomar el salto se borra las dos instrucciones que entran despues del salto porque son instrucciones invalidas
            // No hay stall
            o_flush_IF = 1'b0;
            o_flush_EX = 1'b0;
            o_flush_ID = 1'b1;
            o_enable_IF_ID_reg = 1'b1;
            o_enable_pc = 1'b1;
        end
        else if(i_MEM_halt || i_WB_halt) begin // halt
            // Flush all
            // Cuando el HALT llega a las ultimas dos etapas se vacian las etapas anteriores
            o_flush_IF = 1'b1;
            o_flush_EX = 1'b1;
            o_flush_ID = 1'b1; 
            o_enable_IF_ID_reg = 1'b1;
            o_enable_pc = 1'b1;
        end

        else begin // Riesgos de datos (LOAD)
            if(((i_ID_EX_rt == i_IF_ID_rt) || (i_ID_EX_rt == i_IF_ID_rs)) && i_ID_EX_mem_read) begin
                o_flush_IF = 1'b0;              // No hay flush en FETCH
                o_flush_EX = 1'b0;              // No hay flush en EXECUTE
                o_flush_ID = 1'b1;              // Flush signals in DECODE
                o_enable_IF_ID_reg = 1'b0;      // disable FETCH/DECODE reg
                o_enable_pc = 1'b0;             // disable PC
            end
            else  begin
                o_flush_IF = 1'b0;              // No hay flush en FETCH
                o_flush_EX = 1'b0;              // No hay flush en EXECUTE
                o_flush_ID = 1'b0;
                o_enable_IF_ID_reg = 1'b1;
                o_enable_pc = 1'b1;
            end
        end
    end
endmodule
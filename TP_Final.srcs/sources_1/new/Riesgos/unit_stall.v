`timescale 1ns / 1ps

module unit_stall #(
        parameter NB_DATA    = 32,
        parameter NB_REG     = 5
    )    
    (   
        input                 i_reset,
        input                 i_MEM_halt,           // Para la escritura en memoria 
        input                 i_WB_halt,            // Para la escritura de registros
        input                 i_branch_taken,       // CUANDO SE TOMA UN BRANCH
        input                 i_ID_EX_mem_read,     // PARA SOLO CON LOADS
        input                 i_EX_jump,            // Salto de EX
        input                 i_MEM_jump,           // Salto en MEM
        input  [NB_REG-1 : 0] i_ID_EX_rt,           // Valor de rt entre ID y EX
        input  [NB_REG-1 : 0] i_IF_ID_rt,           // Valor de rt entre IF y ID
        input  [NB_REG-1 : 0] i_IF_ID_rs,           // Valor de rs entre IF y ID
        output reg            o_flush_ID,           // 0 -> control_signals ID  1 -> flush signals
        output reg            o_enable_IF_ID_reg,   // 0 -> disable             1 -> enable
        output reg            o_enable_pc,          // 0 -> disable             1 -> enable
        output reg            o_flush_IF,           // 0 -> o_instruction       1 -> flush 
        output reg            o_flush_EX            // 0 -> control signals EX  1 -> flush 
    ); 

    always@(*) begin
        if(i_reset)begin
            o_enable_IF_ID_reg      = 1'b1;
            o_enable_pc             = 1'b1;
            o_flush_ID              = 1'b0;
            o_flush_IF              = 1'b0;           
            o_flush_EX              = 1'b0;           
        end
        else if(i_branch_taken) begin               // Riesgos con branches
            // Flush all
            o_flush_IF              = 1'b1;
            o_flush_EX              = 1'b1;
            o_flush_ID              = 1'b1;         // ID
            o_enable_IF_ID_reg      = 1'b1;
            o_enable_pc             = 1'b1;
        end
        else if(i_EX_jump || i_MEM_jump) begin // Hazards con jumps
            // Al tomar el salto se borra las dos instrucciones que entran despues del salto porque son instrucciones invalidas
            // No hay stall
            o_flush_IF              = 1'b0;
            o_flush_EX              = 1'b0;
            o_flush_ID              = 1'b1;
            o_enable_IF_ID_reg      = 1'b1;
            o_enable_pc             = 1'b1;
        end
        else if(i_MEM_halt || i_WB_halt) begin // halt
            // Flush all
            // Cuando el HALT llega a las ultimas dos etapas se vacian las etapas anteriores
            o_flush_IF              = 1'b1;
            o_flush_EX              = 1'b1;
            o_flush_ID              = 1'b1; 
            o_enable_IF_ID_reg      = 1'b1;
            o_enable_pc             = 1'b1;
        end

        else begin // data hazards (LOAD)
            if(((i_ID_EX_rt == i_IF_ID_rt) || (i_ID_EX_rt == i_IF_ID_rs)) && i_ID_EX_mem_read) begin
                o_flush_IF              = 1'b0;     // No hay flush en IF
                o_flush_EX              = 1'b0;     // No hay flush en EX
                o_flush_ID              = 1'b1;     // Flush signals in ID
                o_enable_IF_ID_reg      = 1'b0;     // Deshabilita IF/ID_reg
                o_enable_pc             = 1'b0;     // Deshabilita el PC
            end
            else  begin
                o_flush_IF              = 1'b0;     // No hay flush en IF
                o_flush_EX              = 1'b0;     // No hay flush en EX
                o_flush_ID              = 1'b0;
                o_enable_IF_ID_reg      = 1'b1;
                o_enable_pc             = 1'b1;
            end
        end
    end
endmodule
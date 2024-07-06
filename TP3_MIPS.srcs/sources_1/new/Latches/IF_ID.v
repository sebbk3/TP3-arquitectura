`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: IF_ID
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


module IF_ID#(
        parameter WIDTH_PC = 32,
        parameter WIDTH_INSTRUCTION = 32
    )
    (
        input i_clock,
        input i_reset,
        input i_pipeline_enable,                    // DEBUG UNIT
        input i_enable,                             // STALL UNIT: 1 -> data hazard (stall) 0 -> !data_hazard
        input i_flush,                              // STALL UNIT: 1 -> control hazards     0 -> !control_hazard
        input [WIDTH_PC-1:0] i_adder_result,
        input [WIDTH_INSTRUCTION-1:0] i_instruction,
        
        output reg [WIDTH_PC-1:0] o_adder_result,
        output reg [WIDTH_INSTRUCTION-1:0] o_instruction
    );
    

    always @(negedge i_clock) begin
        if(i_reset)begin                                        // Si hay reset, todo a 0
            o_adder_result <= {32{1'b0}};
            o_instruction <= {32{1'b0}};
        end
        else begin
            if(i_pipeline_enable) begin
                if(i_enable) begin
                    if(i_flush) begin                           // No hay Reset, esta habilitada la pipeline, el IF, pero hay flush
                        o_adder_result <= i_adder_result;       // Por lo tanto, pasa el resultado del adder, pero no el de la instruccion
                        o_instruction <= {32{1'b0}};
                    end
                    else begin                                  // No hay Reset, esta habilitada la pipeline, el IF, no hay flush, es decir, todo normal
                        o_adder_result <= i_adder_result;
                        o_instruction <= i_instruction;
                    end
                end
                else begin                                      // No esta habilitado el IF, es un stall
                    o_adder_result <= o_adder_result;
                    o_instruction <= o_instruction;
                end
            end
            else begin                                          // No esta habilitado el pipeline, Debug Unit
                o_adder_result <= o_adder_result;
                o_instruction <= o_instruction;
            end
        end    
    end

    
endmodule

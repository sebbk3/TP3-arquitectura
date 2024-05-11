`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2024 17:35:11
// Design Name: 
// Module Name: test_ALU
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


module test_ALU;
      
    // Parameters
    parameter BUS_SIZE        = 32;
    
    // Inputs
    reg [BUS_SIZE-1     : 0] i_A;
    reg [BUS_SIZE-1     : 0] i_B;
    reg [3              : 0] i_alu_ctrl;
    
    // Outputs
    wire [BUS_SIZE-1 : 0] o_salida;
    wire o_zero;

    // Unit under test
    ALU #(
    .BUS_SIZE(BUS_SIZE)
    ) uut(
        .i_A(i_A),
        .i_B(i_B),
        .i_alu_ctrl(i_alu_ctrl),
        .o_salida(o_salida),
        .o_zero(o_zero)
    );
    
    
    initial begin
        i_A = 32'b0;
        i_B = 32'b0;
        i_alu_ctrl = 4'b0;
    end

    initial begin
        
        i_A = 32'b100;
        i_B = 32'b010;
        i_alu_ctrl = 4'b0000;
        #1;
        if ( o_salida != (i_A & i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A & i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b0001;
        #10;
        if ( o_salida != (i_A | i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A | i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b0011;
        #10;
        if ( o_salida != (i_A ^ i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A ^ i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b0010;
        #10;
        if ( o_salida != (i_A + i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A + i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b0110;
        #10;
        if ( o_salida != (i_A - i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A - i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b1100;
        #10;
        if ( o_salida != ~(i_A | i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", ~(i_A | i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b1101;
        #10;
        if ( o_salida != (i_A << i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A << i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b1110;
        #10;
        if ( o_salida != ($signed(i_A)>>>i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", ($signed(i_A)>>>i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b1111;
        #10;
        if ( o_salida != (i_A >>> i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A >>> i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b0100;
        #10;
        if ( o_salida != (i_A < i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A < i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b0111;
        #10;
        if ( o_salida != (i_A != i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A != i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b1000;
        #10;
        if ( o_salida != (i_A == i_B) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A == i_B), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b1001;
        #10;
        if ( o_salida != (i_A << 16) ) begin
            $display("Valor esperado: %b - valor obtenido: %b", (i_A << 16), o_salida);
            $finish;
        end
        
        #10;
        
        i_alu_ctrl = 4'b1010;
        #10;
        if ( o_salida != 4'b0 ) begin
            $display("Valor esperado: 0 - valor obtenido: %b", o_salida);
            $finish;
        end
        
        $display("Tests ok");
        $finish;
    end


endmodule

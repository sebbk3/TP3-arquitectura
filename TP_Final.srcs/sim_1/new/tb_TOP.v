`timescale 1ns / 1ps

module tb_TOP;

  // Parameters
  localparam  BYTE = 8;
  localparam  DWORD = 32;
  localparam  ADDR = 5;
  localparam  NB_MEM_DEPTH = 8;
  localparam  RB_ADDR = 5;
  localparam  NB_STATE = 10;
  localparam  NB_DATA = 8;
  localparam  NB_OP = 6;


  // Ports
  reg             i_clock       = 0;
  reg             i_reset       = 0;
  reg             i_clock_reset = 0;
  reg             i_uart_debug_unit_rx  = 0;
  reg [BYTE-1:0]  command       = 8'd0;
  reg             send          = 1'b0;

  wire uart_debug_unit_tx;
  wire uart_debug_unit_rx;
  wire clk_wzrd;  // Borrar

  wire o_halt;
  wire [NB_STATE-1:0] o_state;
  
  // UART externa
  reg i_rx;
  wire [BYTE-1:0] o_rx;
  wire o_rx_done_tick;
  wire o_tx_done_tick;
  
  integer i;
  integer inst_counter = 0;
  reg [NB_DATA-1:0] memory [255:0]; 

  TOP TOP (.i_clock (i_clock),
            .i_reset (i_reset),
            .i_clock_reset (i_clock_reset),
            .i_uart_debug_unit_rx (uart_debug_unit_rx),
            .o_uart_debug_unit_tx (uart_debug_unit_tx),
            .o_halt (o_halt),
            .o_state (o_state),
            .o_locked(clk_wzrd)
        );

  UART #(.NB_DATA(NB_DATA),
         .NB_OP(NB_OP))
  UART(.i_clock(clk_wzrd), // Cambiar
           .i_reset(i_reset),
           .i_rx(uart_debug_unit_tx),
           .i_tx_data(command),
           .i_tx_start(send),
           .o_rx_data(o_rx),
           .o_rx_done_tick(o_rx_done_tick),
           .o_tx(uart_debug_unit_rx),
           .o_tx_done_tick(o_tx_done_tick));       

  initial begin
    i_clock       = 1'b0;
    i_reset       = 1'b1;
    i_clock_reset = 1'b1;
    command       = 8'd0;
    send          = 1'b0;

    #100
    i_clock_reset = 1'b0;

    #600
    i_reset = 1'b0;

    $monitor("[$monitor] time=%0t o_state=%b ", $time, o_state);
    $monitor("[$monitor] time=%0t o_rx   =%h ", $time, o_rx);
    $monitor("[$monitor] time=%0t o_rx_done_tick   =%h ", $time, o_rx_done_tick);

    // write instruction memory
    #400
    $display("Write IM.");
    command = 8'd1; // WRITE_IM
    send    = 1'b1;

    #20
    send    = 1'b0;

    //$readmemb("/instructions.mem", memory, 0, 255);
    // Se envia instruccion por instruccion, byte por byte
    memory[0]  = 8'b00100000;
    memory[1]  = 8'b00000001;
    memory[2]  = 8'b00000000;
    memory[3]  = 8'b00000001;
    memory[4]  = 8'b00100000;
    memory[5]  = 8'b00000010;
    memory[6]  = 8'b00000000;
    memory[7]  = 8'b00000010;
    memory[8]  = 8'b00100000;
    memory[9]  = 8'b00000011;
    memory[10] = 8'b00000000;
    memory[11] = 8'b00000011;
    memory[12] = 8'b00100000;
    memory[13] = 8'b00000100;
    memory[14] = 8'b00000000;
    memory[15] = 8'b00000100;
    memory[16] = 8'b00100000;
    memory[17] = 8'b00001010;
    memory[18] = 8'b00000000;
    memory[19] = 8'b00001000;
    memory[20] = 8'b10101100;
    memory[21] = 8'b00000001;
    memory[22] = 8'b00000000;
    memory[23] = 8'b00000001;
    memory[24] = 8'b10101100;
    memory[25] = 8'b00000010;
    memory[26] = 8'b00000000;
    memory[27] = 8'b00000010;
    memory[28] = 8'b10101100;
    memory[29] = 8'b00000011;
    memory[30] = 8'b00000000;
    memory[31] = 8'b00000011;
    memory[32] = 8'b10101100;
    memory[33] = 8'b00000100;
    memory[34] = 8'b00000000;
    memory[35] = 8'b00000100;
    memory[36] = 8'b10001100;
    memory[37] = 8'b10000101;
    memory[38] = 8'b00000000;
    memory[39] = 8'b00000000;
    memory[40] = 8'b00000000;
    memory[41] = 8'b10100100;
    memory[42] = 8'b00110000;
    memory[43] = 8'b00100001;
    memory[44] = 8'b00010000;
    memory[45] = 8'b11001010;
    memory[46] = 8'b00000000;
    memory[47] = 8'b00000001;
    memory[48] = 8'b10101100;
    memory[49] = 8'b00001010;
    memory[50] = 8'b00000000;
    memory[51] = 8'b00000101;
    memory[52] = 8'b10101100;
    memory[53] = 8'b00000100;
    memory[54] = 8'b00000000;
    memory[55] = 8'b00000110;
    memory[56] = 8'b11111100;
    memory[57] = 8'b00000000;
    memory[58] = 8'b00000000;
    memory[59] = 8'b00000000;
    memory[60] = 8'b00000000;
    memory[61] = 8'b00000000;
    memory[62] = 8'b00000000;
    memory[63] = 8'b00000000;
    memory[64] = 8'b00000000;
    memory[65] = 8'b00000000;
    memory[66] = 8'b00000000;
    memory[67] = 8'b00000000;
    memory[68] = 8'b00000000;
    memory[69] = 8'b00000000;
    memory[70] = 8'b00000000;
    memory[71] = 8'b00000000;
    memory[72] = 8'b00000000;
    memory[73] = 8'b00000000;
    memory[74] = 8'b00000000;
    memory[75] = 8'b00000000;
    memory[76] = 8'b00000000;
    memory[77] = 8'b00000000;
    memory[78] = 8'b00000000;
    memory[79] = 8'b00000000;
    memory[80] = 8'b00000000;
    memory[81] = 8'b00000000;
    memory[82] = 8'b00000000;
    memory[83] = 8'b00000000;
    memory[84] = 8'b00000000;
    memory[85] = 8'b00000000;
    memory[86] = 8'b00000000;
    memory[87] = 8'b00000000;
    memory[88] = 8'b00000000;
    memory[89] = 8'b00000000;
    memory[90] = 8'b00000000;
    memory[91] = 8'b00000000;
    memory[92] = 8'b00000000;
    memory[93] = 8'b00000000;
    memory[94] = 8'b00000000;
    memory[95] = 8'b00000000;
    memory[96] = 8'b00000000;
    memory[97] = 8'b00000000;
    memory[98] = 8'b00000000;
    memory[99] = 8'b00000000;
    memory[100] = 8'b00000000;
    memory[101] = 8'b00000000;
    memory[102] = 8'b00000000;
    memory[103] = 8'b00000000;
    memory[104] = 8'b00000000;
    memory[105] = 8'b00000000;
    memory[106] = 8'b00000000;
    memory[107] = 8'b00000000;
    memory[108] = 8'b00000000;
    memory[109] = 8'b00000000;
    memory[110] = 8'b00000000;
    memory[111] = 8'b00000000;
    memory[112] = 8'b00000000;
    memory[113] = 8'b00000000;
    memory[114] = 8'b00000000;
    memory[115] = 8'b00000000;
    memory[116] = 8'b00000000;
    memory[117] = 8'b00000000;
    memory[118] = 8'b00000000;
    memory[119] = 8'b00000000;
    memory[120] = 8'b00000000;
    memory[121] = 8'b00000000;
    memory[122] = 8'b00000000;
    memory[123] = 8'b00000000;
    memory[124] = 8'b00000000;
    memory[125] = 8'b00000000;
    memory[126] = 8'b00000000;
    memory[127] = 8'b00000000;
    memory[128] = 8'b00000000;
    memory[129] = 8'b00000000;
    memory[130] = 8'b00000000;
    memory[131] = 8'b00000000;
    memory[132] = 8'b00000000;
    memory[133] = 8'b00000000;
    memory[134] = 8'b00000000;
    memory[135] = 8'b00000000;
    memory[136] = 8'b00000000;
    memory[137] = 8'b00000000;
    memory[138] = 8'b00000000;
    memory[139] = 8'b00000000;
    memory[140] = 8'b00000000;
    memory[141] = 8'b00000000;
    memory[142] = 8'b00000000;
    memory[143] = 8'b00000000;
    memory[144] = 8'b00000000;
    memory[145] = 8'b00000000;
    memory[146] = 8'b00000000;
    memory[147] = 8'b00000000;
    memory[148] = 8'b00000000;
    memory[149] = 8'b00000000;
    memory[150] = 8'b00000000;
    memory[151] = 8'b00000000;
    memory[152] = 8'b00000000;
    memory[153] = 8'b00000000;
    memory[154] = 8'b00000000;
    memory[155] = 8'b00000000;
    memory[156] = 8'b00000000;
    memory[157] = 8'b00000000;
    memory[158] = 8'b00000000;
    memory[159] = 8'b00000000;
    memory[160] = 8'b00000000;
    memory[161] = 8'b00000000;
    memory[162] = 8'b00000000;
    memory[163] = 8'b00000000;
    memory[164] = 8'b00000000;
    memory[165] = 8'b00000000;
    memory[166] = 8'b00000000;
    memory[167] = 8'b00000000;
    memory[168] = 8'b00000000;
    memory[169] = 8'b00000000;
    memory[170] = 8'b00000000;
    memory[171] = 8'b00000000;
    memory[172] = 8'b00000000;
    memory[173] = 8'b00000000;
    memory[174] = 8'b00000000;
    memory[175] = 8'b00000000;
    memory[176] = 8'b00000000;
    memory[177] = 8'b00000000;
    memory[178] = 8'b00000000;
    memory[179] = 8'b00000000;
    memory[180] = 8'b00000000;
    memory[181] = 8'b00000000;
    memory[182] = 8'b00000000;
    memory[183] = 8'b00000000;
    memory[184] = 8'b00000000;
    memory[185] = 8'b00000000;
    memory[186] = 8'b00000000;
    memory[187] = 8'b00000000;
    memory[188] = 8'b00000000;
    memory[189] = 8'b00000000;
    memory[190] = 8'b00000000;
    memory[191] = 8'b00000000;
    memory[192] = 8'b00000000;
    memory[193] = 8'b00000000;
    memory[194] = 8'b00000000;
    memory[195] = 8'b00000000;
    memory[196] = 8'b00000000;
    memory[197] = 8'b00000000;
    memory[198] = 8'b00000000;
    memory[199] = 8'b00000000;
    memory[200] = 8'b00000000;
    memory[201] = 8'b00000000;
    memory[202] = 8'b00000000;
    memory[203] = 8'b00000000;
    memory[204] = 8'b00000000;
    memory[205] = 8'b00000000;
    memory[206] = 8'b00000000;
    memory[207] = 8'b00000000;
    memory[208] = 8'b00000000;
    memory[209] = 8'b00000000;
    memory[210] = 8'b00000000;
    memory[211] = 8'b00000000;
    memory[212] = 8'b00000000;
    memory[213] = 8'b00000000;
    memory[214] = 8'b00000000;
    memory[215] = 8'b00000000;
    memory[216] = 8'b00000000;
    memory[217] = 8'b00000000;
    memory[218] = 8'b00000000;
    memory[219] = 8'b00000000;
    memory[220] = 8'b00000000;
    memory[221] = 8'b00000000;
    memory[222] = 8'b00000000;
    memory[223] = 8'b00000000;
    memory[224] = 8'b00000000;
    memory[225] = 8'b00000000;
    memory[226] = 8'b00000000;
    memory[227] = 8'b00000000;
    memory[228] = 8'b00000000;
    memory[229] = 8'b00000000;
    memory[230] = 8'b00000000;
    memory[231] = 8'b00000000;
    memory[232] = 8'b00000000;
    memory[233] = 8'b00000000;
    memory[234] = 8'b00000000;
    memory[235] = 8'b00000000;
    memory[236] = 8'b00000000;
    memory[237] = 8'b00000000;
    memory[238] = 8'b00000000;
    memory[239] = 8'b00000000;
    memory[240] = 8'b00000000;
    memory[241] = 8'b00000000;
    memory[242] = 8'b00000000;
    memory[243] = 8'b00000000;
    memory[244] = 8'b00000000;
    memory[245] = 8'b00000000;
    memory[246] = 8'b00000000;
    memory[247] = 8'b00000000;
    memory[248] = 8'b00000000;
    memory[249] = 8'b00000000;
    memory[250] = 8'b00000000;
    memory[251] = 8'b00000000;
    memory[252] = 8'b00000000;
    memory[253] = 8'b00000000;
    memory[254] = 8'b00000000;
    memory[255] = 8'b00000000;
    
    for (i=0; i<40; i=i+1) begin
        #550000
        $display("instructions : ",inst_counter);
        inst_counter = inst_counter+1;
    	$display("valor: ", memory[i]);
		#20
		command	= memory[i];
		send	= 1'b1;

		#20
		send	= 1'b0;
    end

//     // Ejecucion continua
//     #550000
//     // $display("Sate after write INSTRUCTION MEMORY, state = %b", o_state);
//     $display("Ejecucón continua");
//     command = 2;
//     send = 1'b1;

//     #20
//     send = 1'b0;

// //    read bank register
//     #3000000
//     $display("Display read BANK REGISTER. time=%0t", $time);
//     command = 8'd4;
//     send    = 1'b1;

//     #20
//     send    = 1'b0;
    
//     // read data memory
//     #70000000
//     #20
//     $display("Display read DATA MEMORY.  time=%0t", $time);
//     command = 8'd5;
//     send    = 1'b1;

//     #20
//     send = 1'b0;

//     // read PC
//     #70000000
//     #20
//     $display("Display read PC.  time=%0t", $time);
//     command = 8'd6;
//     send    = 1'b1;

//     #20
//     send = 1'b0;
        // Ejecucion STEP BY STEP
    #5500
    $display("Ejecución step by step. time = %0t", $time);
    command = 3;
    send = 1'b1;

    #20
    send = 1'b0;

    #5500
    $display("Send step 1. time = %0t", $time);
    command = 7;
    send = 1'b1;
    #20
    send = 1'b0;
    #5500
    #22000 // lectura de PC
    #80000 // lectura de BR 
    #60000 // lectura de MEM
    
    $display("Send step 2. time = %0t", $time);
    command = 7;
    send = 1'b1;
    #20
    send = 1'b0;
    #5500
    #2200 // lectura de PC
    #8000 // lectura de BR 
    #6000 // lectura de MEM

    $display("Send step 3. time = %0t", $time);
    command = 7;
    send = 1'b1;
    #20
    send = 1'b0;
    #5500
    #2200 // lectura de PC
    #8000 // lectura de BR 
    #6000 // lectura de MEM
    
    $display("Send step 4. time = %0t", $time);
    command = 7;
    send = 1'b1;
    #20
    send = 1'b0;
    #5500
    #2200 // lectura de PC
    #8000 // lectura de BR 
    #6000 // lectura de MEM
    
    $display("Send step 5. time = %0t", $time);
    command = 7;
    send = 1'b1;
    #20
    send = 1'b0;
    #5500
    #2200 // lectura de PC
    #8000 // lectura de BR 
    #6000 // lectura de MEM

    $display("Continuar con ejecucion. time = %0t", $time);
    command = 8;
    send = 1'b1;

    #20
    send = 1'b0;

    #2200

    $finish;
  end

  always
    #5  i_clock = ! i_clock ;

endmodule

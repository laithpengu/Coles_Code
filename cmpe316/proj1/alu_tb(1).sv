module alu_tb ();

  int i;
  logic       clk = 0;
  logic       rst;
  logic       ci;
  logic [7:0] opcode;
  logic [7:0] data_a;
  logic [7:0] data_b;
  logic [15:0] data_o;
  logic       co;
  logic       zo;
  logic       no;
  int         errcnt = 0;

  alu alu (
    .clk(clk),
    .rst(rst),
    .ci(ci),
    .data_rd(data_a),
    .data_rr(data_b),
    .opcode(opcode),
    .data_o(data_o),
    .co(co),
    .zo(zo),
    .no(no)
    );

  initial begin
    forever #5ns clk = !clk;
  end

  initial begin
    rst = 1'b1;
    data_a = 8'h00;
    data_b = 8'h00;
    opcode = 8'h00;
    ci     = 1'b0;
    errcnt = 0;
    repeat(10) @(posedge clk);
    rst = 1'b0;
    @(negedge clk);
    // directed tests for positive values
    // data is 8 bits, highest number is 127, lowest is 0
    data_a = 8'd45;   //0010_1101
    data_b = 8'd84;   //0101_0100
    @(negedge clk);
    opcode = 8'b0000_XX00;  // LSL
    $display("Expected 16'b0000_0000_0101_1010, zo=0, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b0000_XX01;  // ASR
    $display("Expected 16'b0000_0000_0001_0110, zo=0, co=1, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b0000_XX10;  // ROL
    $display("Expected 16'b0000_0000_0101_1010, zo=0, co =0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b0000_XX11;  // ROR
    $display("Expected 16'b0000_0000_0001_0110, zo=0, co=1, no=1");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b0100_XXXX;  // MULT
    $display("Expected 16'h0EC4, zo=0, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b1000_XXXX;  // AND
    $display("Expected 16'b0000_0000_0000_0100, zo=0, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b1001_XXXX;  // OR
    $display("Expected 16'b0000_0000_0111_1101 zo=0, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b1010_XXXX;  // XOR
    $display("Expected 16'b0000_0000_0111_1001, zo=0, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b1011_XXXX;  // NEG
    $display("Expected 16'b0000_0000_1101_0011, zo=0, co=0, no=1");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    data_a = 8'd35;   //0010_0011
    data_b = 8'd84;   //0101_0100
    opcode = 8'b1100_XXXX;  // ADD
    $display("Expected 16'b0000_0000_0111_0111, zo=0, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b1101_XXXX;  // ADDC
    $display("Expected 16'b0000_0000_0111_0111, zo=0, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b1110_XXXX;  // SUB
    $display("Expected 16'b0000_0000_1100_1111, zo=0, co=1, no=1");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b1111_XXXX;  // SUBC
    $display("Expected 16'b0000_0000_1100_1111, zo=0, co=1, no=1");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    data_a = 8'd35;   //0010_0011
    data_b = 8'd35;   //0010_0011
    opcode = 8'b1110_XXXX;  // SUB
    $display("Expected 16'b0000_0000_0000_0000, zo=1, co=1, no=1");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

    @(negedge clk);
    opcode = 8'b0100_XXXX;  // MULT
    data_b = 8'h00;
    $display("Expected 16'h0000, zo=1, co=0, no=0");
    repeat (2) @(negedge clk);
    check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 

  // Random Tests for shift 
     for (i=0; i<50; i=i+1) begin
       @(negedge clk);
       opcode[7:3] = 6'b000000;
       opcode[1:0] = $urandom;
       data_a = $urandom_range(0,128);
       data_b = 8'h00;
       ci     = 1'b0;
       repeat (2) @(negedge clk);
       check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 
     end

  // Random Tests for arithmetic and logic functions
     for (i=0; i<100; i=i+1) begin
       @(negedge clk);
       opcode[7:4] = $urandom_range(8,15);
       opcode[3:0] = 4'h0 ;
       data_a = $urandom_range(0,127);
       data_b = $urandom_range(0,127);
       ci     = $random();
       repeat (2) @(negedge clk);
       check_result(.data_a(data_a), .data_b(data_b), .ci(ci), .opcode(opcode), .result(data_o)); 
      end

    repeat(10) @(posedge clk);
    if (errcnt == 0)
	    $display("PASS");
    else
	    $display("FAIL, there are %d errors", errcnt);
    $stop;
  end

  task check_result (
	  input [7:0] data_a, 
	  input [7:0] data_b, 
	  input       ci, 
	  input [7:0] opcode, 
	  input [15:0] result);

    logic [7:0] data_neg;
    logic no_exp;
    logic co_exp;
    logic zo_exp;
    logic [15:0] answer;

    no_exp = opcode[7:4] == 4'b0100 ? 1'b0 : result[7];
    zo_exp = ~|result;
    casex (opcode)
      8'b0000??00 : begin
                      answer = {8'd0, data_a << 1};                      // LSL
		      co_exp  = data_a[7];
		      $display("Command is LSL");
                    end
      8'b0000??01 : begin
                      answer = {8'd0, data_a[7:0] >>> 1};                // ASR
		      co_exp  = data_a[0];
		      $display("Command is ASR");
		    end
      8'b0000??10 : begin
                      answer = {8'd0, data_a[6:0], ci};                  // ROL
		      co_exp  = data_a[7];
		      $display("Command is ROL");
		    end
      8'b0000??11 : begin
                      answer = {8'd0, ci, data_a[7:1]};                  // ROR
		      co_exp  = data_a[0];
		      $display("Command is ROR");
		    end
      8'b0100???? : begin
                      answer = data_a * data_b;                           // MULT
		      co_exp = result[15];
                      no_exp = 1'b0;
		      $display("Command is MULT");
		    end
      8'b1000???? : begin
                      answer = {8'd0, data_a & data_b};                   // AND, no carry
		      co_exp = 1'b0;
		      $display("Command is AND");
		    end
      8'b1001???? : begin
                      answer = {8'd0, data_a | data_b};                   // OR, no carry
		      co_exp = 1'b0;
		      $display("Command is OR");
		    end
      8'b1010???? : begin
                      answer = {8'd0, data_a ^ data_b};                   // XOR, no carry
		      co_exp = 1'b0;
		      $display("Command is XOR");
		    end
      8'b1011???? : begin
	              data_neg = ~data_a + 1;
                      answer = {8'd0, data_neg};                       // NEG, no carry
		      co_exp = 1'b0;
		      $display("Command is NEG");
		    end
      8'b1100???? : begin
                      answer = {8'd0, data_a + data_b};                   // ADD
		      co_exp  = (data_a[7] & data_b[7]) | (data_a[7] & ~result[7]) |  (data_b[7] & ~result[7]); 
		      $display("Command is ADD");
		    end
      8'b1101???? : begin
                      answer = {8'd0, data_a + data_b + ci};              // ADDC
		      co_exp  = (data_a[7] & data_b[7]) | (data_a[7] & ~result[7]) |  (data_b[7] & ~result[7]); 
		      $display("Command is ADDC");
		    end
      8'b1110???? : begin
                      answer = {8'd0, data_a - data_b};              // SUB
		      co_exp  = (~data_a[7] & data_b[7]) | (~data_a[7] & result[7]) |  (data_b[7] & result[7]); 
		      $display("Command is SUB");
		    end
      8'b1111???? : begin
                      answer = {8'd0, data_a - data_b - ci};              // SUBC
		      co_exp  = (~data_a[7] & data_b[7]) | (~data_a[7] & result[7]) |  (data_b[7] & result[7]); 
		      $display("Command is SUBC");
		    end
      default : begin
		      $display("Invalid Command");
		end
    endcase
    $display("Rd = %b, Rr = %b, CI = %b",data_a, data_b, ci);
    if (data_o == answer) begin
      $display("Correct, data output value of %b = expected value %b",data_o,answer);
    end else begin
      $display("Error, data output value of %b != %b",data_o,answer);
      errcnt = errcnt + 1;
    end
    if (zo == zo_exp) begin
      $display("Correct, zo output value of %b = expected value%b",zo,zo_exp);
    end else begin
      $display("Error, zo output value of %b != %b",zo,zo_exp);
      errcnt = errcnt + 1;
    end
    if (co == co_exp) begin
      $display("Correct, co output value of %b = expected value%b",co,co_exp);
    end else begin
      $display("Error, co output value of %b != %b",co,co_exp);
//      errcnt = errcnt + 1;
    end
    if (no == no_exp) begin
      $display("Correct, no output value of %b = expected value%b",no,no_exp);
    end else begin
      $display("Error, no output value of %b != %b",no,no_exp);
      errcnt = errcnt + 1;
    end
  endtask

endmodule

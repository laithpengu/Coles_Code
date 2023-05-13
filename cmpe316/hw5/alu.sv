module alu (
  input  logic        clk,    // 100 MHz clock
  input  logic        rst,    // asynchronous active high reset
  input  logic [7:0]  data_rd,   // 8-bit input data
  input  logic [7:0]  data_rr,   // 8-bit input data
  input  logic [7:0]  opcode, // 8-bit opcode
  input  logic        ci,     // carry-in
  output logic [15:0] data_o, // 16-bit output data (8 msb for multiply)
  output logic        co,     // carry out
  output logic        zo,     // set if data_o equals zero
  output logic        no      // set if if msb of data_o indicates negative
);
  
  logic [15:0] data_o_d;  // flop input
  logic [15:0] data_o_q;  // flop output
  logic  [7:0] data_rd_q; // flop output
  logic  [7:0] data_rr_q; // flop output
  logic  [7:0] opcode_q;  // flop output
  logic        ci_q;      // flop output
  logic        co_d;      // flop input
  logic        co_q;      // flop output
  logic  [7:0] data_neg;

  assign data_o = data_o_q[15:0];
  assign co     = co_q;
  assign no     = opcode[7:4] == 4'b0100 ? 1'b0 : data_o_q[7];
  assign zo     = ~|data_o_q;
//  assign data_o = 16'bX;
//  assign co     = 1'bX;
//  assign no     = 1'bX;
//  assign zo     = 1'bX;

  // Register inputs and outputs, synchronize to clk
  // Reset all values to zero
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      ci_q      <= 1'b0;
      co_q      <= 1'b0;
      data_rd_q <= 8'd0;
      data_rr_q <= 8'd0;
      data_o_q  <= 16'd0;
      opcode_q  <= 8'h0;
    end else begin
      ci_q      <= ci;
      opcode_q  <= opcode;
      data_rd_q <= data_rd;
      data_rr_q <= data_rr;
      data_o_q  <= data_o_d;
      co_q      <= co_d;
    end
  end

  // case statement to execute alu functions
  always_comb begin
    data_o_d = 16'd0;
    co_d     = co_q;
    casez (opcode_q[7:0])
      8'b0000??00 : begin
                      data_o_d = {8'd0, data_rd_q << 1};                      // LSL
		      co_d  = data_rd_q[7];
                    end
      8'b0000??01 : begin
                      data_o_d = {8'd0, data_rd_q[7:0] >>> 1};                // ASR
		      co_d  = data_rd_q[0];
		    end
      8'b0000??10 : begin
                      data_o_d = {8'd0, data_rd_q[6:0], ci_q};                // ROL
		      co_d  = data_rd_q[7];
		    end
      8'b0000??11 : begin
                      data_o_d = {8'd0, ci_q, data_rd_q[7:1]};                 // ROR
		      co_d  = data_rd_q[0];
		    end
      8'b0110???? : begin
                      data_o_d = data_rd_q * data_rr_q;                           // MULT
		      co_d  = data_o_d[15];
		    end
      8'b1000???? : begin
                      data_o_d = {8'd0, data_rd_q & data_rr_q};                   // AND, no carry
		      co_d = 1'b0;
		    end
      8'b1001???? : begin
                      data_o_d = {8'd0, data_rd_q | data_rr_q};                   // OR, no carry
		      co_d = 1'b0;
		    end
      8'b1010???? : begin
                      data_o_d = {8'd0, data_rd_q ^ data_rr_q};                   // XOR, no carry
		      co_d = 1'b0;
		    end
      8'b1011???? : begin
	              data_neg =  ~data_rd_q + 1; 
                      data_o_d = {8'd0, data_neg};                       // NEG, no carry
		      co_d = 1'b0;
		    end
      8'b1100???? : begin
                      data_o_d = {8'd0, data_rd_q + data_rr_q};                   // ADD
		      co_d  = (data_rd_q[7] & data_rr_q[7]) | (data_rd_q[7] & ~data_o_d[7]) |  (data_rr_q[7] & ~data_o_d[7]); 
		    end
      8'b1101???? : begin
                      data_o_d = {8'd0, data_rd_q + data_rr_q + ci};              // ADDC
		      co_d  = (data_rd_q[7] & data_rr_q[7]) | (data_rd_q[7] & ~data_o_d[7]) |  (data_rr_q[7] & ~data_o_d[7]); 
		    end
      8'b1110???? : begin
                      data_o_d = {8'd0, data_rd_q - data_rr_q};                   // SUB
		      co_d  = (~data_rd_q[7] & data_rr_q[7]) | (~data_rd_q[7] & data_o_d[7]) |  (data_rr_q[7] & data_o_d[7]); 
		    end
      8'b1111???? : begin
                      data_o_d = {8'd0, data_rd_q - data_rr_q - ci};              // SUBC
		      co_d  = (~data_rd_q[7] & data_rr_q[7]) | (~data_rd_q[7] & data_o_d[7]) |  (data_rr_q[7] & data_o_d[7]); 
		    end
      default : begin
	            data_o_d = 8'd0;
                    co_d     = co_q;
		end
    endcase
  end

endmodule
 

module vend_mach (
  input  logic clk,
  input  logic rst,
  input  logic qtr,     // input a quarter
  input  logic dlr,     // input a dollar
  input  logic sel_dr,  // select a drink
  input  logic sel_sn,  // select a snack
  output logic o_drink, // dispense a drink
  output logic o_snack, // dispense a snack
  output logic coin_err, // dispense a snack
  output logic [2:0] num_chg // number of quarters in change
);

  enum {idle, c25, c50, c75, c100, c125, c150, c175, c200} curr_state, next_state;
  logic o_drink_d;
  logic o_snack_d;
  logic coin_err_d;
  logic [2:0] num_chg_d;

  // Sequential procedural block for state and synchronize the outputs
  always_ff @(posedge clk or posedge rst)
    begin
      if (rst) begin
        curr_state <= idle;
        o_drink    <= 1'b0;
        o_snack    <= 1'b0;
        num_chg    <= 3'b000;
	coin_err   <= 1'b0;
      end else begin
        curr_state <= next_state;
        o_drink    <= o_drink_d;
        o_snack    <= o_snack_d;
        num_chg    <= num_chg_d;
	coin_err   <= coin_err_d;
      end
    end

  // Combinational procedural block for state machine
  always_comb begin
    o_drink_d = 1'b0;
    o_snack_d = 1'b0;
    num_chg_d = 3'b000;
    coin_err_d  = 1'b0;
    next_state = curr_state;
    case (curr_state)
      idle: begin                 // wait for first coin
        if (qtr) begin
          next_state = c25; 
        end else if (dlr) begin
          next_state = c100;
        end else if (sel_dr) begin
	  coin_err_d = 1'b1;
        end else if (sel_sn) begin
          coin_err_d = 1'b1;
        end
      end
      c25: begin                  // balance of 25 cents
        if (qtr) begin
          next_state = c50; 
        end else if (dlr) begin
 	  next_state = c125;
        end else if (sel_dr) begin
 	  coin_err_d = 1'b1;
        end else if (sel_sn) begin
	  coin_err_d = 1'b1;
        end
      end
      c50: begin                  // balance of 50 cents
        if (qtr) begin
          next_state = c75; 
        end else if (dlr) begin
 	  next_state = c150;
        end else if (sel_dr) begin
 	  coin_err_d = 1'b1;
        end else if (sel_sn) begin
 	  coin_err_d = 1'b1;
        end
      end
      c75: begin                   // balance of 75 cents, can purchase a drink
        if (qtr) begin
          next_state = c100; 
        end else if (dlr) begin
	  next_state = c175;
        end else if (sel_dr) begin
	  o_drink_d = 1'b1;
	  next_state = idle;
        end else if (sel_sn) begin
	  coin_err_d = 1'b1;
        end
      end
      c100: begin                  // balance of $1.00, can purchase a drink
        if (qtr) begin
          next_state = c125; 
        end else if (dlr) begin
	  next_state = c200;
        end else if (sel_dr) begin
	  o_drink_d = 1'b1;
	  num_chg_d = 3'b001;
	  next_state = idle;
        end else if (sel_sn) begin
	  coin_err_d = 1'b1;
        end
      end
      c125: begin                  // balance of $1.25, can purchase a drink or snack
        if (qtr) begin
          next_state = c125; 
        end else if (dlr) begin
	  next_state = c125;
        end else if (sel_dr) begin
	  o_drink_d = 1'b1;
	  num_chg_d = 3'b010;
	  next_state = idle;
        end else if (sel_sn) begin
	  o_snack_d = 1'b1;
	  next_state = idle;
        end
      end
      c150: begin                  // balance of $1.50, can purchase a drink or snack
        if (qtr) begin
          next_state = c150; 
        end else if (dlr) begin
 	  next_state = c150;
        end else if (sel_dr) begin
	  o_drink_d = 1'b1;
	  num_chg_d = 3'b011;
	  next_state = idle;
        end else if (sel_sn) begin
	  o_snack_d = 1'b1;
 	  num_chg_d = 3'b001;
	  next_state = idle;
        end
      end
      c175: begin                  // balance of $1.75, can purchase a drink or snack
        if (qtr) begin
          next_state = c175; 
        end else if (dlr) begin
	  next_state = c175;
        end else if (sel_dr) begin
	  o_drink_d = 1'b1;
	  num_chg_d = 3'b100;
	  next_state = idle;
        end else if (sel_sn) begin
	  o_snack_d = 1'b1;
 	  num_chg_d = 3'b010;
	  next_state = idle;
        end
      end
      c200: begin                  // balance of $2.00, can purchase a drink or snack
         if (qtr) begin
           next_state = c200; 
         end else if (dlr) begin
 	   next_state = c200;
         end else if (sel_dr) begin
	   o_drink_d = 1'b1;
  	   num_chg_d = 3'b101;
	  next_state = idle;
         end else if (sel_sn) begin
	   o_snack_d = 1'b1;
 	   num_chg_d = 3'b011;
	  next_state = idle;
        end
      end
      default: begin
	  next_state = idle;
      end
    endcase
  end
endmodule

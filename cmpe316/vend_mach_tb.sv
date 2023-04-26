module vend_mach_tb ();

  logic       clk = 0;
  logic       rst;
  logic       qtr;     // input a quarter
  logic       dlr;     // input a dollar
  logic       sel_dr;  // select a drink
  logic       sel_sn;  // select a snack
  logic       o_drink; // dispense a drink
  logic       o_snack; // dispense a snack
  logic       coin_err; // dispense a snack
  logic [2:0] num_chg; // number of quarters in change


  vend_mach u_vend_mach (
  .clk(clk),
  .rst(rst),
  .qtr(qtr),     // input a quarter
  .dlr(dlr),     // input a dollar
  .sel_dr(sel_dr),  // select a drink
  .sel_sn(sel_sn),  // select a snack
  .o_drink(o_drink), // dispense a drink
  .o_snack(o_snack), // dispense a snack
  .coin_err(coin_err), // dispense a snack
  .num_chg(num_chg) // number of quarters in change
);

  task ins_qtr ();
      @(posedge clk);
      #1ps qtr = 1'b1;
      @(posedge clk);
      #1ps qtr = 1'b0;
      $display("Quarter inserted");
  endtask

  task ins_dlr ();
      @(posedge clk);
      #1ps dlr = 1'b1;
      @(posedge clk);
      #1ps dlr = 1'b0;
      $display("Dollar inserted");
  endtask

  task sel_dri ();
      @(posedge clk);
      #1ps sel_dr = 1'b1;
      @(posedge clk);
      #1ps sel_dr = 1'b0;
      $display("Select drink");
  endtask

  task sel_sna ();
      @(posedge clk);
      #1ps sel_sn = 1'b1;
      @(posedge clk);
      #1ps sel_sn = 1'b0;
      $display("Select snack");
  endtask

  initial forever #5 clk = ~clk;

  initial begin
    forever begin
      @(posedge clk);
      if (coin_err) begin
        $display("Not enough coins");
      end else if (o_drink) begin
        $display("Drink dispensed and your change is %d cents", num_chg*25);
      end else if (o_snack) begin
        $display("Snack dispensed and your change is %d cents", num_chg*25);
      end
    end
  end
     
  initial begin
    rst = 1'b1;
    qtr = 1'b0;
    dlr = 1'b0;
    sel_dr = 1'b0;
    sel_sn = 1'b0;
    repeat(5) @(posedge clk);
    rst = 1'b0;
    ins_qtr;
    ins_qtr;
    ins_qtr;
    sel_sna;        // coin_err
    ins_dlr;
    sel_sna;        // dispense snack, 50 cents
    sel_dri;        // coin_err
    ins_qtr;
    sel_dri;        // coin_err
    ins_qtr;
    sel_dri;        // coin_err
    ins_qtr;
    sel_dri;        // dispense drink, 0 cents
  end
endmodule

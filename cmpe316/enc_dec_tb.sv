module enc_dec_tb ();

  logic [3:0] datai;
  logic [3:0] datao;
  logic [3:0] err;
  logic       sec;
  logic       ded;
  logic clk = 0;
  logic rst = 0;

  enc_dec u_enc_dec (
    .clk(clk),
    .rst(rst),
    .err(err),
    .datai(datai),
    .datao(datao),
    .sec(sec),
    .ded(ded)
  );

  initial begin
    forever #10ns clk = !clk;
  end

    
  initial begin
    datai = 4'b0000;
    err   = 4'b0000;
    rst = 1;
    #49ns rst = 0;
    datai = 4'b1101;
    err   = 4'b0000;
    #40ns;
    err   = 4'b0100;
    #40ns;
    err   = 4'b0110;
    #5000ns;
    $stop;
  end

endmodule


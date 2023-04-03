module decoder (
  input  logic       clk,
  input  logic       rst,
  input  logic [7:0] enc_data,
  output logic [3:0] datao,
  output logic       sec,
  output logic       ded);

  logic [3:0] data_d;
  logic [3:0] data_q;
  logic       p1;
  logic       p2;
  logic       p3;
  logic       p4;
  logic       p1x;
  logic       p2x;
  logic       p3x;
  logic       p4x;

  assign datao = data_q;
  assign ded   = ~p4x & (p1x | p2x | p3x);
  assign sec   =  p1x | p2x | p3x;

  always_ff @(posedge clk or posedge rst)
    begin
      if (rst) begin
        data_q <= 4'b0;
      end else begin
        data_q <= data_d;
      end   
    end

  always_comb begin // calculate parity based on received data
    p1 = enc_data[0] ^ enc_data[1] ^ enc_data[3];
    p2 = enc_data[0] ^ enc_data[2] ^ enc_data[3];
    p3 = enc_data[1] ^ enc_data[2] ^ enc_data[3];
    p4 = ^enc_data[6:0];
  end

  always_comb begin // compare calculated parity with received parity 
    p1x = p1 ^ enc_data[4];
    p2x = p2 ^ enc_data[5];
    p3x = p3 ^ enc_data[6];
    p4x = p4 ^ enc_data[7];
  end

  always_comb begin
    if (!p3x && p2x && p1x) begin
       data_d[0] = p4x ^ enc_data[0];
       data_d[3:1] = enc_data[3:1]; 
    end else if (p3x && !p2x && p1x) begin
       data_d[0] = enc_data[0]; 
       data_d[1] = p4x ^ enc_data[1];
       data_d[3:2] = enc_data[3:2]; 
    end else if (p3x && p2x && !p1x) begin
       data_d[1:0] = enc_data[1:0]; 
       data_d[2] = p4x ^ enc_data[2];
       data_d[3] = enc_data[3]; 
    end else if (p3x && p2x && p1x) begin
       data_d[2:0] = enc_data[2:0]; 
       data_d[3] = p4x ^ enc_data[3];
    end else begin
       data_d = enc_data;
     end
  end

endmodule

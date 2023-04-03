module (
    input   logic           clk,
    input   logic           rst,
    input   logic   [2:0]   symb_vals,
    output  logic   [3:0]   winfactor);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin

        end else begin

        end 
    end

endmodule
module programcounter (
    input   logic           clk, // clock input
    input   logic           rst, // reset
    input   logic           inc, // increment
    input   logic           jmp, // jump or jumpc
    input   logic           call, // call
    input   logic           ret, // return
    input   logic   [7:0]   addr_in, // address for jump or call commands
    output  logic   [7:0]   adout); // address output to block mem

    logic   [7:0]   adout_d;
    logic   [7:0]   adout_q;
    logic   [7:0]   ret_reg;

    assign  adout = adout_q

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            adout_q <= 8'b0;
        end else begin
            adout_q <= adout_d;
        end
    end

    always_comb begin
        if (inc) begin
            adout_d = adout_d + 1;
        end else if (jmp) begin
            adout_d = addr_in;
        end else if (call) begin
            ret_reg = adout_d;
            adout_d = addr_in;
        end else if (ret) begin
            adout_d = ret_reg + 2;
        end else if (rst) begin
            adout_d = 0;
        end
    end    

endmodule
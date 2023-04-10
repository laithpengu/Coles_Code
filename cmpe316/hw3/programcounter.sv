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
    logic   [7:0]   ret_reg_d;
    logic   [7:0]   ret_reg_q;

    assign  adout = adout_q;

    // output flipflop
    always_ff @(posedge clk or posedge rst) 
        begin
            if (rst) begin
                adout_q     <= 8'b00000000;
                ret_reg_q   <= 8'b00000000;
            end else begin
                adout_q     <= adout_d;
                ret_reg_q   <= ret_reg_d;
            end
        end

    // combinational logic
    always_comb begin
        if (inc) begin // increment command
            adout_d = adout_q + 1;
        end else if (jmp) begin // jump command
            adout_d = addr_in + 1;
        end else if (call) begin // call command
            ret_reg_d = adout_q;
            adout_d = addr_in + 1;
        end else if (ret) begin // return command
            adout_d = ret_reg_q + 2;
        end else begin // hold value
            adout_d = adout_q;
            ret_reg_d = ret_reg_q;
        end
    end    

endmodule
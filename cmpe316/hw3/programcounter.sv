module programcounter (
    input   logic           clk, // clock input
    input   logic           BTNR, // button reset
    input   logic           BTNC, // button count
    input   logic           BTNL, // jump or jumpc button
    input   logic           BTNU // call command
    input   logic           BTND, // return command
    input   logic   [7:0]   adin, // address for jump or call commands
    output  logic   [7:0]   adout); // address output to block mem

    logic   inc,    BTNC_q;
    logic   jmp,    BTNL_q;
    logic   call,   BTNU_q;
    logic   ret,    BTND_q;
    logic   [7:0]   adin_q;
    logic   [7:0]   adin_d;
    logic   [7:0]   adout_q;
    logic   [7:0]   adout_d;

    assign  inc = BTNC & ~BTNC_q;
    assign  jmp = BTNL & ~BTNL_q;
    assign  call = BTNU & ~BTNU_q;
    assign  ret = BTND & ~BTND_q;
    assign  adin_d = adin;
    assign  adout = adout_q;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            BTNC_q  <= 1'b0;
            BTNL_q  <= 1'b0;
            BTNU_q  <= 1'b0;
            BTND_q  <= 1'b0;
            adin_q  <= 8'b0;
            adout_q <= 8'b0
        end else begin
            BTNC_q  <= BTNC;
            BTNL_q  <= BTNL;
            BTNU_q  <= BTNU;
            BTND_q  <= BTND;
            adin_q  <= adin_d;
            adin_q  <= adin_d;
        end
    end

    always_comb begin
        if (inc) begin

        end else if (jmp) begin

        end else if (call) begin

        end else if (ret) begin

        end
    end    

endmodule
module programcounter (
    input   wire            clk, // clock input
    input   wire            BTNR, // button reset
    input   wire            BTNC, // button count
    input   wire            BTNL, // jump or jumpc button
    input   wire            BTNU // call command
    input   wire            BTND); // return command

    wire    inc;
    wire    jmp;
    wire    call;   
    wire    ret;
    reg     BTNC_q;
    reg     BTNL_q;
    reg     BTNU_q;
    reg     BTND_q;

    assign  inc = BTNC & ~BTNC_q;
    assign  jmp = BTNL & ~BTNL_q;
    assign  call = BTNU & ~BTNU_q;
    assign  ret = BTND & ~BTND_q;

    always_ff @(posedge clk or posedge BTNR) begin
        if (BTNR) begin
            BTNC_q  <= 1'b0;
            BTNL_q  <= 1'b0;
            BTNU_q  <= 1'b0;
            BTND_q  <= 1'b0;
        end else begin
            BTNC_q  <= BTNC;
            BTNL_q  <= BTNL;
            BTNU_q  <= BTNU;
            BTND_q  <= BTND;
        end
    end

    // internal address wiring
    wire    [7:0]   sv;
    wire    [7:0]   adout;

    programcounter programcounter (
        .clk(clk),
        .rst(BTNR),
        .inc(inc),
        .call(call),
        .ret(ret)
        .
        );

    blk_mem blk_mem(
        
        );

endmodule
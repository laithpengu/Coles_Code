module pc_wrapper (
    input   wire            clk, // clock input
    input   wire            BTNR, // button reset
    input   wire            BTNC, // button count
    input   wire            BTNL, // jump or jumpc button
    input   wire            BTNU, // call command
    input   wire            BTND, // return command
    input   wire    [7:0]   sw,
    output  wire    [7:0]   inst_o); 

    wire    inc;
    wire    jmp;
    wire    call;   
    wire    ret;
    reg     BTNC_q;
    reg     BTNL_q;
    reg     BTNU_q;
    reg     BTND_q;

    // button edge detect code
    assign  inc = BTNC & ~BTNC_q;
    assign  jmp = BTNL & ~BTNL_q;
    assign  call = BTNU & ~BTNU_q;
    assign  ret = BTND & ~BTND_q;

    always @(posedge clk or posedge BTNR) begin
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

    // internal wiring
    wire    [7:0]   prog_count;
    wire    [7:0]   dina;
    wire            wea;
    assign dina = 8'b00000000;
    assign wea = 1'b0;

    // module instantiation
    programcounter programcounter (
        .clk(clk),
        .rst(BTNR),
        .inc(inc),
        .jmp(jmp),
        .call(call),
        .ret(ret),
        .addr_in(sw),
        .adout(prog_count)
    );

    blk_mem_gen_0 u_inst_sram(
        .clka(clk),
        .addra(prog_count),
        .douta(inst_o),
        .dina(dina),
        .wea(wea)
    );

endmodule
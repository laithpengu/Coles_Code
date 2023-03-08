module proj1_alu_tb ();

    logic clk = 0;
    logic rst = 0;
    logic [7:0] data_rr;
    logic [7:0] data_rd;
    logic ci;
    logic [7:0] opcode;
    logic [15:0] data_o;
    logic co;
    logic zo;
    logic no;

    // instantiate module
    proj1_alu u_proj1_alu(
        .clk(clk),
        .rst(rst),
        .data_rr(data_rr),
        .data_rd(data_rd),
        .ci(ci),
        .opcode(opcode),
        .data_o(data_o),
        .co(co),
        .zo(zo),
        .no(no)
    );

    initial begin
        forever #10ns clk = !clk;
    end

    initial begin
        rst     = 1;
        #50ns; 
        rst     = 0;
        // lsl test
        opcode  = 8'b0000XX00;
        data_rr = 8'b00000000;
        data_rd = 8'b00000001;
        #50ns;
        // asr test
        opcode  = 8'b0000XX01;
        data_rr = 8'b00000000;
        data_rd = 8'b10001000;
        #50ns;
        // rol test
        opcode  = 8'b0000XX10;
        data_rr = 8'b00000000;
        data_rd = 8'b00010000;
        ci      = 1;
        #50ns;
        // ror test
        opcode  = 8'b0000XX11;
        data_rr = 8'b00000000;
        data_rd = 8'b00010000;
        ci      = 1;
        #50ns;
        // mult test
        opcode  = 8'b0100XXXX;
        data_rr = 8'b00000100;
        data_rd = 8'b00000100;
        #50ns;
        // and test
        opcode  = 8'b1000XXXX;
        data_rr = 8'b00101100;
        data_rd = 8'b00100100;
        #50ns;
        // or test
        opcode  = 8'b1001XXXX;
        data_rr = 8'b00101100;
        data_rd = 8'b00100100;
        #50ns;
        // xor test
        opcode  = 8'b1010XXXX;
        data_rr = 8'b00101100;
        data_rd = 8'b00100100;
        #50ns;
        // neg test
        opcode  = 8'b1011XXXX;
        data_rr = 8'b00000000;
        data_rd = 8'b00100100;
        #50ns;
        #5000ns;
        $stop;
    end
endmodule
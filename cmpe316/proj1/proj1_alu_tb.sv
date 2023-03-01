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

    alu dut(
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
        
    end
endmodule
/*
 *
 *   File Name:    reg_tb.sv
 *   Date Created: Wed Apr 19 2023
 *   Author:       Cole Cavanagh
 *   Description:  Testbench for 316 HW 3 Register Module
 *
 */

module reg_tb();
    // define instantiation inputs
    int             i;
    logic   [1:0]   rand_addr;
    logic   [7:0]   rand_dataa;
    logic   [7:0]   rand_datab;

    logic           clk = 0;
    logic   [1:0]   wr_addr;
    logic   [7:0]   wr_data;
    logic           wr_en;
    logic   [1:0]   rda_addr;
    logic   [1:0]   rdb_addr;
    logic           rst;
    logic   [7:0]   rda_data;
    logic   [7:0]   rdb_data;


    // instantiate wrapper
    reg_file reg_file (
        .clk(clk),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rda_addr(rda_addr),
        .rdb_addr(rdb_addr),
        .rst(rst),
        .rda_data(rda_data),
        .rdb_data(rdb_data)
    );

    // setup clock
    initial begin
        forever #5ns clk = !clk;
    end

    initial begin
        // reset module
        rst = 1'b1;
        wr_addr = 2'b00;
        wr_data = 8'b00000000;
        wr_en = 1'b0;
        rda_addr = 2'b00;
        rdb_addr = 2'b00;
        repeat (5) @(negedge clk);
        rst = 0'b0;
        repeat (5) @(negedge clk);

        // test loop
        for (i = 0; i < 10; i = i +1) begin
            // write in random data to random reg
            rand_addr = $urandom_range(0, 3);
            rand_dataa = $urandom_range(0, 127);
            wr_addr = rand_addr;
            wr_data = rand_dataa;
            @(negedge clk);
            wr_en = 1'b1;
            rda_addr = rand_addr;
            repeat (3) @(negedge clk);
            wr_en = 1'b0;

            // write in random data to random reg
            rand_addr = $urandom_range(0, 3);
            rand_datab = $urandom_range(0, 127);
            wr_addr = rand_addr;
            wr_data = rand_datab;
            @(negedge clk);
            wr_en = 1'b1;
            rdb_addr = rand_addr;
            repeat (3) @(negedge clk);
            wr_en = 1'b0;

            // check output
            repeat (3) @(negedge clk);
            if (rand_dataa == rda_data) begin
                $write("%d: Read A matches Random A, ", i);
            end else begin
                $write("%d: Read A does not match Random A, ", i);
            end
            if (rand_datab == rdb_data) begin
                $display("Read B matches Random B, ");
            end else begin
                $display("Read B does not match Random B, ");
            end
        end
    end
endmodule


/*
 *
 *   File Name:    cpu_tb.sv
 *   Date Created: Tue May 09 2023
 *   Author:       Cole Cavanagh
 *   Description:  cpu wrapper test bench for 316 HW5
 *
 */

module cpu_tb();

    // init test inputs
    logic           clk = 0;
    logic   [15:0]  SW;
    logic           BTNC;
    logic           rst;
    logic   [7:0]   data;

    // init cpu wrapper
    cpu cpu (
        .clk(clk),
        .SW(SW),
        .BTNC(BTNC),
        .BTNR(rst),
        .data(data)
    );

    // start clk
    initial begin
        forever #5ns clk = !clk;
    end

    initial begin
        // reset
        rst = 1'b1; 
        repeat (5) @(negedge clk);
        rst = 1'b0;

        // test
    end

endmodule
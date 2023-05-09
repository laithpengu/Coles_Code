/*
 *
 *   File Name:    io_reg.sv
 *   Date Created: Tue May 09 2023
 *   Author:       Cole Cavanagh
 *   Description:  IO register for 316 HW 5
 *
 */

module io_reg(
    input           clk,
    input           rst,
    input   [7:0]   wr_data,
    input           wr_en,
    output  [7:0]   rd_data);

    logic   [7:0]   reg_d;
    logic   [7:0]   reg_q;

    assign      rd_data = reg_q;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_q <= 8'b00000000; 
        end else begin
            reg_q <= reg_d;
        end
    end

    always_comb begin
        if (wr_en == 1'b1) begin
            reg_d = wr_data;
        end else begin
            reg_d = reg_q;
        end
    end

endmodule
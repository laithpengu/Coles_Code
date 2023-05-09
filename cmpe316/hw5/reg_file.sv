/*
 *
 *   File Name:    reg_file.sv
 *   Date Created: Mon Apr 17 2023
 *   Author:       Cole Cavanagh
 *   Description:  System Verilog Register File for a microcontroller
 *
 */

module reg_file(
    input   logic           clk,        // clock
    input   logic   [1:0]   wr_addr,    // write address
    input   logic   [7:0]   wr_data,    // write data
    input   logic           wr_en,      // write enable
    input   logic   [1:0]   rda_addr,   // read address a
    input   logic   [1:0]   rdb_addr,   // read address b
    input   logic           rst,        // reset
    output  logic   [7:0]   rda_data,   // read data a
    output  logic   [7:0]   rdb_data   // read data b
    );

    // Create FF Wires
    logic   [1:0]   wr_addr_q;
    logic   [7:0]   wr_data_q;
    logic           wr_en_q;
    logic   [1:0]   rda_addr_q;
    logic   [1:0]   rdb_addr_q;
    logic   [7:0]   rda_data_d;
    logic   [7:0]   rda_data_q;
    logic   [7:0]   rdb_data_d;
    logic   [7:0]   rdb_data_q;

    // Register Logic
    logic   [7:0]   reg0_d;
    logic   [7:0]   reg0_q;
    logic   [7:0]   reg1_d;
    logic   [7:0]   reg1_q;
    logic   [7:0]   reg2_d;
    logic   [7:0]   reg2_q;
    logic   [7:0]   reg3_d;
    logic   [7:0]   reg3_q;

    // Assign FF in or out
    assign  rda_data    = rda_data_q;
    assign  rdb_data    = rdb_data_q;

    // Main Register
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_addr_q   = 2'b00;
            wr_data_q   = 8'b00000000;
            wr_en_q     = 1'b0;
            rda_addr_q  = 2'b00;
            rdb_addr_q  = 2'b00;
            rda_data_q  = 8'b00000000;
            rdb_data_q  = 8'b00000000;
            reg0_q      = 8'b00000000;
            reg1_q      = 8'b00000000;
            reg2_q      = 8'b00000000;
            reg3_q      = 8'b00000000;
        end else begin
            wr_addr_q   = wr_addr;
            wr_data_q   = wr_data;
            wr_en_q     = wr_en;
            rda_addr_q  = rda_addr;
            rdb_addr_q  = rdb_addr;
            rda_data_q  = rda_data_d;
            rdb_data_q  = rdb_data_d;
            reg0_q      = reg0_d;
            reg1_q      = reg1_d;
            reg2_q      = reg2_d;
            reg3_q      = reg3_d;
        end
    end

    always_comb begin
        // read address A logic 
        case (rda_addr_q)
            2'b00   :   rda_data_d = reg0_q; // read addr 00
            2'b01   :   rda_data_d = reg1_q; // read addr 01
            2'b10   :   rda_data_d = reg2_q; // read addr 10
            2'b11   :   rda_data_d = reg3_q; // read addr 11
            default :   rda_data_d = rda_data_q; // hold current value
        endcase

        // read address A logic 
        case (rdb_addr_q)
            2'b00   :   rdb_data_d = reg0_q; // read addr 00
            2'b01   :   rdb_data_d = reg1_q; // read addr 01
            2'b10   :   rdb_data_d = reg2_q; // read addr 10
            2'b11   :   rdb_data_d = reg3_q; // read addr 11
            default :   rdb_data_d = rdb_data_q; // hold current value
        endcase

        // write logic
        case({wr_en, wr_addr_q})
            3'b100  :   begin // write reg 0
                        reg0_d = wr_data_q;
                        reg1_d = reg1_q;
                        reg2_d = reg2_q;
                        reg3_d = reg3_q;
                        end 
            3'b101  :   begin // write reg 1
                        reg0_d = reg0_q;
                        reg1_d = wr_data_q;
                        reg2_d = reg2_q;
                        reg3_d = reg3_q;
                        end 
            3'b110  :   begin // write reg 2
                        reg0_d = reg0_q;
                        reg1_d = reg1_q;
                        reg2_d = wr_data_q;
                        reg3_d = reg3_q;
                        end 
            3'b111  :   begin // write reg 3
                        reg0_d = reg0_q;
                        reg1_d = reg1_q;
                        reg2_d = reg2_q;
                        reg3_d = wr_data_q;
                        end 
            default :   begin // hold reg values
                        reg0_d = reg0_q;
                        reg1_d = reg1_q;
                        reg2_d = reg2_q;
                        reg3_d = reg3_q;
                        end 
        endcase
    end


endmodule
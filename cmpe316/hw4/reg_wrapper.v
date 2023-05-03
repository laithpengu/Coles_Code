/*
 *
 *   File Name:    reg_wrapper.v
 *   Date Created: Tue Apr 18 2023
 *   Author:       Cole Cavanagh
 *   Description:  Verilog Wrapper for reg_file.sv and alu.sv to allow for block implementation
 *
 */

module reg_wrapper (
    input   wire            clk, // clock input
    input   wire            BTNR, // button right (reset) 
    input   wire            BTNC, // button center (write enable)
    input   wire    [13:0]  SW, // switch input ([7:0] write data, [9:8] wr addr, [11:10] rda addr, [13:12] rdb addr)
    output  wire    [7:0]   data_o, // data output
    output  wire    [2:0]   LED); // Led output 

    // ff logic
    wire    wr_en;
    reg     BTNC_q;

    // assign inputs and outputs
    assign  wr_en = BTNC & ~BTNC_q;

    // io ff
    always @(posedge clk or posedge BTNR) begin
        if (BTNR) begin
            BTNC_q  <= 1'b0;
        end else begin
            BTNC_q  <= BTNC;
        end
    end

    // interconnect logic
    wire    [7:0]   rda_data;
    wire    [7:0]   rdb_data;
    wire    [7:0]   opcode;
    wire            ci;

    assign  opcode  = 8'b10000000;
    assign  ci      = 1'b0;


    // instantiate modules
    reg_file reg_file (
        .clk(clk),
        .wr_addr(SW[9:8]),
        .wr_data(SW[7:0]),
        .wr_en(wr_en),
        .rda_addr(SW[11:10]),
        .rdb_addr(SW[13:12]),
        .rst(BTNR),
        .rda_data(rda_data),
        .rdb_data(rdb_data)
    );

    alu alu (
        .clk(clk),
        .rst(BTNR),
        .data_rd(rda_data),
        .data_rr(rdb_data),
        .opcode(opcode),
        .ci(ci),
        .data_o(data_o),
        .co(LED[0]),
        .zo(LED[1]),
        .no(LED[2])
    );

endmodule
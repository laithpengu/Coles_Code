/*
 *
 *   File Name:    cpu.v
 *   Date Created: Mon May 01 2023
 *   Author:       Cole Cavanagh
 *   Description:  Wrapper for entire microcontroller
 *
 */

module cpu_wrapper(
    input   wire            clk, // clock input
    input   wire    [15:0]  SW, // input all switches
    input   wire            BTNC, // rden
    input   wire            BTNR, // reset
    output  wire    [7:0]   data); // data out

    // ff logic
    wire    rd_en;
    reg     BTNC_q;

    // assign inputs and outputs
    assign  rd_en = BTNC & ~BTNC_q;

    // io ff
    always @(posedge clk or posedge BTNR) begin
        if (BTNR) begin
            BTNC_q  <= 1'b0;
        end else begin
            BTNC_q  <= BTNC;
        end
    end

    // instantiate modules
    alu alu (
        .clk(clk),
        .rst(BTNR),
        .data_rd(),
        .data_rr(),
        .opcode(),
        .ci(),
        .data_o(),
        .co(),
        .zo(),
        .no()
    );

    programcounter programcount (
        .clk(clk),
        .rst(BTNR),
        .inc(),
        .jmp(),
        .call(),
        .ret(),
        .addr_in(),
        .adout()
    );

    controllogic

    reg_file reg_file (
        .clk(clk),
        .wr_addr(),
        .wr_data(),
        .wr_en(),
        .rda_addr(),
        .rdb_addr(),
        .rst(rst),
        .rda_data(),
        .rdb_data()
    );

    blk_mem_gen_0 u_inst_sram (
        .clka(clk),
        .addra(prog_count),
        .douta(inst_o),
        .dina(dina),
        .wea(wea)
    );

    blk_mem_gen0 data_mem ();

    io_reg io_reg (
        .clk(clk),
        .wr_data(),
        .wr_en(),
        .rd_data(data)
    );


endmodule
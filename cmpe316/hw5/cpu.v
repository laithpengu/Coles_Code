/*
 *
 *   File Name:    cpu.v
 *   Date Created: Mon May 01 2023
 *   Author:       Cole Cavanagh
 *   Description:  Wrapper for entire microcontroller
 *
 */

module cpu(
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

    // interconnect logic
    wire            inc;
    wire            jmp;
    wire            call;
    wire            ret;
    wire    [7:0]   pcaddr_in;
    wire    [7:0]   pcaddr_o;
    wire    [7:0]   inst;
    wire    [7:0]   regdata_rda;
    wire    [7:0]   regdata_rdb;
    wire    [1:0]   regaddr_wr;
    wire    [7:0]   regdata_wr;
    wire            regwr_en;
    wire    [1:0]   regaddr_rda;
    wire    [1:0]   regaddr_rdb;
    wire    [7:0]   memdata_o;
    wire    [7:0]   memaddr;
    wire    [7:0]   memdata_in;
    wire            memwr_en;
    wire    [7:0]   aludata_rd;
    wire    [7:0]   aludata_rr;
    wire    [7:0]   alu_opcode;
    wire            alu_ci;
    wire    [15:0]  aludata_o;
    wire            alu_co;
    wire            alu_zo;
    wire            alu_no;
    wire    [7:0]   iodata_wr;
    wire            iowr_en;


    // instantiate modules
    alu alu (
        .clk(clk),
        .rst(BTNR),
        .data_rd(aludata_rd),
        .data_rr(aludata_rr),
        .opcode(alu_opcode),
        .ci(alu_ci),
        .data_o(aludata_o),
        .co(alu_co),
        .zo(alu_zo),
        .no(alu_no)
    );

    programcounter programcounter (
        .clk(clk),
        .rst(BTNR),
        .inc(inc),
        .jmp(jmp),
        .call(call),
        .ret(ret),
        .addr_in(pcaddr_in),
        .adout(pcaddr_o)
    );

    controllogic controllogic (
        .clk(clk),
        .rst(BTNR),
        .inst(inst),
        .inc(inc),
        .jmp(jmp),
        .call(call),
        .ret(ret),
        .regdata_rda(regdata_rda),
        .regdata_rdb(regdata_rdb),
        .regaddr_wr(regaddr_wr),
        .regdata_wr(regdata_wr),
        .regwr_en(regwr_en),
        .regaddr_rda(regaddr_rda),
        .regaddr_rdb(regaddr_rdb),
        .memdata_o(memdata_o),
        .memaddr(memaddr),
        .memdata_in(memdata_in),
        .memwr_en(memwr_en),
        .alu_co(alu_co),
        .alu_zo(alu_zo),
        .alu_no(alu_no),
        .aludata_o(aludata_o),
        .alu_opcode(alu_opcode),
        .alu_ci(alu_ci),
        .aludata_rd(aludata_rd),
        .aludata_rr(aludata_rr),
        .iowr_en(iowr_en)
    );

    reg_file reg_file (
        .clk(clk),
        .wr_addr(regaddr_wr),
        .wr_data(regdata_wr),
        .wr_en(regwr_en),
        .rda_addr(regaddr_rda),
        .rdb_addr(regaddr_rdb),
        .rst(rst),
        .rda_data(regdata_rda),
        .rdb_data(regdata_rdb)
    );

    u_inst_sram u_inst_sram (
        .clka(clk),
        .addra(pcaddr_o),
        .douta(inst),
        .ena(1'b1)
    );

    data_mem data_mem (
        .clka(clk),
        .addra(memaddr),
        .dina(memdata_in),
        .douta(memdata_o),
        .ena(1'b1),
        .wea(memwr_en)
    );

    io_reg io_reg (
        .clk(clk),
        .wr_data(memdata_o),
        .wr_en(iowr_en),
        .rd_data(data)
    );


endmodule
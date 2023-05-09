/*
 *
 *   File Name:    controllogic.sv
 *   Date Created: Mon May 01 2023
 *   Author:       Cole Cavanagh
 *   Description:  Control Logic for 316 HW 5
 *
 */

module controllogic(
    input    logic           clk,
    input    logic           rst,
    input    logic   [7:0]   inst,
    input    logic   [7:0]   regdata_rda,
    input    logic   [7:0]   regdata_rdb,
    input    logic   [7:0]   memdata_o,
    input    logic           alu_co,
    input    logic           alu_zo,
    input    logic           alu_no,
    input    logic   [15:0]  aludata_o,
    output   logic           inc,
    output   logic           jmp,
    output   logic           call,
    output   logic           ret,
    output   logic   [7:0]   pcaddr_in,
    output   logic   [1:0]   regaddr_wr,
    output   logic   [7:0]   regdata_wr,
    output   logic           regwr_en,
    output   logic   [1:0]   regaddr_rda,
    output   logic   [1:0]   regaddr_rdb,
    output   logic   [7:0]   memaddr,
    output   logic   [7:0]   memdata_in,
    output   logic           memwr_en,
    output   logic   [7:0]   alu_opcode,
    output   logic           alu_ci,
    output   logic   [7:0]   aludata_rd,
    output   logic   [7:0]   aludata_rr,
    output   logic   [7:0]   iodata_wr,
    output   logic           iowr_en
    );


    enum {idle, wait_state0, wait_state1, ld, wr0, wr1} curr_state, next_state, ret_state;

    logic   [7:0]   opcode_d;
    logic   [7:0]   opcode_q;

    // sequential logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            opcode_q <= 8'b00000000;
            curr_state <= idle;
        end else begin
            opcode_q <= opcode_d; // opcode reg
            curr_state <= next_state;
        end
    end

    // main state machine
    always_comb begin
        case (curr_state) 
            idle:       begin // idle state

                        // read and store instruction
                        opcode_d = inst;
                        // inc
                        inc = 1'b1;
                        // wait 2 clock cycles
                        next_state = wait_state1;
                        // rd opcode decide path
                        casez (inst) 
                            8'b0011??00:    begin // LD 
                                            ret_state = ld;

                                            end
                            8'b0001????:    begin // wr
                                            ret_state = wr0;
                                            end
                        endcase
                        end

            wait_state0:begin // wait state
                        regwr_en = 1'b0;
                        memwr_en = 1'b0;
                        next_state = ret_state;
                        end

            wait_state1:begin // wait state
                        // turn off inc
                        inc = 1'b0;
                        next_state = wait_state0;
                        end

            ld:         begin // load state
                        // set outputs
                        regaddr_wr = opcode_q[3:2];
                        regdata_wr = inst;
                        // write
                        regwr_en = 1'b1;
                        // inc
                        inc = 1'b1;
                        // wait 2 and ret to idle
                        next_state = wait_state1;
                        ret_state = idle;
                        end

            wr0:        begin // write state 0
                        // set reg read addresses
                        regaddr_rda = opcode_q[1:0];
                        regaddr_rdb = opcode_q[3:2];
                        // wait 1 clock and ret to wr1
                        next_state = wait_state1;
                        ret_state = wr1;
                        end

            wr1:        begin // write state 1
                        // set mem inputs
                        memaddr = regdata_rda;
                        memdata_in = regdata_rdb;
                        // set wr en
                        memwr_en = 1'b1;
                        // wait 2 and ret to idl
                        next_state = wait_state0;
                        ret_state = idle;
                        end

        endcase
    end
endmodule
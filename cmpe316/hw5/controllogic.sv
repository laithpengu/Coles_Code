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
    input    logic           data_in,
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
    output   logic           iowr_en
    );


    enum {idle, wait_state0, wait_state1, wait_state2, ld, wr0, wr1, rd0, rd1, wrio0, wrio1, jmp0, jmp1, jmpc, call0, call1, ret0, brk, alu0, alu1, mult0, mult1} curr_state, next_state, ret_state;

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
                            8'b0010????:    begin // rd
                                            regaddr_rda = inst[1:0];
                                            ret_state = rd0;
                                            end    
                            8'b011100??:    begin // wrio
                                            regaddr_rda = inst[1:0];
                                            ret_state = wrio0;
                                            end
                            8'b01000000:    begin // jmp
                                            ret_state = jmp0;
                                            end
                            8'b01001???:    begin // jmpc
                                            ret_state = jmpc;
                                            end
                            8'b01010000:    begin // call
                                            ret_state = call0;
                                            end
                            8'b01011000:    begin // ret
                                            ret_state = ret0;
                                            end
                            8'b01111100:    begin // noop
                                            ret_state = idle;
                                            end
                            8'b01111111:    begin // break
                                            ret_state = brk;
                                            end
                            default:        begin // alu 
                                            ret_state = alu0;
                                            regaddr_rda = inst[3:2];
                                            regaddr_rdb = inst[1:0];
                                            end
                        endcase
                        end

            wait_state0:begin // wait state
                        regwr_en = 1'b0;
                        memwr_en = 1'b0;
                        iowr_en = 1'b0;
                        next_state = ret_state;
                        end

            wait_state1:begin // wait state
                        // turn off vals
                        inc = 1'b0;
                        jmp = 1'b0;
                        call = 1'b0;
                        ret = 1'b0;
                        next_state = wait_state0;
                        end

            wait_state2:begin
                        next_state = wait_state1;
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

            rd0:        begin // read state 1
                        // set sram addr
                        memaddr = regdata_rda;

                        // wait 1 and ret
                        next_state = wait_state0;
                        ret_state = rd1;
                        end

            rd1:        begin
                        // set reg input to sram out
                        regaddr_wr = opcode_q[3:2];
                        regdata_wr = memdata_o;

                        // set write en
                        regwr_en = 1'b1;

                        // wait and end write en
                        next_state = wait_state1;
                        ret_state = idle;

                        end
            
            wrio0:      begin
                        // set sram address
                        memaddr = regdata_rda;

                        // wait 1 
                        next_state = wait_state0;
                        ret_state = wrio1;
                        end

            wrio1:      begin
                        // enable io wr
                        iowr_en = 1'b1;

                        // wait 1 and disable
                        next_state = wait_state0;
                        ret_state = idle;
                        end

            jmp0:       begin
                        // inc wait 2
                        pcaddr_in = inst;
                        inc = 1'b1;

                        // wait 2 ret to jmp 1
                        next_state = wait_state1;
                        ret_state = jmp1;
                        end
            
            jmp1:       begin
                        // jmp
                        jmp = 1'b1;

                        // wait 2 ret to idle
                        next_state = wait_state1;
                        ret_state = idle;
                        end

            jmpc:       begin
                        // check opcode for value to check
                        if ((opcode_q[0] && alu_no) || (opcode_q[1] && alu_zo) || (opcode_q[2] && alu_co)) begin // jmp
                            next_state = jmp0;
                        end else begin // inc and return
                            inc = 1'b1;
                            next_state = wait_state1;
                            ret_state = idle;
                        end
                        end

            call0:      begin
                        // inc wait 2
                        pcaddr_in = inst;
                        inc = 1'b1;

                        // wait 2 ret to call 1
                        next_state = wait_state1;
                        ret_state = call1;

                        end

            call1:      begin
                        // call
                        call = 1'b1;

                        // wait 2 ret to idle
                        next_state = wait_state1;
                        ret_state = idle;
                        end

            ret0:        begin
                        // ret
                        ret = 1'b1;

                        // wait 2 ret to idle
                        next_state = wait_state1;
                        ret_state = idle;
                        end

            brk:        begin
                        // never leave
                        // ever
                        end

            alu0:       begin
                        // set alu inputs
                        alu_opcode = opcode_q;
                        alu_ci = alu_co;
                        aludata_rd = regdata_rda;
                        aludata_rr = regdata_rdb;
                        
                        // wait and go to mult0 or alu1
                        next_state = wait_state2;
                        case(opcode_q)
                            8'b0110????:    ret_state = mult0;
                            default:        ret_state = alu1;
                        endcase
                        end
            
            alu1:       begin
                        // set reg inputs
                        regaddr_wr = opcode_q[3:2];
                        regdata_wr = aludata_o[7:0];

                        // set write en
                        regwr_en = 1'b1;

                        // wait and end write en
                        next_state = wait_state1;
                        ret_state = idle;
                        end

            mult0:      begin
                        // set reg inputs
                        regaddr_wr = opcode_q[3:2];
                        regdata_wr = aludata_o[7:0];

                        // set write en
                        regwr_en = 1'b1;

                        // wait and end write en
                        next_state = wait_state1;
                        ret_state = mult1;
                        end

            mult1:      begin
                        // set reg inputs
                        regaddr_wr = opcode_q[1:0];
                        regdata_wr = aludata_o[15:8];

                        // set write en
                        regwr_en = 1'b1;

                        // wait and end write en
                        next_state = wait_state1;
                        ret_state = idle;
                        end
        endcase
    end
endmodule
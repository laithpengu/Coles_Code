module proj1_alu (
    input  logic        clk,
    input  logic        rst,
    input  logic [7:0]  data_rd,
    input  logic [7:0]  data_rr,
    input  logic        ci,
    input  logic [7:0]  opcode,
    output logic [15:0] data_o,
    output logic        co,
    output logic        no,
    output logic        zo);
    logic [15:0]    data_o_d;
    logic [15:0]    data_o_q;
    logic [7:0]     data_rd_d;
    logic [7:0]     data_rd_q;
    logic [7:0]     data_rr_d;
    logic [7:0]     data_rr_q;
    logic [7:0]     opcode_d;
    logic [7:0]     opcode_q;    
    logic           ci_d, ci_q;
    logic           co_d, co_q;
    logic           no_d, no_q;
    logic           zo_d, zo_q;

    // continually assign outputs
    assign data_o       = data_o_q;
    assign co           = co_q;
    assign no           = no_q;
    assign zo           = zo_q;
    assign ci_d         = ci;
    assign data_rd_d    = data_rd;
    assign data_rr_d    = data_rr;
    assign opcode_d     = opcode;

    always_ff @(posedge clk or posedge rst) // ff for all logic in and out
        begin
            if (rst) begin
                data_o_q    <= 16'b0;
                data_rd_q   <= 8'b0;
                data_rr_q   <= 8'b0;
                opcode_q    <= 8'b0;
                ci_q        <= 1'b0;
                co_q        <= 1'b0;
                no_q        <= 1'b0;
                zo_q        <= 1'b0;
            end else begin
                data_o_q    <= data_o_d;
                data_rd_q   <= data_rd_d;
                data_rr_q   <= data_rr_d;
                opcode_q    <= opcode_d;
                ci_q        <= ci_d;
                co_q        <= co_d;
                no_q        <= no_d;
                zo_q        <= zo_d;
            end
        end

    always_comb begin
        if (opcode_q === 8'b0000XX00) begin // lsl
            data_o_d[15:8]  <= 8'b0;
            data_o_d[7:1]   <= data_rd_q[6:0];
            data_o_d[0]     <= 0;
            zo_d            <= !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            <= data_o_d[7];
            co_d            <= data_rd_q[7];
        end else if (opcode_q === 8'b0000XX01) begin // asr
            data_o_d[15:8]  <= 8'b0;
            data_o_d[7]     <= data_rd_q[7];
            data_o_d[6:0]   <= data_rd_q[7:1];
            zo_d            <= !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            <= data_o_d[7];
            co_d            <= data_rd_q[0];
        end else if (opcode_q === 8'b0000XX10) begin // rol
            data_o_d[15:8]  <= 8'b0;
            data_o_d[7:1]   <= data_rd_q[6:0];
            data_o_d[0]     <= ci_q;
            zo_d            <= !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            <= data_o_d[7];
            co_d            <= data_rd_q[7];
        end else if (opcode_q === 8'b0000XX11) begin // ror
            data_o_d[15:8]  <= 8'b0;
            data_o_d[7]     <= ci_q;
            data_o_d[6:0]   <= data_rd_q[7:1];
            zo_d            <= !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            <= data_o_d[7];
            co_d            <= data_rd_q[0];
        end else if (opcode_q === 8'b0100XXXX) begin // mult
            data_o_d        <= data_rd_q * data_rr_q;
            zo_d            <= !data_o_d[15] & !data_o_d[14] & !data_o_d[13] & !data_o_d[12] & !data_o_d[11] & !data_o_d[10] & !data_o_d[9] & !data_o_d[8] & !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            co_d            <= data_o_d[15];
            co_d            = 0;
        end else if (opcode_q === 8'b1000XXXX) begin // and
            data_o_d[15:8]  = 8'b0;
            data_o_d[7:0]   = data_rd_q & data_rr_q;
            zo_d            = 0;
            no_d            = 0;
            co_d            = 0;
        end else if (opcode_q === 8'b1001XXXX) begin // or
            data_o_d[15:8]  = 8'b0;
            data_o_d[7:0]   = data_rd_q | data_rr_q;
            zo_d            = 0;
            no_d            = 0;
            co_d            = 0;
        end else if (opcode_q === 8'b1010XXXX) begin // xor
            data_o_d[15:8]  = 8'b0;
            data_o_d[7:0]   = data_rd_q ^ data_rr_q;
            zo_d            = 0;
            no_d            = 0;
            co_d            = 0;
        end else if (opcode_q === 8'b1011XX00) begin // neg
            data_o_d[15:8]  = 8'b0;
            data_o_d[7:0]   = data_rd_q ^ 8'b111111111;
            data_o_d[7:0]   = data_o_d[7:0] + 1;
            zo_d            = 0;
            no_d            = 0;
            co_d            = 0;
        end else if (opcode_q === 8'b1100XXXX) begin // add
            data_o_d[15:8]  = 16'b0;
            data_o_d[7:0]   = data_rd_q + data_rr_q;
            zo_d            = !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            = data_o_d[7];
            co_d            = (data_rd_q[7] & data_rr_q[7]) | (data_rd_q[7] & !data_o_d[7]) | (data_rr_q[7] & !data_o_d[7]);
        end else if (opcode_q === 8'b1101XXXX) begin // addc
            data_o_d[15:8]  = 16'b0;
            data_o_d[7:0]   = data_rd_q + data_rr_q + ci_q;
            zo_d            = !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            = data_o_d[7];
            co_d            = (data_rd_q[7] & data_rr_q[7]) | (data_rd_q[7] & !data_o_d[7]) | (data_rr_q[7] & !data_o_d[7]);
        end else if (opcode_q === 8'b1110XXXX) begin // sub
            data_o_d[15:8]  = 16'b0;
            data_o_d[7:0]   = data_rd_q - data_rr_q;
            zo_d            = !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            = data_o_d[7];
            co_d            = (!data_rd_q[7] & data_rr_q[7]) | (!data_rd_q[7] & data_o_d[7]) | (data_rr_q[7] & data_o_d[7]);
        end else if (opcode_q === 8'b1111XXXX) begin // subc
            data_o_d[15:8]  = 16'b0;
            data_o_d[7:0]   = data_rd_q - data_rr_q - ci;
            zo_d            = !data_o_d[7] & !data_o_d[6] & !data_o_d[5] & !data_o_d[4] & !data_o_d[3] & !data_o_d[2] & !data_o_d[1] & !data_o_d[0];
            no_d            = data_o_d[7];
            co_d            = (!data_rd_q[7] & data_rr_q[7]) | (!data_rd_q[7] & data_o_d[7]) | (data_rr_q[7] & data_o_d[7]);
        end
    end
endmodule
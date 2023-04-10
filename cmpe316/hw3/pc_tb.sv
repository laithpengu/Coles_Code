module pc_tb();

    logic           clk = 0;
    logic           rst;
    logic           inc;
    logic           jmp;
    logic           call;
    logic           ret;      
    int           i;  
    logic   [7:0]   sw;
    logic   [7:0]   inst_o;

    pc_wrapper pc_wrapper (    
        .clk(clk),
        .BTNR(rst),
        .BTNC(inc),
        .BTNL(jmp),
        .BTNU(call),
        .BTND(ret),        
        .sw(sw),
        .inst_o(inst_o)
    );

    initial begin
        forever #5ns clk = !clk;
    end

    initial begin
        // reset test
        rst = 1'b1;
        inc = 1'b0;
        jmp = 1'b0;
        call = 1'b0;
        ret = 1'b0;
        sw = 8'b0;
        @(negedge clk);
        rst = 1'b0;
        repeat (2) @(negedge clk);

        // inc test (Increment to 256 with output 10000110)
        for (i=0; i < 256; i=i+1) begin
            @(negedge clk);
            inc = 1'b1;

           repeat (2) @(negedge clk);
            inc = 1'b0;
        end

        @(negedge clk);
        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;
        @(negedge clk);

        // jmp test (Jump to 00100001 with output 00100111)
        sw = 8'b00100000;
        jmp = 1'b1;
        repeat (2) @(negedge clk);
        jmp = 1'b0;
        repeat (2) @(negedge clk);

        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;
        @(negedge clk);

        // call and return test (Call to 00100000 with output 00100111 and return to 00000010 with output 00001000)
        sw = 8'b00100000;
        call = 1'b1;
        repeat (2) @(negedge clk);
        call = 1'b0;
        repeat (2) @(negedge clk);
        ret = 1'b1;
        repeat (2) @(negedge clk);
        ret = 1'b0;
        
    end

endmodule
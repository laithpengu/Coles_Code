module spconverter(
    input   logic clk,
    input   logic rst
    input   logic width
    output  logic out);


    logic [3:0]         count;
    logic [width - 1:0] pout;




    always_ff @(posedge clk)
        begin
            if (count == width - 1) begin
                
            end else begin 
                pout[]
                count = count + 1;
            end 
        end



endmodule
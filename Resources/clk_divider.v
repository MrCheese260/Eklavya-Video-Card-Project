
module clk_divider(
    input clk,
    output reg new_clk
    );
    reg [1:0] temp = 2'd0;
    reg temp1 = 0;
    always @ (posedge clk) begin
        temp <= temp + 1;
        if (temp1 == 0) begin
            new_clk <= 0;
            temp1 <= 1;
        end
        else if (temp == 2'd1) begin
            new_clk <= ~new_clk;
            temp <= 2'd0;
        end
     end
endmodule

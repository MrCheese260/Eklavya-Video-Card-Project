
module clk_divider(
    input clk,
    output reg new_clk
    );
    reg [6:0] temp = 7'd0;
    reg temp1 = 0;
    always @ (posedge clk) begin
        temp <= temp + 1;
        if (temp1 == 0) begin
            new_clk <= 0;
            temp1 <= 1;
        end
        else if (temp == 7'd83) begin
            new_clk <= ~new_clk;
            temp <= 7'd0;
        end
     end
endmodule

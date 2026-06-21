module pc(
    input clk,
    input rst,
    input [31:0] pc_nxt,
    output reg [31:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'h00000000;
        else
            pc <= pc_nxt;
    end
endmodule

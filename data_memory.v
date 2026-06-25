module data_memory(
        input clk,
        input memread,memwrite,
        input [31:0] address,
        input [31:0] writedata,
        output [31:0] readdata
    );
    
    reg [31:0] mem [0:255];
    
    always @(posedge clk) begin
        if (memwrite) begin
            mem[address[9:2]] <= writedata;
        end
    end
    
    assign readdata= (memread) ? mem[address[9:2]] : 32'b0;
endmodule

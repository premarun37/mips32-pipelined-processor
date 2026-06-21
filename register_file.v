module register_file (
    input clk,
    input regwrite,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input [31:0] writedata,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    // 32 registers, each 32-bit
    reg [31:0] regfile [0:31];

    integer i;
    
    // Initialize ALL registers to 0
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] = 32'h00000000;
        end
        $display("Register File: Initialized all 32 registers to 0");
    end

    // WRITE: synchronous (on clock edge)
    always @(posedge clk) begin
        if (regwrite && rd != 5'b00000) begin
            regfile[rd] <= writedata;
            $display("[%0t] RegFile Write: R%0d <= 0x%h (%0d)", 
                     $time, rd, writedata, writedata);
        end
    end

    // READ: combinational (always immediate)
    // $zero (R0) always reads as 0
    assign read_data1 = (rs == 5'b00000) ? 32'h00000000 : regfile[rs];
    assign read_data2 = (rt == 5'b00000) ? 32'h00000000 : regfile[rt];

endmodule

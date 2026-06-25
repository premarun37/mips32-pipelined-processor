module control_unit (
    input  [5:0] opcode,

    output reg regwrite,
    output reg regdst,
    output reg alusrc,
    output reg branch,
    output reg memread,
    output reg memwrite,
    output reg memtoreg,
    output reg [1:0] aluop
);

    always @(*) begin
        // Default values (safe)
        regwrite = 0;
        regdst   = 0;
        alusrc   = 0;
        branch   = 0;
        memread = 0;
        memwrite= 0;
        memtoreg= 0;
        aluop    = 2'b00;

        case (opcode)

            6'b000000: begin   // R-type
                regwrite = 1;
                regdst   = 1;
                alusrc   = 0;
                aluop    = 2'b10;
            end

            6'b100011: begin   // lw
                regwrite = 1;
                regdst   = 0;
                alusrc   = 1;
                memread = 1;
                memtoreg= 1;
                aluop    = 2'b00;
            end

            6'b101011: begin   // sw
                regwrite = 0;
                alusrc   = 1;
                memwrite= 1;
                aluop    = 2'b00;
            end

            6'b000100: begin   // beq
                branch   = 1;
                alusrc   = 0;
                aluop    = 2'b01;
            end

            6'b001000: begin   // addi
                regwrite = 1;
                regdst   = 0;
                alusrc   = 1;
                aluop    = 2'b00;
            end
	default : begin
		
	end
        endcase
    end

endmodule

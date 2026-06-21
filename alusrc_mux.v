module alusrc_mux (
    input  [31:0] reg_data2,   // Read data from rt
    input  [31:0] imm_ext,      // Sign-extended immediate
    input         alusrc,       // Control signal
    output [31:0] alu_in2       // Second ALU operand
);

    // If ALUSrc = 0 → use register
    // If ALUSrc = 1 → use immediate
    assign alu_in2 = (alusrc) ? imm_ext : reg_data2;

endmodule

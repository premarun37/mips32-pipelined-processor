module instruction_memory(
    input [31:0] pc,
    output [31:0] instruction
);

    reg [31:0] mem [0:255];
    
    integer i;
    initial begin
        // Initialize ALL memory to NOP instruction (add $0, $0, $0)
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000000; // NOP
        end
        
        // Load test program
        mem[0] = 32'h20080005; // addi $t0, $zero, 5
        mem[1] = 32'h20090003; // addi $t1, $zero, 3
        mem[2] = 32'h01095020; // add  $t2, $t0, $t1
        mem[3] = 32'h11090001; // beq  $t0, $t1, +1 (branch not taken)
        mem[4] = 32'h012A5820; // add  $t3, $t1, $t2
        
        // Add more NOPs to prevent X propagation
        mem[5] = 32'h00000000; // NOP
        mem[6] = 32'h00000000; // NOP
        mem[7] = 32'h00000000; // NOP
        
        $display("=== Instruction Memory Initialized ===");
        $display("mem[0] = %h (addi $t0, $zero, 5)", mem[0]);
        $display("mem[1] = %h (addi $t1, $zero, 3)", mem[1]);
        $display("mem[2] = %h (add $t2, $t0, $t1)", mem[2]);
        $display("mem[3] = %h (beq $t0, $t1, +1)", mem[3]);
        $display("mem[4] = %h (add $t3, $t1, $t2)", mem[4]);
    end

    // Word-aligned access
    assign instruction = mem[pc[9:2]];

endmodule

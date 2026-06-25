module tb_mips32_pipeline();
	reg clk ,rst;
	
	mips32_pipeline uut(
		.clk(clk),
		.rst(rst)
		);
	
	always #5 clk = ~clk;
	
	always @(posedge clk)
    	$display("Time=%0t PC=%h Instr=%h WB_Reg=%0d WB_Data=%h", $time, uut.pc, uut.if_id_instr, uut.wb_rd, uut.wb_write_data);
	
	initial begin
		clk = 0;
		rst = 1;
		
		#10;
		rst = 0;
		
		#500;
		$finish;
	end
	
	initial begin
        	$dumpfile("mips32.vcd");
        	$dumpvars(0, tb_mips32_pipeline);
    	end
	
endmodule


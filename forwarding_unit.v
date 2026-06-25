module forwarding_unit(
	input [4:0] id_ex_rs, id_ex_rt,
	input [4:0] ex_mem_rd, 
	input ex_mem_reg_write,
	input [4:0] mem_wb_rd, 
	input mem_wb_reg_write,
	
	output reg [1:0] forward_A, forward_B
	);
		
	always @(*) begin
		forward_A = 2'b0;
		forward_B = 2'b0;
		
		if (ex_mem_reg_write == 1'b1 && ex_mem_rd != 5'b0 && ex_mem_rd == id_ex_rs) begin
			forward_A = 2'b01;
		end
		
		else if (mem_wb_reg_write == 1'b1 && mem_wb_rd != 5'b0 && mem_wb_rd == id_ex_rs) begin
			forward_A = 2'b10;
		end
		
		if (ex_mem_reg_write == 1'b1 && ex_mem_rd != 5'b0 && ex_mem_rd == id_ex_rt) begin
			forward_B = 2'b01;
		end
		
		else if (mem_wb_reg_write == 1'b1 && mem_wb_rd != 5'b0 && mem_wb_rd == id_ex_rt) begin
			forward_B = 2'b10;
		end
	end
	
endmodule	

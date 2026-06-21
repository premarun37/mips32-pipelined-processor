module mem_wb(
	input clk, rst, 
	input [31:0] memory_data_in, alu_result_in, 
	input [4:0] reg_dest_in,
	input reg_write_in, mem_to_reg_in,
	output reg [31:0] memory_data_out, alu_result_out, wb_data_out,
	output reg [4:0] reg_dest_out,
	output reg reg_write_out, mem_to_reg_out
	);
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			memory_data_out <= 32'b0;
			alu_result_out <= 32'b0;
			reg_dest_out <= 5'b0;
			reg_write_out <= 1'b0;
			mem_to_reg_out <= 1'b0;
		end
		else begin
			memory_data_out <= memory_data_in;
			alu_result_out <= alu_result_in;
			reg_dest_out <= reg_dest_in;
			reg_write_out <= reg_write_in;
			mem_to_reg_out <= mem_to_reg_in;
		end
	end
	
	assign wb_data_out = (mem_to_reg_out) ? memory_data_out : alu_result_out;
	
endmodule

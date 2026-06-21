module id_ex(
	input clk, rst,
	input [31:0] read_data_1_in, read_data_2_in, imm_in,
	input [4:0] rs_in, rt_in, rd_in,
	input reg_write_in, reg_dst_in, alu_src_in, mem_read_in, mem_write_in, mem_to_reg_in,
	input [1:0] alu_op_in,
	input [5:0] funct_in,
	output reg [31:0] read_data_1_out, read_data_2_out, imm_out,
	output reg [4:0] rs_out, rt_out, rd_out,
	output reg reg_write_out, reg_dst_out, alu_src_out, mem_read_out, mem_write_out, mem_to_reg_out,
	output reg [1:0] alu_op_out,
	output reg [5:0] funct_out
	);
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			read_data_1_out <= 32'b0;
			read_data_2_out <= 32'b0;
			imm_out <= 32'b0;
			
			reg_write_out <= 1'b0; 
			reg_dst_out <= 1'b0; 
			alu_src_out <= 1'b0; 
			mem_read_out <= 1'b0; 
			mem_write_out <= 1'b0; 
			mem_to_reg_out <= 1'b0;
			alu_op_out <= 1'b0;
			funct_out <= 1'b0;
			
			rs_out <= 5'b0;
			rt_out <= 5'b0;
			rd_out <= 5'b0;
		end
		else begin
			read_data_1_out <= read_data_1_in;
			read_data_2_out <= read_data_2_in;
			imm_out <= imm_in;
			
			reg_write_out <= reg_write_in; 
			reg_dst_out <= reg_dst_in; 
			alu_src_out <= alu_src_in; 
			mem_read_out <= mem_read_in; 
			mem_write_out <= mem_write_in; 
			mem_to_reg_out <= mem_to_reg_in;
			alu_op_out <= alu_op_in;
			funct_out <= funct_in;
			
			rs_out <= rs_in;
			rt_out <= rt_in;
			rd_out <= rd_in;
		end
	end
endmodule
	

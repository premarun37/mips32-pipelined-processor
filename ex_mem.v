module ex_mem(
	input clk, rst,
	input [31:0] alu_in, write_data_in,
	input [4:0] reg_dest_in,
	input mem_read_in, mem_write_in, reg_write_in, mem_to_reg_in,
	output reg [31:0] alu_out, write_data_out,
	output reg [4:0] reg_dest_out,
	output reg mem_read_out, mem_write_out, reg_write_out, mem_to_reg_out
	);
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			alu_out <= 32'b0;
			reg_dest_out <= 5'b0;
			write_data_out <= 32'b0;
			mem_read_out <= 1'b0;
			mem_write_out <= 1'b0;
			reg_write_out <= 1'b0;
			mem_to_reg_out <= 1'b0;
		end
		else begin
			alu_out <= alu_in;
			reg_dest_out <= reg_dest_in;
			write_data_out <= write_data_in;
			mem_read_out <= mem_read_in;
			mem_write_out <= mem_write_in;
			reg_write_out <= reg_write_in;
			mem_to_reg_out <= mem_to_reg_in;
		end
	end
endmodule

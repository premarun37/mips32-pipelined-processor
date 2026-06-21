module mips32_pipeline(
	input clk, rst
	);
	
	wire [31:0] pc, next_pc;
	wire [31:0] instruction;
	wire [31:0] if_id_instr, if_id_pc_4, if_id_pc_plus_4, if_id_instruction;
	
	assign if_id_pc_plus_4 = pc + 4;
	assign next_pc = if_id_pc_plus_4;
	
	//1st stage - Starts
	pc pc0(
		.clk(clk),
		.rst(rst),
		
		.pc_nxt(next_pc),
		.pc(pc)
		);
	
	instruction_memory instruction_memory0(	
		.pc(pc),
		.instruction(instruction)
		);
	
	if_id if_id0(
		.clk(clk),
		.rst(rst),
		
		.pc_in(if_id_pc_plus_4),
		.instr_in(instruction),
		
		.pc_out(if_id_pc_4), //stored in reg
		.instr_out(if_id_instr) //stored in reg
		
		);
			
	//1st stage - Ends
	
	//2nd stage - Starts
	wire [5:0] opcode;
    	wire reg_write, reg_dst, alu_src, branch, mem_read, mem_write, mem_to_reg;
    	wire [1:0] alu_op;
    	
    	wire [4:0] rs, rt, rd;
    	wire [5:0] funct;
    	wire [31:0] write_data, read_data_1, read_data_2;
    	
    	wire [15:0] imme_in;
	wire [31:0] imme_out;
    	
    	assign opcode = if_id_instr[31:26];
    	assign rs = if_id_instr[25:21];
    	assign rt = if_id_instr[20:16];
    	assign rd = if_id_instr[15:11];
    	assign funct = if_id_instr[5:0];
    	assign imme_in = if_id_instr[15:0];
    	
    	
    	
    	control_unit control_unit0(
    		.opcode(opcode),
    		
    		.regwrite(reg_write), 
    		.regdst(reg_dst), 
    		.alusrc(alu_src), 
    		.branch(branch), 
    		.memread(mem_read), 
    		.memwrite(mem_write), 
    		.memtoreg(mem_to_reg),
    		.aluop(alu_op)
    		
    		); 
    			
	register_file register_file0(
		.clk(clk),
		
		.rs(rs),
		.rt(rt),
		.rd(wb_rd),
		
		.writedata(mem_wb_wb_data_out), //'write_data', 'reg_write', 'rd' are generally used but after the 'write_back' stage we need to use the data from the 5th stage
		.read_data1(read_data_1),
		.read_data2(read_data_2),
		
		.regwrite(wb_reg_write)
		);
			
	sign_extend sign_extend0(
		.imm_in(imme_in),
		.imm_out(imme_out)
		); 
		
	wire [4:0] if_id_rs_in, if_id_rt_in, if_id_rd_in, if_id_rs_out, if_id_rt_out, if_id_rd_out;
	wire [31:0] if_id_read_data_1_in, if_id_read_data_2_in, if_id_imm_in, if_id_read_data_1_out, if_id_read_data_2_out, if_id_imm_out;
	
	wire if_id_reg_write_in, if_id_reg_dst_in, if_id_alu_src_in, if_id_mem_read_in, if_id_mem_write_in, if_id_mem_to_reg_in;
	wire [1:0] if_id_alu_op_in;
	wire [5:0] if_id_funct_in;
	
	wire if_id_reg_write_out, if_id_reg_dst_out, if_id_alu_src_out, if_id_mem_read_out, if_id_mem_write_out, if_id_mem_to_reg_out;
	wire [1:0] if_id_alu_op_out;
	wire [5:0] if_id_funct_out;
	
	assign if_id_rs_in = rs;
	assign if_id_rt_in = rt;
	assign if_id_rd_in = rd;
	assign if_id_funct_in = funct;
	
	assign if_id_read_data_1_in = read_data_1;
	assign if_id_read_data_2_in = read_data_2;
	
	assign if_id_imm_in = imme_out;
	
	assign if_id_reg_write_in = reg_write;
	assign if_id_reg_dst_in = reg_dst;
	assign if_id_alu_src_in = alu_src;
	assign if_id_mem_read_in = mem_read;
	assign if_id_mem_write_in = mem_write;
	assign if_id_mem_to_reg_in = mem_to_reg;
	assign if_id_alu_op_in = alu_op;
		
	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		
		.rs_in(if_id_rs_in), 
		.rt_in(if_id_rt_in), 
		.rd_in(if_id_rd_in), 
		
		.imm_in(if_id_imm_in),
		
		.read_data_1_in(if_id_read_data_1_in), 
		.read_data_2_in(if_id_read_data_2_in), 
		
		.reg_write_in(if_id_reg_write_in), 
		.reg_dst_in(if_id_reg_dst_in), 
		.alu_src_in(if_id_alu_src_in), 
		.mem_read_in(if_id_mem_read_in), 
		.mem_write_in(if_id_mem_write_in), 
		.mem_to_reg_in(if_id_mem_to_reg_in),
		.alu_op_in(if_id_alu_op_in),
		.funct_in(if_id_funct_in),
		
		.rs_out(if_id_rs_out), 
		.rt_out(if_id_rt_out), 
		.rd_out(if_id_rd_out),
		
		.read_data_1_out(if_id_read_data_1_out), 
		.read_data_2_out(if_id_read_data_2_out),
		
		.imm_out(if_id_imm_out),
		
		.reg_write_out(if_id_reg_write_out), 
		.reg_dst_out(if_id_reg_dst_out), 
		.alu_src_out(if_id_alu_src_out), 
		.mem_read_out(if_id_mem_read_out), 
		.mem_write_out(if_id_mem_write_out), 
		.mem_to_reg_out(if_id_mem_to_reg_out),
		.alu_op_out(if_id_alu_op_out),
		.funct_out(if_id_funct_out)	
		);
	//2nd stage - Ends
	
	//3rd stage - Starts
	wire [4:0] id_ex_rs, id_ex_rt, id_ex_rd, id_ex_write_reg;
	wire [31:0] id_ex_read_data_1, id_ex_read_data_2, id_ex_imm_out;
	wire [1:0] id_ex_alu_op;
	wire [5:0] id_ex_funct;
	wire [3:0] id_ex_alu_ctrl;
	wire id_ex_zero, id_ex_alu_src, id_ex_reg_dst;
	wire [31:0] id_ex_alu_result, id_ex_alu_in2;
	
	assign id_ex_rs = if_id_rs_out;
	assign id_ex_rt = if_id_rt_out;
	assign id_ex_rd = if_id_rd_out;
	
	assign id_ex_read_data_1 = if_id_read_data_1_out;
	assign id_ex_read_data_2 = if_id_read_data_2_out;
	assign id_ex_imm_out = if_id_imm_out;
	
	assign id_ex_alu_op = if_id_alu_op_out;
	assign id_ex_funct = if_id_funct_out;
	
	assign id_ex_alu_src = if_id_alu_src_out;
	assign id_ex_reg_dst = if_id_reg_dst_out; 
	    
	alu_control alu_control0(
		.aluop(id_ex_alu_op),
		.funct(id_ex_funct),
		.alu_ctrl(id_ex_alu_ctrl)
		);
		
	alusrc_mux alusrc_mux0(
		.reg_data2(id_ex_read_data_2),
		.imm_ext(id_ex_imm_out),
		.alusrc(id_ex_alu_src),
		.alu_in2(id_ex_alu_in2)
		
		);
		
	alu alu0(
		.a(id_ex_read_data_1),
		.b(id_ex_alu_in2),
		.alu_ctrl(id_ex_alu_ctrl),
		.result(id_ex_alu_result),
		.zero(id_ex_zero)
		
		);
		
	regdst_mux regdst_mux0(
		.rt(id_ex_rt),
		.rd(id_ex_rd),
		.writereg(id_ex_write_reg),
		.regdst(id_ex_reg_dst)
		
		);
		
	wire [31:0] id_ex_alu_in, id_ex_write_data_in;
	wire [4:0] id_ex_reg_dest_in; 
	wire id_ex_mem_read_in, id_ex_mem_write_in, id_ex_reg_write_in, id_ex_mem_to_reg_in;
	wire [31:0] ex_mem_alu_out, ex_mem_write_data_out;
	wire [4:0] ex_mem_reg_dest_out;
	wire ex_mem_mem_read_out, ex_mem_mem_write_out, ex_mem_reg_write_out, ex_mem_mem_to_reg_out;
	
	assign id_ex_reg_dest_in = id_ex_write_reg;
	assign id_ex_mem_read_in = if_id_mem_read_out;
	assign id_ex_mem_write_in = if_id_mem_write_out;
	assign id_ex_reg_write_in = if_id_reg_write_out;
	assign id_ex_mem_to_reg_in = if_id_mem_to_reg_out;
	
	assign id_ex_alu_in = id_ex_alu_result;
	assign id_ex_write_data_in = id_ex_read_data_2;
	
	ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
		
		.alu_in(id_ex_alu_in),
		.reg_dest_in(id_ex_reg_dest_in),
		.write_data_in(id_ex_write_data_in),
		.mem_read_in(id_ex_mem_read_in),
		.mem_write_in(id_ex_mem_write_in),
		.reg_write_in(id_ex_reg_write_in),
		.mem_to_reg_in(id_ex_mem_to_reg_in),
		
		.alu_out(ex_mem_alu_out),
		.reg_dest_out(ex_mem_reg_dest_out),
		.write_data_out(ex_mem_write_data_out),
		.mem_read_out(ex_mem_mem_read_out),
		.mem_write_out(ex_mem_mem_write_out),
		.reg_write_out(ex_mem_reg_write_out),
		.mem_to_reg_out(ex_mem_mem_to_reg_out)
		
		);
	//3rd stage - Ends
	
	//4th stage - Starts
	wire ex_mem_mem_read, ex_mem_mem_write;
	wire [31:0] ex_mem_address, ex_mem_write_data, ex_mem_read_data;
	
	assign ex_mem_mem_read = ex_mem_mem_read_out;
	assign ex_mem_mem_write = ex_mem_mem_write_out;
	assign ex_mem_write_data = ex_mem_write_data_out;
	assign ex_mem_address = ex_mem_alu_out;
       
       	data_memory data_memory0(
       		.clk(clk),
       		
       		.memread(ex_mem_mem_read),
       		.memwrite(ex_mem_mem_write),
        	.address(ex_mem_address),
        	.writedata(ex_mem_write_data),
        	
        	.readdata(ex_mem_read_data)
       		);
       		
	wire [31:0] ex_mem_memory_data_in, ex_mem_alu_result_in; 
	wire [4:0] ex_mem_reg_dest_in;
	wire ex_mem_reg_write_in, ex_mem_mem_to_reg_in;
	wire [31:0] mem_wb_memory_data_out, mem_wb_alu_result_out, mem_wb_wb_data_out;
	wire [4:0] mem_wb_reg_dest_out;
	wire mem_wb_reg_write_out, mem_wb_mem_to_reg_out;
	
	assign ex_mem_memory_data_in = ex_mem_read_data;
	assign ex_mem_alu_result_in = ex_mem_address;
	assign ex_mem_reg_dest_in = ex_mem_reg_dest_out;
	assign ex_mem_reg_write_in = ex_mem_reg_write_out;
	assign ex_mem_mem_to_reg_in = ex_mem_mem_to_reg_out;
	
	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),
		
		.memory_data_in(ex_mem_memory_data_in),
		.alu_result_in(ex_mem_alu_result_in),
		.reg_dest_in(ex_mem_reg_dest_in),
		.reg_write_in(ex_mem_reg_write_in),
		.mem_to_reg_in(ex_mem_mem_to_reg_in),
				
		.memory_data_out(mem_wb_memory_data_out),
		.alu_result_out(mem_wb_alu_result_out),
		.reg_dest_out(mem_wb_reg_dest_out),
		.reg_write_out(mem_wb_reg_write_out),
		.mem_to_reg_out(mem_wb_mem_to_reg_out),
		.wb_data_out(mem_wb_wb_data_out)
		);
	//4th stage - Ends
	
	//5th stage - Starts
	wire wb_reg_write;
	wire [4:0] wb_rd;
	wire [31:0] wb_write_data;
	
	assign wb_reg_write = mem_wb_reg_write_out;
	assign wb_rd = mem_wb_reg_dest_out;
	assign wb_write_data = mem_wb_wb_data_out;
	
	//hereafter the register_file signals should be altered since the writeback stage result should be updated to register_file
	//5th stage -Ends
	

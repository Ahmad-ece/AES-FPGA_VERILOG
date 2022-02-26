	module top_level (clk, key_in, key_schedule);
	input clk;
	input [0:127] key_in ;
	output [0:1407] key_schedule ;
	integer index = 0;
	reg [7:0] key_in_reg [0:3][0:3];
	reg [7:0] key_in_reg_word_0 [0:3]; reg [7:0] key_in_reg_word_1 [0:3]; reg [7:0] key_in_reg_word_2 [0:3]; reg [7:0] key_in_reg_word_3 [0:3];
	reg  [7:0] key_schedule_reg [0:3][0:43];
	reg [0:31] temp_rot_word;
	reg [0:31] temp_subword;
	reg [0:31] temp_rcon;
	reg [0:31] temp_after_xor_with_rcon;
	reg [0:31] temp1;
	reg [0:7] temp1_word [0:3];
	reg [0:31] temp2;
	reg [0:7] temp2_word [0:3];
	reg [0:31] temp3;
	reg [7:0] temp3_word [0:3];
	reg [7:0] sbox [0:255];
	reg [0:31] rcon [1:10];
	
	integer i;
	integer j;
	
	initial begin
		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/sbox.mem",sbox);
		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/rcon.mem", rcon);
	end
	
	task automatic rot_word; 
	input [0:31] word_in ;
	output [0:31] word_out;
	reg [7:0] word_in_reg[0:3] ;
	reg [7:0] word_out_reg[0:3] ;
	integer i;
	
	
	begin
			word_in_reg[0] = word_in[0:7];
			word_in_reg[1] = word_in[8:15];
			word_in_reg[2] = word_in[16:23];
			word_in_reg[3] = word_in[24:31];
			
		for (i = 0; i < 4; i = i+1) begin
			word_out_reg [i] = word_in_reg [(i + 1)%4];
		end	
		
			word_out[0:7] = word_out_reg[0];
			word_out[8:15] = word_out_reg[1];
			word_out[16:23] = word_out_reg[2];
			word_out[24:31] = word_out_reg[3];
	end
	
	endtask
	
	task automatic sub_word;
		input [0:31] word_in;
		output [0:31] word_out;
		reg [7:0] word_in_reg [0:3];
		reg [7:0] word_out_reg [0:3];
		
		begin
		
			word_in_reg[0] = word_in[0:7];
			word_in_reg[1] = word_in[8:15];
			word_in_reg[2] = word_in[16:23];
			word_in_reg[3] = word_in[24:31];

			word_out_reg[0] = sbox[16*word_in[0:3]+word_in[4:7]];
			word_out_reg[1] = sbox[16*word_in[8:11]+word_in[12:15]];
			word_out_reg[2] = sbox[16*word_in[16:19]+word_in[20:23]];
			word_out_reg[3] = sbox[16*word_in[24:27]+word_in[28:31]];	
			
			word_out[0:7] = word_out_reg[0];
			word_out[8:15] = word_out_reg[1];
			word_out[16:23] = word_out_reg[2];
			word_out[24:31] = word_out_reg[3];
		
		end
		endtask
		
		task automatic xor_two_words;
		input [0:31] word_in1 ;
		input [0:31] word_in2 ;
		output [0:31] word_out ;
		reg [7:0] word_in1_reg [0:3] ;
		reg [7:0] word_in2_reg [0:3] ;
		reg [7:0] word_out_reg [0:3];
		integer i,j;
		begin
		
			word_in1_reg[0] = word_in1[0:7];
			word_in1_reg[1] = word_in1[8:15];
			word_in1_reg[2] = word_in1[16:23];
			word_in1_reg[3] = word_in1[24:31];
			
			word_in2_reg[0] = word_in2[0:7];
			word_in2_reg[1] = word_in2[8:15];
			word_in2_reg[2] = word_in2[16:23];
			word_in2_reg[3] = word_in2[24:31];


			for (i = 0; i < 4; i = i + 1) begin
				word_out_reg[i]  = word_in1_reg[i]  ^ word_in2_reg[i];
			end
			
			word_out[0:7] = word_out_reg[0];
			word_out[8:15] = word_out_reg[1];
			word_out[16:23] = word_out_reg[2];
			word_out[24:31] = word_out_reg[3];
			
		end
	endtask
		
		
		task automatic rcon_mem;
		input [3:0] key_schedule_index ;
		output [0:31] word_out;
		begin
			word_out = rcon[key_schedule_index];
		end
	endtask



	
	always @(posedge clk) begin
		if (index == 0) begin
			key_in_reg_word_0[0] = key_in[0:7];
			key_in_reg_word_0[1] = key_in[8:15];
			key_in_reg_word_0[2] = key_in[16:23];
			key_in_reg_word_0[3] = key_in[24:31];
			
			key_in_reg_word_1[0] = key_in[32:39];
			key_in_reg_word_1[1] = key_in[40:47];
			key_in_reg_word_1[2] = key_in[48:55];
			key_in_reg_word_1[3] = key_in[56:63];
			
			key_in_reg_word_2[0] = key_in[64:71];
			key_in_reg_word_2[1] = key_in[72:79];
			key_in_reg_word_2[2] = key_in[80:87];
			key_in_reg_word_2[3] = key_in[88:95];
			
			key_in_reg_word_3[0] = key_in[96:103];
			key_in_reg_word_3[1] = key_in[104:111];
			key_in_reg_word_3[2] = key_in[112:119];
			key_in_reg_word_3[3] = key_in[120:127];
		
			for(i=0;i<4;i=i+1) begin
				key_in_reg[i][0] = key_in_reg_word_0[i];
				key_in_reg[i][1] = key_in_reg_word_1[i];
				key_in_reg[i][2] = key_in_reg_word_2[i];
				key_in_reg[i][3] = key_in_reg_word_3[i];
			
			end
			
			for(i = 0; i<4 ;i=i+1) begin
				for(j = 0; j<4 ;j=j+1) begin
					key_schedule_reg[i][j] = key_in_reg[i][j];
				end
			end
		end
		
		else if (index>3 && index<44) begin
			for (j=0; j<4; j=j+1) begin
				temp1_word[j] = key_schedule_reg[j][index-1];
				temp2_word[j] = key_schedule_reg[j][index-4];
			end
			temp1[0:7] = temp1_word[0];
			temp1[8:15] = temp1_word[1];
			temp1[16:23] = temp1_word[2];
			temp1[24:31] = temp1_word[3];
			
			temp2[0:7] = temp2_word[0];
			temp2[8:15] = temp2_word[1];
			temp2[16:23] = temp2_word[2];
			temp2[24:31] = temp2_word[3];
			
			if (index%4 == 0) begin
				rot_word(temp1, temp_rot_word);
				sub_word(temp_rot_word, temp_subword);
				rcon_mem(index/4, temp_rcon);
				xor_two_words(temp_subword, temp_rcon, temp_after_xor_with_rcon);
				xor_two_words(temp_after_xor_with_rcon, temp2, temp3);
				end
			else xor_two_words(temp1, temp2, temp3);
			
			temp3_word[0] = temp3[0:7];
			temp3_word[1] = temp3[8:15];
			temp3_word[2] = temp3[16:23];
			temp3_word[3] = temp3[24:31];
			
			for(j = 0; j<4 ;j=j+1) begin
				key_schedule_reg[j][index] = temp3_word[j];
			end
		end
		index = index+1;
	end
	endmodule
	
	module tb();
	reg [0:127] key_in;
	wire [0:1407] key_schedule;
	reg clk;
	
	top_level t1 (clk, key_in, key_schedule);
	
	initial begin
		key_in = 128'h 2b7e151628aed2a6abf7158809cf4f3c;
		clk = 0;
		repeat(100) #100 clk=~clk;
		#100 $stop;
	end
	endmodule
	

//	module tb_sub_word();
//	reg [0:31] word_in ;
//	reg [0:31] word_out;
//	reg [7:0] sbox [0:15][0:15];
//		task automatic sub_word;
//		input [0:31] word_in;
//		output [0:31] word_out;
//		reg [7:0] word_in_reg [0:3];
//		reg [7:0] word_out_reg [0:3];
//		
//		begin
//		
//			word_in_reg[0] = word_in[0:7];
//			word_in_reg[1] = word_in[8:15];
//			word_in_reg[2] = word_in[16:23];
//			word_in_reg[3] = word_in[24:31];
//			
////			word_out_reg[0] = sbox[16*word_in[0:3] + word_in[4:7]];
////			word_out_reg[1] = sbox[16*word_in[8:11] + word_in[12:15]];
////			word_out_reg[2] = sbox[16*word_in[16:19] + word_in[20:23]];
////			word_out_reg[3] = sbox[16*word_in[24:27] + word_in[28:31]];	
//
//			word_out_reg[0] = sbox[word_in[0:3]][word_in[4:7]];
//			word_out_reg[1] = sbox[word_in[8:11]][word_in[12:15]];
//			word_out_reg[2] = sbox[word_in[16:19]][word_in[20:23]];
//			word_out_reg[3] = sbox[word_in[24:27]][word_in[28:31]];	
//			
//			word_out[0:7] = word_out_reg[0];
//			word_out[8:15] = word_out_reg[1];
//			word_out[16:23] = word_out_reg[2];
//			word_out[24:31] = word_out_reg[3];
//		
//		end
//		endtask
//
//	initial begin
//		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/sbox.mem",sbox);
//
//		word_in[0:7] = 8'h23;
//		word_in[8:15] = 8'hab;
//		word_in[16:23] = 8'h56;
//		word_in[24:31] = 8'h79;	
//	sub_word(word_in, word_out);
//	end
//	endmodule
//
//////////////////////////////////////////////////////////////////////////////

//module test_for_rot();
//	reg [0:31] word_in;
//	reg [0:31] word_out;
//	
//	task automatic rot_word; 
//	input [0:31] word_in ;
//	output [0:31] word_out;
//	reg [7:0] word_in_reg[0:3] ;
//	reg [7:0] word_out_reg[0:3] ;
//	integer i;
//	
//	begin
//			word_in_reg[0] = word_in[0:7];
//			word_in_reg[1] = word_in[8:15];
//			word_in_reg[2] = word_in[16:23];
//			word_in_reg[3] = word_in[24:31];
//			
//		for (i = 0; i < 4; i = i+1) begin
//			word_out_reg [i] = word_in_reg [(i + 1)%4];
//		end	
//		
//			word_out[0:7] = word_out_reg[0];
//			word_out[8:15] = word_out_reg[1];
//			word_out[16:23] = word_out_reg[2];
//			word_out[24:31] = word_out_reg[3];
//	end
//	
//	endtask
//
//	
//	initial begin
//		word_in[0:7] = 8'h01;
//		word_in[8:15] = 8'h02;
//		word_in[16:23] = 8'h03;
//		word_in[24:31] = 8'h04;
//		rot_word (word_in, word_out);
//		
//		#100 $stop;
//	end
//	
//	endmodule
//	
//*/
//
//////////////////////////////////////////////////////////////////////////////




//
//module tb_rcon_mem();
//	reg [3:0] key_schedule_index ;
//	reg [7:0] word_out;
//	reg [7:0] word_out_reg;
//	reg [7:0] rcon [1:10];
//	integer i;
//	task automatic rcon_mem;
//		input [3:0] key_schedule_index ;
//		output [7:0] word_out;
//		integer key_schedule_index_int;
//		begin
//			word_out = rcon[key_schedule_index];
//		end
//	endtask
//	
//	initial begin
//		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/rcon.mem", rcon);
//		i = 5;
//			rcon_mem(i, word_out);
//
//	end
//
//
//endmodule
//
////////////////////////////////////////////////////////////////////////////
//module tb_for_xor_task();
//	reg [0:31] word_in1 ;
//	reg [0:31] word_in2 ;
//	reg [0:31] word_out ;
//	
//	task automatic xor_two_words;
//		input [0:31] word_in1 ;
//		input [0:31] word_in2 ;
//		output [0:31] word_out ;
//		reg [7:0] word_in1_reg [0:3] ;
//		reg [7:0] word_in2_reg [0:3] ;
//		reg [7:0] word_out_reg [0:3];
//		integer i,j;
//		begin
//		
//			word_in1_reg[0] = word_in1[0:7];
//			word_in1_reg[1] = word_in1[8:15];
//			word_in1_reg[2] = word_in1[16:23];
//			word_in1_reg[3] = word_in1[24:31];
//			
//			word_in2_reg[0] = word_in2[0:7];
//			word_in2_reg[1] = word_in2[8:15];
//			word_in2_reg[2] = word_in2[16:23];
//			word_in2_reg[3] = word_in2[24:31];
//
//
//			for (i = 0; i < 4; i = i + 1) begin
//				word_out_reg[i]  = word_in1_reg[i]  ^ word_in2_reg[i];
//			end
//			
//			word_out[0:7] = word_out_reg[0];
//			word_out[8:15] = word_out_reg[1];
//			word_out[16:23] = word_out_reg[2];
//			word_out[24:31] = word_out_reg[3];
//			
//		end
//	endtask
//	
//	initial begin
//		word_in1[0:7] = 8'h12;
//		word_in1[8:15] = 8'h56;
//		word_in1[16:23] = 8'h56;
//		word_in1[24:31] = 8'h34;
//		word_in2[0:7] = 8'h9a;
//		word_in2[8:15] = 8'h65;
//		word_in2[16:23] = 8'hdd;
//		word_in2[24:31] = 8'h12;
//		xor_two_words(word_in1, word_in2, word_out);
//		#100 $finish;
//		end
//		
//endmodule
////////////////////////////////////////////////////////////////////////////////////////
//
//
///*module top_level (state_in, state_out);
//	input [7:0] state_in [0:3][0:3];
//	output [7:0] state_out [0:3][0:3];
//	reg [7:0] state_out_reg [0:3][0:3];
//	
//	task automatic shift_row; 
//	input [7:0] state_in [0:3][0:3];
//	output [7:0] state_out [0:3][0:3];
//	integer i;
//	
//	begin
//		state_out[0] = state_in[0];
//		for (i = 0; i<4; i = i + 1) begin
//			state_out[1][i] = state_in[1][(i + 1)%4];
//		end
//		
//		for(i = 0; i<4; i = i+1) begin
//			state_out[2][i] = state_in[2][(i + 2)%4];
//		end
//		
//		for(i = 0; i<4; i = i+1) begin
//			state_out[3][i] = state_in[3][(i + 3)%4];
//		end
//		
//	end
//	
//	endtask
//	
//	always @(*) begin
//		shift_row(state_in, state_out_reg);
//		
//	end
//	assign state_out = state_out_reg;
//	
//	
//	endmodule
//	
//module test_for_shift_rows();
//	reg [7:0] state_in [0:3][0:3];
//	reg [7:0] state_out [0:3][0:3];
//	
//	top_level t1 (state_in, state_out);
//	
//	initial begin
//	int i,j = 0;
//		for(i = 0; i <4; i++) begin
//			for (j = 0 ; j<4 ; j++) begin
//				state_in[i][j] = i * j;
//		
//			end
//		end
//		#100 $finish;
//	end
//	
//	endmodule*/
//	
//	
//	
//	

//	
//	module tb ();
//	reg [7:0] key_in [0:3][0:3];
//	reg [7:0] key_schedule [0:3][0:43];
//	reg  [7:0] key_schedule_reg [0:3][0:43];
//	int i;
//	initial  begin
//		for(i = 0; i<4 ; i++) begin
//			$display("%d", i);
//			key_schedule_reg[i][0] = key_in[i][0];
//		end
//		$display("%d", i);
//	
//	
//	end
//		assign key_schedule = key_schedule_reg;
//
//	endmodule*/
//	

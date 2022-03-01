	module key_expansion (clk, key_in, key_schedule, start_encrypting);
	input clk;
	input [0:127] key_in ;
	output reg [0:1407] key_schedule ;
	output reg start_encrypting;
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
	integer row, col;
	
	integer i;
	integer j;
	
	initial begin
		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/sbox.mem",sbox);
		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/rcon.mem", rcon);
	end
	
	task automatic rot_word;   //////////////opeartes on a flattened word
	input [0:31] flattened_word_in ;
	output [0:31] flattened_word_out;
	reg [7:0] compact_word_in_reg[0:3] ;
	reg [7:0] compact_word_out_reg[0:3] ;
	integer row;
	
	
	begin
		for(row=0;row<4;row=row+1) begin
			compact_word_in_reg[row] = flattened_word_in[8*row +: 8];
		end
			
		for (row = 0; row < 4; row = row+1) begin
			compact_word_out_reg [row] = compact_word_in_reg [(row + 1)%4];
		end
	
		for(row=0;row<4;row=row+1) begin
			flattened_word_out[8*row +: 8] = compact_word_out_reg[row];
		end
			end
	
	endtask
	
	task automatic sub_word;   ////////////////operates on a flattened word
		input [0:31] flattened_word_in ;
		output [0:31] flattened_word_out;
		reg [7:0] compact_word_in_reg[0:3] ;
		reg [7:0] compact_word_out_reg[0:3] ;
		integer row;
		
		begin
		
			for(row=0;row<4;row=row+1) begin
				compact_word_in_reg[row] = flattened_word_in[8*row +: 8];
			end
			
			for (row = 0; row < 4; row = row+1) begin
				compact_word_out_reg [row] = sbox[16*compact_word_in_reg[row][7:4]+compact_word_in_reg[row][3:0]];
			end	
			
			for(row=0;row<4;row=row+1) begin
				flattened_word_out[8*row +: 8] = compact_word_out_reg[row];
			end
		
		end
		endtask
		
		task automatic xor_two_words;  ////////////////operates on a flattened word
		input [0:31] flattened_word_in1 ;
		input [0:31] flattened_word_in2 ;
		output [0:31] flattened_word_out ;
		reg [7:0] compact_word_in1_reg [0:3] ;
		reg [7:0] compact_word_in2_reg [0:3] ;
		reg [7:0] compact_word_out_reg [0:3];
		integer row;
		begin
			
			for(row=0;row<4;row=row+1) begin
				compact_word_in1_reg[row] = flattened_word_in1[8*row +: 8];
			end
			
			for(row=0;row<4;row=row+1) begin
				compact_word_in2_reg[row] = flattened_word_in2[8*row +: 8];
			end

			for (row = 0; row < 4; row = row + 1) begin
				compact_word_out_reg[row]  = compact_word_in1_reg[row]  ^ compact_word_in2_reg[row];
			end
			
			for(row=0;row<4;row=row+1) begin
				flattened_word_out[8*row +: 8] = compact_word_out_reg[row];
			end
			
		end
	endtask
		
		
		task automatic rcon_mem;  ////////////////just gives a constant from memory
		input [3:0] key_schedule_index ;
		output [0:31] word_out;
		begin
			word_out = rcon[key_schedule_index];
		end
	endtask



	
	always @(posedge clk) begin
		if (index == 0) begin
			
			for(col = 0; col<4 ;col=col+1) begin
				for(row = 0; row<4 ;row=row+1) begin
					key_schedule_reg[row][col] = key_in[32*col+8*row +: 8];
				end
			end			
		end
		
		else if (index>3 && index<44) begin


			for(row = 0; row<4 ;row=row+1) begin
				temp1 [8*row +: 8] = key_schedule_reg[row][index-1];
			end
			
			for(row = 0; row<4 ;row=row+1) begin
				temp2 [8*row +: 8] = key_schedule_reg[row][index-4];
			end
			
			if (index%4 == 0) begin
				rot_word(temp1, temp_rot_word);
				sub_word(temp_rot_word, temp_subword);
				rcon_mem(index/4, temp_rcon);
				xor_two_words(temp_subword, temp_rcon, temp_after_xor_with_rcon);
				xor_two_words(temp_after_xor_with_rcon, temp2, temp3);
				end
			else xor_two_words(temp1, temp2, temp3);
						
			for(row = 0; row<4 ;row=row+1) begin
				key_schedule_reg[row][index] = temp3[8*row +: 8];
			end

		end
			if (index >= 44) begin
				for(col = 0; col<44 ;col=col+1) begin
					for(row = 0; row<4 ;row=row+1) begin
						key_schedule[8*row+32*col +: 8] = key_schedule_reg[row][col];
					end
				end
				start_encrypting = 1;
			end
		index = index+1;
		
	end
	endmodule
	
//	module tb();
//	reg [0:127] key_in;
//	wire [0:1407] key_schedule;
//	reg clk;
//	
//	top_level t1 (clk, key_in, key_schedule);
//	
//	initial begin
//		key_in = 128'h 2b7e151628aed2a6abf7158809cf4f3c;
//		clk = 0;
//		repeat(100) #100 clk=~clk;
//		#100 $stop;
//	end
//	endmodule


module encryption_tb();
reg [0:127] key_in;
reg [0:127] data_in;
reg [0:127] cipher_out;
wire [0:1407] key_schedule;
reg [0:127] temp1, temp2, temp3, temp4, temp5;
reg [7:0] sbox [0:255];
reg [0:31] rcon [1:10];
reg clk;
integer round = 0;
	
	
	task automatic rot_word;   //////////////opeartes on a flattened word
	input [0:31] flattened_word_in ;
	output [0:31] flattened_word_out;
	reg [7:0] compact_word_in_reg[0:3] ;
	reg [7:0] compact_word_out_reg[0:3] ;
	integer row;
	
	
	begin
		for(row=0;row<4;row=row+1) begin
			compact_word_in_reg[row] = flattened_word_in[8*row +: 8];
		end
			
		for (row = 0; row < 4; row = row+1) begin
			compact_word_out_reg [row] = compact_word_in_reg [(row + 1)%4];
		end
	
		for(row=0;row<4;row=row+1) begin
			flattened_word_out[8*row +: 8] = compact_word_out_reg[row];
		end
			end
	
	endtask
	
	task automatic sub_word;   ////////////////operates on a flattened word
		input [0:31] flattened_word_in ;
		output [0:31] flattened_word_out;
		reg [7:0] compact_word_in_reg[0:3] ;
		reg [7:0] compact_word_out_reg[0:3] ;
		integer row;
		
		begin
		
			for(row=0;row<4;row=row+1) begin
				compact_word_in_reg[row] = flattened_word_in[8*row +: 8];
			end
			
			for (row = 0; row < 4; row = row+1) begin
				compact_word_out_reg [row] = sbox[16*compact_word_in_reg[row][7:4]+compact_word_in_reg[row][3:0]];
			end	
			
			for(row=0;row<4;row=row+1) begin
				flattened_word_out[8*row +: 8] = compact_word_out_reg[row];
			end
		
		end
		endtask
		
		task automatic xor_two_words;  ////////////////operates on a flattened word
		input [0:31] flattened_word_in1 ;
		input [0:31] flattened_word_in2 ;
		output [0:31] flattened_word_out ;
		reg [7:0] compact_word_in1_reg [0:3] ;
		reg [7:0] compact_word_in2_reg [0:3] ;
		reg [7:0] compact_word_out_reg [0:3];
		integer row;
		begin
			
			for(row=0;row<4;row=row+1) begin
				compact_word_in1_reg[row] = flattened_word_in1[8*row +: 8];
			end
			
			for(row=0;row<4;row=row+1) begin
				compact_word_in2_reg[row] = flattened_word_in2[8*row +: 8];
			end

			for (row = 0; row < 4; row = row + 1) begin
				compact_word_out_reg[row]  = compact_word_in1_reg[row]  ^ compact_word_in2_reg[row];
			end
			
			for(row=0;row<4;row=row+1) begin
				flattened_word_out[8*row +: 8] = compact_word_out_reg[row];
			end
			
		end
	endtask
		
		
		task automatic rcon_mem;  ////////////////just gives a constant from memory
		input [3:0] key_schedule_index ;
		output [0:31] word_out;
		begin
			word_out = rcon[key_schedule_index];
		end
	endtask
	
	
	task automatic shift_rows;
	input [0:127] in;
	output [0:127] out;
	reg [7:0] bytes_in [0:15];
	reg [7:0] bytes_out [0:15];
	reg [7:0] words_in [0:3][0:3];
	reg [7:0] words_out [0:3][0:3];
	integer row,col;
	
	begin
		for(col=0;col<16;col=col+1) begin
			bytes_in[col] = in[8*col +: 8];			
		end
		
		for(col=0;col<4;col=col+1) begin
			for (row=0;row<4;row=row+1)
				words_in[row][col] = bytes_in[4*col+row];			
		end
		
		for (row=0;row<4;row=row+1) begin
			for(col=0;col<4;col=col+1) begin
				case (row)
					0: words_out[row][col] = words_in[row][col];
					1: words_out[row][col] = words_in[row][(col+1)%4];
					2: words_out[row][col] = words_in[row][(col+2)%4];
					3: words_out[row][col] = words_in[row][(col+3)%4];
				endcase

			end
		end
		
	
//		for(col=0;col<4;col=col+1) begin
//			for (row=0;row<4;row=row+1) 
//				$display ("%d   %d   %h ",col, row, words_in[row][col] );
//		end
//		
//		for(col=0;col<4;col=col+1) begin
//			for (row=0;row<4;row=row+1) 
//				$display ("%d   %d   %h ",col, row, words_out[row][col] );
//		end
		
		for(col=0;col<4;col=col+1) begin
			for (row=0;row<4;row=row+1)
				bytes_out[4*col+row] = words_out[row][col];			
			
		end
		
		for(col=0;col<16;col=col+1) begin
			out[8*col +: 8] = bytes_out[col];
		end
	end	
	endtask
	
	task automatic mix_col;
	input [0:31] in;
	output [0:31] out;
	reg [7:0] bytes_in [0:3];
	reg [7:0] bytes_out [0:3];

	integer row,col;
	
	begin
		for(col=0;col<4;col=col+1) begin
			bytes_in[col] = in[8*col +: 8];			
		end
		
		bytes_out[0] = ((bytes_in[0] << 1) ^ (bytes_in[0][7] ? 8'h1b : 8'h00)) ^
							((bytes_in[1] << 1) ^ (bytes_in[1][7] ? 8'h1b : 8'h00) ^ bytes_in[1]) ^
							((bytes_in[2])) ^
							((bytes_in[3]));
							
		bytes_out[1] = ((bytes_in[0])) ^
							((bytes_in[1] << 1) ^ (bytes_in[1][7] ? 8'h1b : 8'h00)) ^
							((bytes_in[2] << 1) ^ (bytes_in[2][7] ? 8'h1b : 8'h00) ^ bytes_in[2]) ^
							((bytes_in[3]));
							
		bytes_out[2] = ((bytes_in[0])) ^
							((bytes_in[1]))^
							((bytes_in[2] << 1) ^ (bytes_in[2][7] ? 8'h1b : 8'h00)) ^
							((bytes_in[3] << 1) ^ (bytes_in[3][7] ? 8'h1b : 8'h00) ^ bytes_in[3]);
							
		bytes_out[3] = ((bytes_in[0] << 1) ^ (bytes_in[0][7] ? 8'h1b : 8'h00) ^ bytes_in[0]) ^
							((bytes_in[1])) ^
							((bytes_in[2])) ^
							((bytes_in[3]  << 1) ^ (bytes_in[3][7] ? 8'h1b : 8'h00));
		
		
		for(col=0;col<16;col=col+1) begin
			out[8*col +: 8] = bytes_out[col];
		end
	end	
	endtask
	
	
	
	task automatic xor_two_states;
	input [0:127] in1, in2;
	output [0:127] out;
	integer i;
	begin
		for(i=0;i<4;i=i+1) xor_two_words(in1[32*i +: 32], in2[32*i +: 32], out[32*i +: 32]);
	end
	endtask
	
	task automatic sub_states;
	input [0:127] in;
	output [0:127] out;
	integer i;
	begin
		for(i=0;i<4;i=i+1) sub_word(in[32*i +: 32], out[32*i +: 32]);
	end
	endtask
	
	task automatic mix_col_states;
	input [0:127] in;
	output [0:127] out;
	integer i;
	begin
		for(i=0;i<4;i=i+1) mix_col(in[32*i +: 32], out[32*i +: 32]);
	end
	endtask
		
		
	key_expansion k1 (clk, key_in, key_schedule, start_encrypting);
	
	always@(posedge clk) begin
		if(start_encrypting) begin
			if(round == 0) xor_two_states(data_in, key_schedule[128*0 +: 128], temp1);
			if(round >0 && round <10 ) begin
				sub_states(temp1, temp2);
				shift_rows(temp2, temp3);
				mix_col_states(temp3, temp4);
				xor_two_states(temp4, key_schedule[128*round +: 128], temp1);			
			end
			if(round == 10) begin
				sub_states(temp1, temp2);
				shift_rows(temp2, temp3);
				xor_two_states(temp3, key_schedule[128*round +: 128], temp1);			
			end
			round=round+1;
			cipher_out = temp1;
		end
	end
	
	
	initial begin
		key_in = 128'h 2b7e151628aed2a6abf7158809cf4f3c;
		data_in = 128'h3243f6a8885a308d313198a2e0370734;
		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/sbox.mem",sbox);
		$readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/aes_proj/rcon.mem", rcon);
		clk = 0;
		repeat(1000) #100 clk=~clk;
		#500 $stop;
	end
	
	
endmodule

	



module top_level(input in, output out);
assign out = in;
endmodule

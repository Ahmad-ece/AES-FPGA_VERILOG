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
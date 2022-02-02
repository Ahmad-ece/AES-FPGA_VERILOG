/*module key_expansion (key, key_schedule);
	input [7:0] key [0:3][0:3];
	output [7:0] key_schedule [0:3][0:43];
	
	reg [7:0] after_rot_4 [0:3] ;
	reg [7:0] after_sub_word_4 [0:3] ;
	
	rotword key_schedule_index_4_rotword (key_schedule[0:3][3][7:0], after_rot_4[0:3][3][7:0]);
	
	subword key_schedule_index_4_0_subword (after_rot_4[0], after_sub_word_4[0]);
	subword key_schedule_index_4_1_subword (after_rot_4[1], after_sub_word_4[1]);
	subword key_schedule_index_4_2_subword (after_rot_4[2], after_sub_word_4[2]);
	subword key_schedule_index_4_3_subword (after_rot_4[3], after_sub_word_4[3]);
	
	rcon_mem key_schedule_index_4_rcon_mem(4, rcon_4);
	xor_two_words key_schedule_index_4_xor_two_words (after_sub_word_4, rcon_4, after_xoring_rcon);
	xor_two_words key_schedule_index_4a_xor_two_words (after_xoring_rcon, key_schedule[0:3][3], key_schedule[0:3][4]);
	
		
	endmodule*/
	
/*module xor_two_words (word_in1, word_in2, word_out);
	input [7:0] word_in1 [0:3];
	input [7:0] word_in2 [0:3];
	output [7:0] word_out [0:3];
	reg [7:0] word_out_reg [0:3];
	assign word_out = word_out_reg;
	
	always @(*) begin
		integer i;
		integer j;
		for (i = 0; i < 4; i = i + 1) begin
			for (i = 0; i < 8; i = i + 1) begin
				word_out_reg[i][j] = word_in1[i][j] ^ word_in2[i][j];
			end
		end	
		i = 0;
		j = 0;
	end
	
	
endmodule*/
	

//////////////////////////////////////////////
/*module rcon_mem(input [3:0] key_schedule_index , output [31:0] word_out);
reg [31:0] rcon [1:10];
initial begin
	$readmemh("rcon.mem", rcon);
end
reg [31:0] word_out_reg;
integer key_schedule_index_int;
always @(*) begin
	key_schedule_index_int = key_schedule_index;
	word_out_reg = rcon[key_schedule_index_int];
end
assign word_out = word_out_reg;

endmodule*/
///////////////////////////////////////////////////////////////



///////////////////////////////////
/*module subword( input [7:0] byte_in, output [7:0] byte_out);

reg [7:0] sbox [0:15][0:15];
initial begin
	$readmemh("sbox.mem", sbox);
	$display("subword is %h", sbox[12][15]);  // sbox[rows][columns]
	//#100 $finish;
	end
	integer	 row;
	integer  col;
	reg [7:0] byte_out_reg;
always @(*) begin
	row = byte_in[7:4];
	col = byte_in[3:0];
	
	byte_out_reg = sbox[row][col];

end

assign byte_out = byte_out_reg;

endmodule
*/
/////////////////////////////////////////






////////////////////////////////////////////
/*


module tb_rotword ();
	reg [0:3][7:0] word1 ;
	reg [0:3][7:0] word2 ;
	
	aes aes_1 (word1, word2);
	
	initial begin
		word1[0] = 8'h2b;
		word1[1] = 8'h7e;
		word1[2] = 8'h15;
		word1[3] = 8'h16;
		
		#100 $finish;
	
	
	end
endmodule	


module rotword ( word1, word2);
	input [0:3] [7:0] word1 ;
	output [0:3]  [7:0] word2 ;
	reg [0:3] [7:0] word ;
	
	
	always @(*) begin
		integer i;
		for (i = 0; i < 4; i = i+1) 
			word [i] = word1 [(i + 1)%4];
		end
		
		assign word2[3] = word[3];
		assign word2[2] = word[2];
		assign word2[1] = word[1];
		assign word2[0] = word[0];

	endmodule*/

/////////////////////////////////



/////////////////////////////code below this uses tasks/////////////////////
////////////////////////////////////////////////////////////////////////////
/*module sub (byte_in, byte_out);
	input [7:0] byte_in;
	output [7:0] byte_out;
	reg [7:0] out;
	
		task automatic subword;
		input [7:0] byte_in;
		output [7:0] byte_out;
		reg [7:0] sbox [0:15][0:15];
		integer	 row;
		integer  col;
		
		begin
			$readmemh("sbox.mem", sbox);
			//$display("subword is %h", sbox[12][15]);  // sbox[rows][columns]
			
			row = byte_in[7:4];
			col = byte_in[3:0];
			
			byte_out = sbox[row][col];
		end
		endtask
	always @(*) begin
		subword(byte_in, out);
		
	end
	assign byte_out = out;
	
	
	endmodule*/

////////////////////////////////////////////////////////////////////////////
/*module rot (word_in, word_out);
	input [7:0] word_in [0:3];
	output [7:0] word_out [0:3];
	reg [7:0] out[0:3];
	
	task automatic rotword; 
	input [7:0] word_in [0:3];
	output [7:0] word_out [0:3];
	integer i;
	
	begin
		i = 0;
		for (i = 0; i < 4; i = i+1) begin
			word_out [i][7:0] = word_in [(i + 1)%4][7:0];
		end	
		i = 0;
	end
	
	endtask
	
	always @(*) begin
		rotword(word_in, out);
		
	end
	assign word_out = out;
	
	
	endmodule
	
module test_for_rot();
	reg [7:0] word_in [0:3];
	reg [7:0] word_out [0:3];
	
	rot t1 (word_in, word_out);
	
	initial begin
		word_in[0] = 8'h01;
		word_in[1] = 8'h02;
		word_in[2] = 8'h03;
		word_in[3] = 8'h04;
		#100 $finish;
	end
	
	endmodule
	
*/

////////////////////////////////////////////////////////////////////////////
/*module rcon_mem_module(key_schedule_index, word_out);
	input [3:0] key_schedule_index ;
	output [7:0] word_out;
	reg [7:0] word_out_reg;
	task automatic rcon_mem;
		input [3:0] key_schedule_index ;
		output [7:0] word_out;
		integer key_schedule_index_int;
		reg [7:0] rcon [1:10];
		begin
			$readmemh("rcon.mem", rcon);
		
			key_schedule_index_int = key_schedule_index;
			word_out = rcon[key_schedule_index_int];
		end
	endtask
	
	
	always @(*) begin
		rcon_mem(key_schedule_index, word_out_reg);
	end
	assign word_out = word_out_reg;

endmodule*/

/////////////////////////////////////////////////////////////////////////

module xor_two_words_module(word_in1, word_in2, word_out);
	input [7:0] word_in1 [0:3];
	input [7:0] word_in2 [0:3];
	output [7:0] word_out [0:3];
	reg [7:0] word_out_reg [0:3];

	
	task automatic xor_two_words;
		input [7:0] word_in1 [0:3];
		input [7:0] word_in2 [0:3];
		output [7:0] word_out [0:3];
		integer i,j;
		begin
			for (i = 0; i < 4; i = i + 1) begin
					$display("i = %d", i);
					$display("word1 is %h", word_in1[i]);
					$display("word2 is %h", word_in2[i]);
					
					word_out[i]  = word_in1[i]  ^ word_in2[i];
					$display("wordout is %h", word_out[i]);
			end
			
		end
		
	endtask
	
	always @(*) begin
	
		xor_two_words(word_in1, word_in2, word_out_reg);
	end
		assign word_out = word_out_reg;
endmodule

module tb_for_xor_task();
	reg [7:0] word_in1 [0:3];
	reg [7:0] word_in2 [0:3];
	reg [7:0] word_out [0:3];
	xor_two_words_module x1(word_in1, word_in2, word_out);
	
	initial begin
		word_in1[0] = 8'h12;
		word_in1[1] = 8'h56;
		word_in1[2] = 8'h56;
		word_in1[3] = 8'h34;
		word_in2[0] = 8'h9a;
		word_in2[1] = 8'h65;
		word_in2[2] = 8'hdd;
		word_in2[3] = 8'h12;
		#100 $finish;
		end
		
endmodule
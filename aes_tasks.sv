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

/*module xor_two_words_module(word_in1, word_in2, word_out);
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
					// $display("i = %d", i);
					// $display("word1 is %h", word_in1[i]);
					// $display("word2 is %h", word_in2[i]);
					
					word_out[i]  = word_in1[i]  ^ word_in2[i];
					//$display("wordout is %h", word_out[i]);
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
		
endmodule*/
//////////////////////////////////////////////////////////////////////////////////////
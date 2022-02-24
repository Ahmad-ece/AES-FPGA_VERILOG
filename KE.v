module KE(key,word_in,word_out);
 input[7:0]word_in[0:3][0:3];
 input[7:0]key[0:15];
 output[7:0]word_out[0:3][0:43];
 reg[7:0]out[0:3][0:43];
 reg[7:0]temp1[0:3];
 reg[7:0]temp2[0:3];
 reg[7:0]temp3[0:3];
 reg[7:0]temp4[0:3];
 task automatic key_expansion;
 //begin
 input[7:0]word_in[0:3][0:3];
 input[7:0]key[0:15];
 output[7:0]word_out[0:3][0:43];
 reg[7:0]temp1[0:3];
 reg[7:0]temp2[0:3];
 reg[7:0]temp3[0:3];
 reg[7:0]temp4[0:3];
 integer i;
 integer j;
 begin
  for(i=0;i<4;i=i+1)begin
   for(j=0;j<4;j=j+1)begin
   word_out[j][i]=key[4*i+j];
   end
  end 	
  for(i=4;i<44;i=i+1)begin
  temp1=word_in[i-1];
   if(i%4==0)begin
	 temp2=rotword(temp1);
	 temp3=subword(temp2);
	 temp4=rcon_mem(i/4);
	 temp1=xor_two_words(temp3,temp4);
	end
   word_out[i]=xor_two_words(word_in[i-4],temp1);	
 end 
 end
 endtask 

always@(*)begin

 key_expansion(key,word_in,out);
 
end

 assign word_out=out;
 
//endmodule 























/*module sub (byte_in, byte_out);
	input [7:0] byte_in;
	output [7:0] byte_out;
	reg [7:0] out;*/
	
		task automatic subword;
		input [7:0] byte_in[0:3];
		output [7:0] byte_out[0:3];
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
	/*always @(*) begin
		subword(byte_in, out);
		
	end
	assign byte_out = out;*/
	
	
	//endmodule

/*module rot (word_in, word_out);
	input [7:0] word_in [0:3];
	output [7:0] word_out [0:3];
	reg [7:0] out[0:3];*/
	
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
	
	/*always @(*) begin
		rotword(word_in, out);
		
	end
	assign word_out = out;
	
	
	endmodule*/
	

/*module rcon_mem_module(key_schedule_index, word_out);
	input [3:0] key_schedule_index ;
	output [7:0] word_out;
	reg [7:0] word_out_reg;*/
	task automatic rcon_mem;
		input [3:0] key_schedule_index ;
		output [7:0] word_out[0:3];
		integer key_schedule_index_int;
		reg [7:0] rcon [1:10];
		begin
			$readmemh("rcon.mem", rcon);
		
			key_schedule_index_int = key_schedule_index;
			word_out = rcon[key_schedule_index_int];
		end
	endtask
	
	
	/*always @(*) begin
		rcon_mem(key_schedule_index, word_out_reg);
	end
	assign word_out = word_out_reg;
endmodule*/

/*module xor_two_words_module(word_in1, word_in2, word_out);
	input [7:0] word_in1 [0:3];
	input [7:0] word_in2 [0:3];
	output [7:0] word_out [0:3];
	reg [7:0] word_out_reg [0:3];*/
	
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
	
	/*always @(*) begin
	
		xor_two_words(word_in1, word_in2, word_out_reg);
	end
		assign word_out = word_out_reg;*/
endmodule












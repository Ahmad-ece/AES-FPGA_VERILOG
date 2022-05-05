`timescale 1 ps / 1 ps
module top_level_tb();
reg clk;
reg [0:127] key_in, data_in_encr;
wire check;
wire [0:127] decipher_out;

top_level t0 (clk, key_in, data_in_encr, decipher_out, check);



	initial begin
	
		clk = 0;
		repeat(1000) #100 clk=~clk;
		#200000 $stop;
	end
	
	initial begin
		key_in = 128'h 2b7e151628aed2a6abf7158809cf4f3c;
		data_in_encr = 128'h3243f6a8885a308d313198a2e0370734;
		// $readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/AES_PROJ_ENCR_DECR_SINGLE_BLOCK/inv_sbox.mem",inv_sbox);
		// $readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/AES_PROJ_ENCR_DECR_SINGLE_BLOCK/sbox.mem",sbox);
		// $readmemh("C:/Users/Maaz/Desktop/iitb/2nd_sem/705/project/AES_PROJ_ENCR_DECR_SINGLE_BLOCK/rcon.mem", rcon);
		//start_encrypting = 1;
		
	end
	
//	always @ (encryption_done) begin
//		if (encryption_done == 1) begin
//			start_encrypting = 0;
//			start_decrypting = 1; 
//		end
//	end 

endmodule

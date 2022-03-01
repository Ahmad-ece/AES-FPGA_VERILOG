module tb();
reg [0:31] state_in;
reg [0:31] state_out;

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
		
		initial begin
			state_in = 32'hd4bf5d30;
			mix_col(state_in, state_out);
			
		end
endmodule



module top_level(input in, output out);
assign out = in;
endmodule

module tb();
reg [0:127] state_in;
reg [0:127] state_out;

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
		
	
		for(col=0;col<4;col=col+1) begin
			for (row=0;row<4;row=row+1) 
				$display ("%d   %d   %h ",col, row, words_in[row][col] );
		end
		
		for(col=0;col<4;col=col+1) begin
			for (row=0;row<4;row=row+1) 
				$display ("%d   %d   %h ",col, row, words_out[row][col] );
		end
		
		for(col=0;col<4;col=col+1) begin
			for (row=0;row<4;row=row+1)
				bytes_out[4*col+row] = words_out[row][col];			
			
		end
		
		for(col=0;col<16;col=col+1) begin
			out[8*col +: 8] = bytes_out[col];
		end
	end	
	endtask
		
		initial begin
			state_in = 128'h 2b7e151628aed2a6abf7158809cf4f3c;
			shift_rows(state_in, state_out);
			
		end
endmodule



module top_level(input in, output out);
assign out = in;
endmodule

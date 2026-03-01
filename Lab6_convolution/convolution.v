module conv(
	input [3:0] dp,
	output reg [3:0] out 
	);
	reg [4:0] img [3:0][3:0];
	reg [2:0] kernel [2:0][2:0];
	reg [18:0] conv [1:0][1:0];
	
	integer i,j,k,w;
	integer temp;
    always @(*) begin
	 // IMG
	  img[0][0] = 5'd1; img[0][1] = 5'd2; img[0][2] = 5'd3; img[0][3] = 5'd4;
	  img[1][0] = 5'd5; img[1][1] = 5'd6; img[1][2] = 5'd7; img[1][3] = 5'd8;
	  img[2][0] = 5'd9; img[2][1] = 5'd10; img[2][2] = 5'd11; img[2][3] = 5'd12;
	  img[3][0] = 5'd13; img[3][1] = 5'd14; img[3][2] = 5'd15; img[3][3] = 5'd16;
	 
	  case (dp)
			4'b1000: begin
				 kernel[0][0] = 1'b1; kernel[0][1] = 1'b0; kernel[0][2] = 1'b0;
				 kernel[1][0] = 1'b1; kernel[1][1] = 1'b1; kernel[1][2] = 1'b0;
				 kernel[2][0] = 1'b0; kernel[2][1] = 1'b0; kernel[2][2] = 1'b0;
			end
			4'b0100: begin
				 kernel[0][0] = 1'b0; kernel[0][1] = 1'b0; kernel[0][2] = 1'b0;
				 kernel[1][0] = 1'b0; kernel[1][1] = 1'b1; kernel[1][2] = 1'b0;
				 kernel[2][0] = 1'b1; kernel[2][1] = 1'b1; kernel[2][2] = 1'b1;
			end
			4'b0010: begin
				 kernel[0][0] = 1'b1; kernel[0][1] = 1'b1; kernel[0][2] = 1'b1;
				 kernel[1][0] = 1'b0; kernel[1][1] = 1'b0; kernel[1][2] = 1'b0;
				 kernel[2][0] = 1'b1; kernel[2][1] = 1'b1; kernel[2][2] = 1'b1;
			end
			4'b0001: begin
				 kernel[0][0] = 1'b1; kernel[0][1] = 1'b1; kernel[0][2] = 1'b1;
				 kernel[1][0] = 1'b1; kernel[1][1] = 1'b1; kernel[1][2] = 1'b1;
				 kernel[2][0] = 1'b1; kernel[2][1] = 1'b1; kernel[2][2] = 1'b1;
			end
			default: begin
				 kernel[0][0] = 1'b0; kernel[0][1] = 1'b0; kernel[0][2] = 1'b0;
				 kernel[1][0] = 1'b0; kernel[1][1] = 1'b0; kernel[1][2] = 1'b0;
				 kernel[2][0] = 1'b0; kernel[2][1] = 1'b0; kernel[2][2] = 1'b0;
			end
	  endcase
	end
	always @(*) begin
		 for (i=0; i<2; i=i+1)
			  for (j=0; j<2; j=j+1)
					conv[i][j] = 0;

		 for (i=0; i<2; i=i+1) begin
			  for (j=0; j<2; j=j+1) begin
					temp = 0;
					for (k=0; k<3; k=k+1) begin
						 for (w=0; w<3; w=w+1) begin
							  temp = temp + img[i+k][j+w] * kernel[k][w];
						 end
					end
					conv[i][j] = temp;
			  end
		 end
	end

	always @(*) begin
		 out[0] = (conv[0][0] >= 40); // Output0
		 out[1] = (conv[0][1] >= 40); // Output1
		 out[2] = (conv[1][0] >= 40); // Output2
		 out[3] = (conv[1][1] >= 40); // Output3
	end

    endmodule
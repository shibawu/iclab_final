`define N 10
`define M 12

module RLC(
	input		clk,
	input		srst_n,
	input   [`N:0]  q11, q12, q13, q14, q15, q16, q17, q18,
	input   [`N:0]  q21, q22, q23, q24, q25, q26, q27, q28,
	input   [`N:0]  q31, q32, q33, q34, q35, q36, q37, q38,
	input   [`N:0]  q41, q42, q43, q44, q45, q46, q47, q48, 
	input   [`N:0]  q51, q52, q53, q54, q55, q56, q57, q58, 
	input   [`N:0]  q61, q62, q63, q64, q65, q66, q67, q68,
	input   [`N:0]  q71, q72, q73, q74, q75, q76, q77, q78,
	input   [`N:0]  q81, q82, q83, q84, q85, q86, q87, q88,
	input  enable,
    output reg [`N:0] DC_reg,
	output reg [24-1:0] R_reg,
	output reg [32-1:0] L_reg,
	output reg [32-1:0] F_reg,
    output reg [11-1:0] sram_waddr,
    output reg [99-1:0] sram_wdata,
    output reg wen,
    output reg vaild
    
);

reg [11-1:0] sram_waddr_next;
reg wen_reg;
reg vaild_ff;

wire [`N:0] zig_zag [0:63];
integer i, number;
reg [3-1:0] R [0:7];
reg [4-1:0] L [0:7];
reg [4-1:0] F [0:7];
reg [8-1:0] WW [0:63];
wire [`N:0] DC;

assign DC = q11;
// always @(*) begin
assign	zig_zag[0] = q11;
assign	zig_zag[1] = q12;
assign	zig_zag[2] = q21;
assign	zig_zag[3] = q31;
assign	zig_zag[4] = q22;
assign	zig_zag[5] = q13;
assign	zig_zag[6] = q14;
assign	zig_zag[7] = q23;
assign	zig_zag[8] = q32;
assign	zig_zag[9] = q41;
assign	zig_zag[10] = q51;
assign	zig_zag[11] = q42;
assign	zig_zag[12] = q33;
assign	zig_zag[13] = q24;
assign	zig_zag[14] = q15;
assign	zig_zag[15] = q16;
assign	zig_zag[16] = q25;
assign	zig_zag[17] = q34;
assign	zig_zag[18] = q43;
assign	zig_zag[19] = q52;
assign	zig_zag[20] = q61;
assign	zig_zag[21] = q71;
assign	zig_zag[22] = q62;
assign	zig_zag[23] = q53;
assign	zig_zag[24] = q44;
assign	zig_zag[25] = q35;
assign	zig_zag[26] = q26;
assign	zig_zag[27] = q17;
assign	zig_zag[28] = q18;
assign	zig_zag[29] = q27;
assign	zig_zag[30] = q36;
assign	zig_zag[31] = q45;
assign	zig_zag[32] = q54;
assign	zig_zag[33] = q63;
assign	zig_zag[34] = q72;
assign	zig_zag[35] = q81;
assign	zig_zag[36] = q82;
assign	zig_zag[37] = q73;
assign	zig_zag[38] = q64;
assign	zig_zag[39] = q55;
assign	zig_zag[40] = q46;
assign	zig_zag[41] = q37;
assign	zig_zag[42] = q28;
assign	zig_zag[43] = q38;
assign	zig_zag[44] = q47;
assign	zig_zag[45] = q56;
assign	zig_zag[46] = q65;
assign	zig_zag[47] = q74;
assign	zig_zag[48] = q83;
assign	zig_zag[49] = q84;
assign	zig_zag[50] = q75;
assign	zig_zag[51] = q66;
assign	zig_zag[52] = q57;
assign	zig_zag[53] = q48;
assign	zig_zag[54] = q58;
assign	zig_zag[55] = q67;
assign	zig_zag[56] = q76;
assign	zig_zag[57] = q85;
assign	zig_zag[58] = q86;
assign	zig_zag[59] = q77;
assign	zig_zag[60] = q68;
assign	zig_zag[61] = q87;
assign	zig_zag[62] = q78;
assign	zig_zag[63] = q88;
// end

always @(*) begin
	if (sram_waddr == 11'd1729) begin
		vaild_ff = 1;
	end else begin
		vaild_ff = vaild;
	end
end

always @(posedge clk) begin
	if (~srst_n) begin
		DC_reg <= 0;
        R_reg <= 0;
		L_reg <= 0;
		F_reg <= 0;
        sram_wdata <= 0;
        sram_waddr <= -1;
        wen <= 1;
		vaild <= 0;
	end else begin
        DC_reg <= DC;
		R_reg <= {R[7], R[6], R[5], R[4], R[3], R[2], R[1], R[0]};
		L_reg <= {L[7], L[6], L[5], L[4], L[3], L[2], L[1], L[0]};
		F_reg <= {F[7], F[6], F[5], F[4], F[3], F[2], F[1], F[0]};
		vaild <= vaild_ff;
        sram_wdata <= {DC, R[7], R[6], R[5], R[4], R[3], R[2], R[1], R[0], L[7], L[6], L[5], L[4], L[3], L[2], L[1], L[0], F[7], F[6], F[5], F[4], F[3], F[2], F[1], F[0]};
        sram_waddr <= sram_waddr_next;
        wen <= wen_reg;
	end
end

always @(*) begin
	if (enable) begin
		number = 1;
		WW[0] = 0;
		for (i = 1; i < 9; i=i+1) WW[i] = 200;
		for (i = 1; i < 9; i=i+1) begin
			if (zig_zag[i] != 0) begin
				WW[number] = i;
				number = number + 1'b1;
			end else begin
				WW[number] = 200;
			end
		end
    end else begin
        for (i = 0; i < 9; i=i+1) begin
            number = 0;
			WW[i] = 0;
		end
    end
end

// w[0] = 0 -- DC != 0
// w[0] = 1 -- DC == 0

always @(*) begin
    if (enable) begin

		R[0] = WW[1] == 200 ? 0 : WW[1] - WW[0] - 1;
		L[0] = WW[1] == 200 ? 0 : zig_zag[WW[1]];
		F[0] = 1;

		R[1] = WW[2] == 200 ? 0 : WW[2] - WW[1] - 1;
		L[1] = WW[2] == 200 ? 0 : zig_zag[WW[2]];
		if (R[1] == R[0] && L[1] == L[0]) begin
			F[1] = 2;
			F[0] = 0;
		end else F[1] = 1;

		R[2] = WW[3] == 200 ? 0 : WW[3] - WW[2] - 1;
		L[2] = WW[3] == 200 ? 0 : zig_zag[WW[3]];
		if (R[2] == R[1] && L[2] == L[1]) begin
			F[2] = F[1] + 1;
			F[1] = 0;
		end else if (R[2] == R[0] && L[2] == L[0]) begin
			F[2] = F[0] + 1;
			F[0] = 0;
		end else F[2] = 1;

		R[3] = WW[4] == 200 ? 0 : WW[4] - WW[3] - 1;
		L[3] = WW[4] == 200 ? 0 : zig_zag[WW[4]];
		if (R[3] == R[2] && L[3] == L[2]) begin
			F[3] = F[2] + 1;
			F[2] = 0;
		end else if (R[3] == R[1] && L[3] == L[1]) begin
			F[3] = F[1] + 1;
			F[1] = 0;
		end else if (R[3] == R[0] && L[3] == L[0]) begin
			F[3] = F[0] + 1;
			F[0] = 0;
		end else F[3] = 1;

		R[4] = WW[5] == 200 ? 0 : WW[5] - WW[4] - 1;
		L[4] = WW[5] == 200 ? 0 : zig_zag[WW[5]];
		if (R[4] == R[3] && L[4] == L[3]) begin
			F[4] = F[3] + 1;
			F[3] = 0;
		end else if (R[4] == R[2] && L[4] == L[2]) begin
			F[4] = F[2] + 1;
			F[2] = 0;
		end else if (R[4] == R[1] && L[4] == L[1]) begin
			F[4] = F[1] + 1;
			F[1] = 0;
		end else if (R[4] == R[0] && L[4] == L[0]) begin
			F[4] = F[0] + 1;
			F[0] = 0;
		end else F[4] = 1;

		R[5] = WW[6] == 200 ? 0 : WW[6] - WW[5] - 1;
		L[5] = WW[6] == 200 ? 0 : zig_zag[WW[6]];
		if (R[5] == R[4] && L[5] == L[4]) begin
			F[5] = F[4] + 1;
			F[4] = 0;
		end else if (R[5] == R[3] && L[5] == L[3]) begin
			F[5] = F[3] + 1;
			F[3] = 0;
		end else if (R[5] == R[2] && L[5] == L[2])  begin
			F[5] = F[2] + 1;
			F[2] = 0;
		end else if (R[5] == R[1] && L[5] == L[1]) begin
			F[5] = F[1] + 1;
			F[1] = 0;
		end else if (R[5] == R[0] && L[5] == L[0]) begin
			F[5] = F[0] + 1;
			F[0] = 0;
		end else F[5] = 1;

		R[6] = WW[7] == 200 ? 0 : WW[7] - WW[6] - 1;
		L[6] = WW[7] == 200 ? 0 : zig_zag[WW[7]];
		if (R[6] == R[5] && L[6] == L[5]) begin
			F[6] = F[5] + 1;
			F[5] = 0;
		end else if (R[6] == R[4] && L[6] == L[4]) begin
			F[6] = F[4] + 1;
			F[4] = 0;
		end else if (R[6] == R[3] && L[6] == L[3]) begin
			F[6] = F[3] + 1;
			F[3] = 0;
		end else if (R[6] == R[2] && L[6] == L[2]) begin
			F[6] = F[2] + 1;
			F[2] = 0;
		end else if (R[6] == R[1] && L[6] == L[1]) begin
			F[6] = F[1] + 1;
			F[1] = 0;
		end else if (R[6] == R[0] && L[6] == L[0]) begin
			F[6] = F[0] + 1;
			F[0] = 0;
		end else F[6] = 1;

		R[7] = WW[8] == 200 ? 0 : WW[8] - WW[7] - 1;
		L[7] = WW[8] == 200 ? 0 : zig_zag[WW[8]];
		if 	(R[7] == R[6] && L[7] == L[6]) begin
			F[7] = F[6] + 1;
			F[6] = 0;
		end else if (R[7] == R[5] && L[7] == L[5]) begin 
			F[7] = F[5] + 1;
			F[5] = 0;
		end else if (R[7] == R[4] && L[7] == L[4]) begin 
			F[7] = F[4] + 1;
			F[4] = 0;
		end else if (R[7] == R[3] && L[7] == L[3]) begin
			F[7] = F[3] + 1;
			F[3] = 0;
		end else if (R[7] == R[2] && L[7] == L[2]) begin
			F[7] = F[2] + 1;
			F[2] = 0;
		end else if (R[7] == R[1] && L[7] == L[1])  begin
			F[7] = F[1] + 1;
			F[1] = 0;
		end else if (R[7] == R[0] && L[7] == L[0]) begin
			F[7] = F[0] + 1;
			F[0] = 0;
		end else F[7] = 1;
        sram_waddr_next = sram_waddr + 1;
        wen_reg = 0;

	end else begin
		for (i = 0; i < 8; i=i+1) R[i] = 0;
		for (i = 0; i < 8; i=i+1) L[i] = 0;
		for (i = 0; i < 8; i=i+1) F[i] = 0;
        sram_waddr_next = sram_waddr;
        wen_reg = 1;
	end

end

endmodule


// 		R[8] = WW[9] == 200 ? 0 : WW[9] - WW[8] - 1;
// 		L[8] = WW[9] == 200 ? 0 : zig_zag[WW[9]];
// 		if 		(R[8] == R[7] && L[8] == L[7]) F[8] = F[7] + 1;
// 		else if (R[8] == R[6] && L[8] == L[6]) F[8] = F[6] + 1;
// 		else if (R[8] == R[5] && L[8] == L[5]) F[8] = F[5] + 1;
// 		else if (R[8] == R[4] && L[8] == L[4]) F[8] = F[4] + 1;
// 		else if (R[8] == R[3] && L[8] == L[3]) F[8] = F[3] + 1;
// 		else if (R[8] == R[2]  && L[8] == L[2])  F[8] = F[2] + 1;
// 		else if (R[8] == R[1]   && L[8] == L[1])   F[8] = F[1] + 1;
// 		else if (R[8] == R[0]   && L[8] == L[0])   F[8] = F[0] + 1;
// 		else 	 F[8] = 0;

// 		R[9] = WW[10] == 200 ? 0 : WW[10] - WW[9] - 1;
// 		L[9] = WW[10] == 200 ? 0 : zig_zag[WW[10]];
// 		if 		(R[9] == R[8] && L[9] == L[8]) F[9] = F[8] + 1;
// 		else if (R[9] == R[7] && L[9] == L[7]) F[9] = F[7] + 1;
// 		else if (R[9] == R[6] && L[9] == L[6]) F[9] = F[6] + 1;
// 		else if (R[9] == R[5] && L[9] == L[5]) F[9] = F[5] + 1;
// 		else if (R[9] == R[4] && L[9] == L[4]) F[9] = F[4] + 1;
// 		else if (R[9] == R[3] && L[9] == L[3]) F[9] = F[3] + 1;
// 		else if (R[9] == R[2]  && L[9] == L[2])  F[9] = F[2] + 1;
// 		else if (R[9] == R[1]   && L[9] == L[1])   F[9] = F[1] + 1;
// 		else if (R[9] == R[0]   && L[9] == L[0])   F[9] = F[0] + 1;
// 		else 	 F[9] = 0;

// 		R[10] = WW[11] == 200 ? 0 : WW[11] - WW[10] - 1;
// 		L[10] = WW[11] == 200 ? 0 : zig_zag[WW[11]];
// 		if 		(R[10] == R[9] && L[10] == L[9]) F[10] = F[9] + 1;
// 		else if (R[10] == R[8] && L[10] == L[8]) F[10] = F[8] + 1;
// 		else if (R[10] == R[7] && L[10] == L[7]) F[10] = F[7] + 1;
// 		else if (R[10] == R[6] && L[10] == L[6]) F[10] = F[6] + 1;
// 		else if (R[10] == R[5] && L[10] == L[5]) F[10] = F[5] + 1;
// 		else if (R[10] == R[4] && L[10] == L[4]) F[10] = F[4] + 1;
// 		else if (R[10] == R[3] && L[10] == L[3]) F[10] = F[3] + 1;
// 		else if (R[10] == R[2] && L[10] == L[2]) F[10] = F[2] + 1;
// 		else if (R[10] == R[1] && L[10] == L[1]) F[10] = F[1] + 1;
// 		else if (R[10] == R[0] && L[10] == L[0]) F[10] = F[0] + 1;
// 		else 	 F[10] = 0;

// 		R[11] = WW[12] == 200 ? 0 : WW[12] - WW[11] - 1;
// 		L[11] = WW[12] == 200 ? 0 : zig_zag[WW[12]];
// 		if 		(R[11] == R[10] && L[11] == L[10]) F[11] = F[10] + 1;
// 		else if (R[11] == R[9] && L[11] == L[9]) F[11] = F[9] + 1;
// 		else if (R[11] == R[8] && L[11] == L[8]) F[11] = F[8] + 1;
// 		else if (R[11] == R[7] && L[11] == L[7]) F[11] = F[7] + 1;
// 		else if (R[11] == R[6] && L[11] == L[6]) F[11] = F[6] + 1;
// 		else if (R[11] == R[5] && L[11] == L[5]) F[11] = F[5] + 1;
// 		else if (R[11] == R[4] && L[11] == L[4]) F[11] = F[4] + 1;
// 		else if (R[11] == R[3] && L[11] == L[3]) F[11] = F[3] + 1;
// 		else if (R[11] == R[2] && L[11] == L[2]) F[11] = F[2] + 1;
// 		else if (R[11] == R[1] && L[11] == L[1]) F[11] = F[1] + 1;
// 		else if (R[11] == R[0] && L[11] == L[0]) F[11] = F[0] + 1;
// 		else 	 F[11] = 0;

// 		R[12] = WW[13] == 200 ? 0 : WW[13] - WW[12] - 1;
// 		L[12] = WW[13] == 200 ? 0 : zig_zag[WW[13]];
// 		if 		(R[12] == R[11]&& L[12] == L[11])F[12] = F[11] + 1;
// 		else if (R[12] == R[10]&& L[12] == L[10])F[12] = F[10] + 1;
// 		else if (R[12] == R[9] && L[12] == L[9]) F[12] = F[9] + 1;
// 		else if (R[12] == R[8] && L[12] == L[8]) F[12] = F[8] + 1;
// 		else if (R[12] == R[7] && L[12] == L[7]) F[12] = F[7] + 1;
// 		else if (R[12] == R[6] && L[12] == L[6]) F[12] = F[6] + 1;
// 		else if (R[12] == R[5] && L[12] == L[5]) F[12] = F[5] + 1;
// 		else if (R[12] == R[4] && L[12] == L[4]) F[12] = F[4] + 1;
// 		else if (R[12] == R[3] && L[12] == L[3]) F[12] = F[3] + 1;
// 		else if (R[12] == R[2] && L[12] == L[2]) F[12] = F[2] + 1;
// 		else if (R[12] == R[1] && L[12] == L[1]) F[12] = F[1] + 1;
// 		else if (R[12] == R[0] && L[12] == L[0]) F[12] = F[0] + 1;
// 		else 	 F[12] = 0;

// 		R[13] = WW[14] == 200 ? 0 : WW[14] - WW[13] - 1;
// 		L[13] = WW[14] == 200 ? 0 : zig_zag[WW[14]];
// 		if 		(R[13] == R[12]&& L[13] == L[12])F[13] = F[12] + 1;
// 		else if (R[13] == R[11]&& L[13] == L[11])F[13] = F[11] + 1;
// 		else if (R[13] == R[10]&& L[13] == L[10])F[13] = F[10] + 1;
// 		else if (R[13] == R[9] && L[13] == L[9]) F[13] = F[9] + 1;
// 		else if (R[13] == R[8] && L[13] == L[8]) F[13] = F[8] + 1;
// 		else if (R[13] == R[7] && L[13] == L[7]) F[13] = F[7] + 1;
// 		else if (R[13] == R[6] && L[13] == L[6]) F[13] = F[6] + 1;
// 		else if (R[13] == R[5] && L[13] == L[5]) F[13] = F[5] + 1;
// 		else if (R[13] == R[4] && L[13] == L[4]) F[13] = F[4] + 1;
// 		else if (R[13] == R[3] && L[13] == L[3]) F[13] = F[3] + 1;
// 		else if (R[13] == R[2] && L[13] == L[2]) F[13] = F[2] + 1;
// 		else if (R[13] == R[1] && L[13] == L[1]) F[13] = F[1] + 1;
// 		else if (R[13] == R[0] && L[13] == L[0]) F[13] = F[0] + 1;
// 		else 	 F[13] = 0;

// 		R[14] = WW[15] == 200 ? 0 : WW[15] - WW[14] - 1;
// 		L[14] = WW[15] == 200 ? 0 : zig_zag[WW[15]];
// 		if 		(R[14] == R[13]&& L[14] == L[13])F[14] = F[13] + 1;
// 		else if (R[14] == R[12]&& L[14] == L[12])F[14] = F[12] + 1;
// 		else if (R[14] == R[11]&& L[14] == L[11])F[14] = F[11] + 1;
// 		else if (R[14] == R[10]&& L[14] == L[10])F[14] = F[10] + 1;
// 		else if (R[14] == R[9] && L[14] == L[9]) F[14] = F[9] + 1;
// 		else if (R[14] == R[8] && L[14] == L[8]) F[14] = F[8] + 1;
// 		else if (R[14] == R[7] && L[14] == L[7]) F[14] = F[7] + 1;
// 		else if (R[14] == R[6] && L[14] == L[6]) F[14] = F[6] + 1;
// 		else if (R[14] == R[5] && L[14] == L[5]) F[14] = F[5] + 1;
// 		else if (R[14] == R[4] && L[14] == L[4]) F[14] = F[4] + 1;
// 		else if (R[14] == R[3] && L[14] == L[3]) F[14] = F[3] + 1;
// 		else if (R[14] == R[2] && L[14] == L[2]) F[14] = F[2] + 1;
// 		else if (R[14] == R[1] && L[14] == L[1]) F[14] = F[1] + 1;
// 		else if (R[14] == R[0] && L[14] == L[0]) F[14] = F[0] + 1;
// 		else 	 F[14] = 0;

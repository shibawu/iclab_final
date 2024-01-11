`define N 10
`define M 12

module quantizer(
	input		clk,
	input		srst_n,
	input		enable,
	input		mode,
	input  [`N:0]  dct11, dct12, dct13, dct14, dct15, dct16, dct17, dct18, 
	input  [`N:0]  dct21, dct22, dct23, dct24, dct25, dct26, dct27, dct28,
	input  [`N:0]  dct31, dct32, dct33, dct34, dct35, dct36, dct37, dct38,
	input  [`N:0]  dct41, dct42, dct43, dct44, dct45, dct46, dct47, dct48, 
	input  [`N:0]  dct51, dct52, dct53, dct54, dct55, dct56, dct57, dct58,
	input  [`N:0]  dct61, dct62, dct63, dct64, dct65, dct66, dct67, dct68,
	input  [`N:0]  dct71, dct72, dct73, dct74, dct75, dct76, dct77, dct78,
	input  [`N:0]  dct81, dct82, dct83, dct84, dct85, dct86, dct87, dct88,
	output reg  [`N:0]  q11, q12, q13, q14, q15, q16, q17, q18,
	output reg  [`N:0]  q21, q22, q23, q24, q25, q26, q27, q28,
	output reg  [`N:0]  q31, q32, q33, q34, q35, q36, q37, q38,
	output reg  [`N:0]  q41, q42, q43, q44, q45, q46, q47, q48, 
	output reg  [`N:0]  q51, q52, q53, q54, q55, q56, q57, q58, 
	output reg  [`N:0]  q61, q62, q63, q64, q65, q66, q67, q68,
	output reg  [`N:0]  q71, q72, q73, q74, q75, q76, q77, q78,
	output reg  [`N:0]  q81, q82, q83, q84, q85, q86, q87, q88,
	output reg  vaild
);
reg mode_reg;

wire [10:0] q1_1, q1_2, q1_3, q1_4, q1_5, q1_6, q1_7, q1_8;
wire [10:0] q2_1, q2_2, q2_3, q2_4, q2_5, q2_6, q2_7, q2_8;
wire [10:0] q3_1, q3_2, q3_3, q3_4, q3_5, q3_6, q3_7, q3_8;
wire [10:0] q4_1, q4_2, q4_3, q4_4, q4_5, q4_6, q4_7, q4_8;
wire [10:0] q5_1, q5_2, q5_3, q5_4, q5_5, q5_6, q5_7, q5_8;
wire [10:0] q6_1, q6_2, q6_3, q6_4, q6_5, q6_6, q6_7, q6_8;
wire [10:0] q7_1, q7_2, q7_3, q7_4, q7_5, q7_6, q7_7, q7_8;
wire [10:0] q8_1, q8_2, q8_3, q8_4, q8_5, q8_6, q8_7, q8_8;

assign q1_1 = mode_reg ? 16: 16;
assign q1_2 = mode_reg ? 32: 32;
assign q1_3 = mode_reg ? 64: 64;
assign q1_4 = mode_reg ? 64: 128;
assign q1_5 = mode_reg ? 512: 512;
assign q1_6 = mode_reg ? 512: 512;
assign q1_7 = mode_reg ? 512: 512;
assign q1_8 = mode_reg ? 512: 512;
assign q2_1 = mode_reg ? 32: 32;
assign q2_2 = mode_reg ? 64: 64;
assign q2_3 = mode_reg ? 64: 512;
assign q2_4 = mode_reg ? 512: 512;
assign q2_5 = mode_reg ? 512: 512;
assign q2_6 = mode_reg ? 512: 512;
assign q2_7 = mode_reg ? 512: 512;
assign q2_8 = mode_reg ? 512: 512;
assign q3_1 = mode_reg ? 64: 64;
assign q3_2 = mode_reg ? 512: 512;
assign q3_3 = mode_reg ? 512: 512;
assign q3_4 = mode_reg ? 512: 512;
assign q3_5 = mode_reg ? 512: 512;
assign q3_6 = mode_reg ? 512: 512;
assign q3_7 = mode_reg ? 512: 512;
assign q3_8 = mode_reg ? 512: 512;
assign q4_1 = mode_reg ? 512: 512;
assign q4_2 = mode_reg ? 512: 512;
assign q4_3 = mode_reg ? 512: 512;
assign q4_4 = mode_reg ? 512: 512;
assign q4_5 = mode_reg ? 512: 512;
assign q4_6 = mode_reg ? 512: 512;
assign q4_7 = mode_reg ? 512: 512;
assign q4_8 = mode_reg ? 512: 512;
assign q5_1 = mode_reg ? 512: 512;
assign q5_2 = mode_reg ? 512: 512;
assign q5_3 = mode_reg ? 512: 512;
assign q5_4 = mode_reg ? 512: 512;
assign q5_5 = mode_reg ? 512: 16;
assign q5_6 = mode_reg ? 512: 512;
assign q5_7 = mode_reg ? 512: 512;
assign q5_8 = mode_reg ? 512: 512;
assign q6_1 = mode_reg ? 512: 512;
assign q6_2 = mode_reg ? 512: 512;
assign q6_3 = mode_reg ? 512: 512;
assign q6_4 = mode_reg ? 512: 512;
assign q6_5 = mode_reg ? 512: 512;
assign q6_6 = mode_reg ? 512: 512;
assign q6_7 = mode_reg ? 512: 512;
assign q6_8 = mode_reg ? 512: 512;
assign q7_1 = mode_reg ? 512: 512;
assign q7_2 = mode_reg ? 512: 512;
assign q7_3 = mode_reg ? 512: 512;
assign q7_4 = mode_reg ? 512: 512;
assign q7_5 = mode_reg ? 512: 512;
assign q7_6 = mode_reg ? 512: 512;
assign q7_7 = mode_reg ? 512: 512;
assign q7_8 = mode_reg ? 512: 512;
assign q8_1 = mode_reg ? 512: 512;
assign q8_2 = mode_reg ? 512: 512;
assign q8_3 = mode_reg ? 512: 512;
assign q8_4 = mode_reg ? 512: 512;
assign q8_5 = mode_reg ? 512: 512;
assign q8_6 = mode_reg ? 512: 512;
assign q8_7 = mode_reg ? 512: 512;
assign q8_8 = mode_reg ? 512: 512;
// End of quantization Values


wire [`M:0] qM1_1;
wire [`M:0] qM1_2;
wire [`M:0] qM1_3;
wire [`M:0] qM1_4;
wire [`M:0] qM1_5;
wire [`M:0] qM1_6;
wire [`M:0] qM1_7;
wire [`M:0] qM1_8;
wire [`M:0] qM2_1;
wire [`M:0] qM2_2;
wire [`M:0] qM2_3;
wire [`M:0] qM2_4;
wire [`M:0] qM2_5;
wire [`M:0] qM2_6;
wire [`M:0] qM2_7;
wire [`M:0] qM2_8;
wire [`M:0] qM3_1;
wire [`M:0] qM3_2;
wire [`M:0] qM3_3;
wire [`M:0] qM3_4;
wire [`M:0] qM3_5;
wire [`M:0] qM3_6;
wire [`M:0] qM3_7;
wire [`M:0] qM3_8;
wire [`M:0] qM4_1;
wire [`M:0] qM4_2;
wire [`M:0] qM4_3;
wire [`M:0] qM4_4;
wire [`M:0] qM4_5;
wire [`M:0] qM4_6;
wire [`M:0] qM4_7;
wire [`M:0] qM4_8;
wire [`M:0] qM5_1;
wire [`M:0] qM5_2;
wire [`M:0] qM5_3;
wire [`M:0] qM5_4;
wire [`M:0] qM5_5;
wire [`M:0] qM5_6;
wire [`M:0] qM5_7;
wire [`M:0] qM5_8;
wire [`M:0] qM6_1;
wire [`M:0] qM6_2;
wire [`M:0] qM6_3;
wire [`M:0] qM6_4;
wire [`M:0] qM6_5;
wire [`M:0] qM6_6;
wire [`M:0] qM6_7;
wire [`M:0] qM6_8;
wire [`M:0] qM7_1;
wire [`M:0] qM7_2;
wire [`M:0] qM7_3;
wire [`M:0] qM7_4;
wire [`M:0] qM7_5;
wire [`M:0] qM7_6;
wire [`M:0] qM7_7;
wire [`M:0] qM7_8;
wire [`M:0] qM8_1;
wire [`M:0] qM8_2;
wire [`M:0] qM8_3;
wire [`M:0] qM8_4;
wire [`M:0] qM8_5;
wire [`M:0] qM8_6;
wire [`M:0] qM8_7;
wire [`M:0] qM8_8;

assign qM1_1 = 4096/q1_1;
assign qM1_2 = 4096/q1_2;
assign qM1_3 = 4096/q1_3;
assign qM1_4 = 4096/q1_4;
assign qM1_5 = 4096/q1_5;
assign qM1_6 = 4096/q1_6;
assign qM1_7 = 4096/q1_7;
assign qM1_8 = 4096/q1_8;
assign qM2_1 = 4096/q2_1;
assign qM2_2 = 4096/q2_2;
assign qM2_3 = 4096/q2_3;
assign qM2_4 = 4096/q2_4;
assign qM2_5 = 4096/q2_5;
assign qM2_6 = 4096/q2_6;
assign qM2_7 = 4096/q2_7;
assign qM2_8 = 4096/q2_8;
assign qM3_1 = 4096/q3_1;
assign qM3_2 = 4096/q3_2;
assign qM3_3 = 4096/q3_3;
assign qM3_4 = 4096/q3_4;
assign qM3_5 = 4096/q3_5;
assign qM3_6 = 4096/q3_6;
assign qM3_7 = 4096/q3_7;
assign qM3_8 = 4096/q3_8;
assign qM4_1 = 4096/q4_1;
assign qM4_2 = 4096/q4_2;
assign qM4_3 = 4096/q4_3;
assign qM4_4 = 4096/q4_4;
assign qM4_5 = 4096/q4_5;
assign qM4_6 = 4096/q4_6;
assign qM4_7 = 4096/q4_7;
assign qM4_8 = 4096/q4_8;
assign qM5_1 = 4096/q5_1;
assign qM5_2 = 4096/q5_2;
assign qM5_3 = 4096/q5_3;
assign qM5_4 = 4096/q5_4;
assign qM5_5 = 4096/q5_5;
assign qM5_6 = 4096/q5_6;
assign qM5_7 = 4096/q5_7;
assign qM5_8 = 4096/q5_8;
assign qM6_1 = 4096/q6_1;
assign qM6_2 = 4096/q6_2;
assign qM6_3 = 4096/q6_3;
assign qM6_4 = 4096/q6_4;
assign qM6_5 = 4096/q6_5;
assign qM6_6 = 4096/q6_6;
assign qM6_7 = 4096/q6_7;
assign qM6_8 = 4096/q6_8;
assign qM7_1 = 4096/q7_1;
assign qM7_2 = 4096/q7_2;
assign qM7_3 = 4096/q7_3;
assign qM7_4 = 4096/q7_4;
assign qM7_5 = 4096/q7_5;
assign qM7_6 = 4096/q7_6;
assign qM7_7 = 4096/q7_7;
assign qM7_8 = 4096/q7_8;
assign qM8_1 = 4096/q8_1;
assign qM8_2 = 4096/q8_2;
assign qM8_3 = 4096/q8_3;
assign qM8_4 = 4096/q8_4;
assign qM8_5 = 4096/q8_5;
assign qM8_6 = 4096/q8_6;
assign qM8_7 = 4096/q8_7;
assign qM8_8 = 4096/q8_8;

reg [`N+`M:0] q11_temp, q12_temp, q13_temp, q14_temp, q15_temp, q16_temp, q17_temp, q18_temp;
reg [`N+`M:0] q21_temp, q22_temp, q23_temp, q24_temp, q25_temp, q26_temp, q27_temp, q28_temp;
reg [`N+`M:0] q31_temp, q32_temp, q33_temp, q34_temp, q35_temp, q36_temp, q37_temp, q38_temp;
reg [`N+`M:0] q41_temp, q42_temp, q43_temp, q44_temp, q45_temp, q46_temp, q47_temp, q48_temp;
reg [`N+`M:0] q51_temp, q52_temp, q53_temp, q54_temp, q55_temp, q56_temp, q57_temp, q58_temp;
reg [`N+`M:0] q61_temp, q62_temp, q63_temp, q64_temp, q65_temp, q66_temp, q67_temp, q68_temp;
reg [`N+`M:0] q71_temp, q72_temp, q73_temp, q74_temp, q75_temp, q76_temp, q77_temp, q78_temp;
reg [`N+`M:0] q81_temp, q82_temp, q83_temp, q84_temp, q85_temp, q86_temp, q87_temp, q88_temp;

reg enable_1, enable_2, enable_3;
reg [`N+`M:0] dct11_temp, dct12_temp, dct13_temp, dct14_temp, dct15_temp, dct16_temp, dct17_temp, dct18_temp;
reg [`N+`M:0] dct21_temp, dct22_temp, dct23_temp, dct24_temp, dct25_temp, dct26_temp, dct27_temp, dct28_temp;
reg [`N+`M:0] dct31_temp, dct32_temp, dct33_temp, dct34_temp, dct35_temp, dct36_temp, dct37_temp, dct38_temp;
reg [`N+`M:0] dct41_temp, dct42_temp, dct43_temp, dct44_temp, dct45_temp, dct46_temp, dct47_temp, dct48_temp;
reg [`N+`M:0] dct51_temp, dct52_temp, dct53_temp, dct54_temp, dct55_temp, dct56_temp, dct57_temp, dct58_temp;
reg [`N+`M:0] dct61_temp, dct62_temp, dct63_temp, dct64_temp, dct65_temp, dct66_temp, dct67_temp, dct68_temp;
reg [`N+`M:0] dct71_temp, dct72_temp, dct73_temp, dct74_temp, dct75_temp, dct76_temp, dct77_temp, dct78_temp;
reg [`N+`M:0] dct81_temp, dct82_temp, dct83_temp, dct84_temp, dct85_temp, dct86_temp, dct87_temp, dct88_temp;

always @(posedge clk) begin
	if(~srst_n) mode_reg <= 0;
	else mode_reg <= mode;
end

always @(posedge clk) begin
	if (~srst_n) begin
		dct11_temp <= 0; dct12_temp <= 0; dct13_temp <= 0; dct14_temp <= 0;
		dct15_temp <= 0; dct16_temp <= 0; dct17_temp <= 0; dct18_temp <= 0; 
		dct21_temp <= 0; dct22_temp <= 0; dct23_temp <= 0; dct24_temp <= 0;
		dct25_temp <= 0; dct26_temp <= 0; dct27_temp <= 0; dct28_temp <= 0;
		dct31_temp <= 0; dct32_temp <= 0; dct33_temp <= 0; dct34_temp <= 0;
		dct35_temp <= 0; dct36_temp <= 0; dct37_temp <= 0; dct38_temp <= 0;
		dct41_temp <= 0; dct42_temp <= 0; dct43_temp <= 0; dct44_temp <= 0;
		dct45_temp <= 0; dct46_temp <= 0; dct47_temp <= 0; dct48_temp <= 0;
		dct51_temp <= 0; dct52_temp <= 0; dct53_temp <= 0; dct54_temp <= 0;
		dct55_temp <= 0; dct56_temp <= 0; dct57_temp <= 0; dct58_temp <= 0;
		dct61_temp <= 0; dct62_temp <= 0; dct63_temp <= 0; dct64_temp <= 0;
		dct65_temp <= 0; dct66_temp <= 0; dct67_temp <= 0; dct68_temp <= 0;
		dct71_temp <= 0; dct72_temp <= 0; dct73_temp <= 0; dct74_temp <= 0;
		dct75_temp <= 0; dct76_temp <= 0; dct77_temp <= 0; dct78_temp <= 0;
		dct81_temp <= 0; dct82_temp <= 0; dct83_temp <= 0; dct84_temp <= 0;
		dct85_temp <= 0; dct86_temp <= 0; dct87_temp <= 0; dct88_temp <= 0;
	end else if (enable) begin
		dct11_temp[`N:0] <= dct11; dct12_temp[`N:0] <= dct12; dct13_temp[`N:0] <= dct13; dct14_temp[`N:0] <= dct14;
		dct15_temp[`N:0] <= dct15; dct16_temp[`N:0] <= dct16; dct17_temp[`N:0] <= dct17; dct18_temp[`N:0] <= dct18;
		dct21_temp[`N:0] <= dct21; dct22_temp[`N:0] <= dct22; dct23_temp[`N:0] <= dct23; dct24_temp[`N:0] <= dct24;
		dct25_temp[`N:0] <= dct25; dct26_temp[`N:0] <= dct26; dct27_temp[`N:0] <= dct27; dct28_temp[`N:0] <= dct28;
		dct31_temp[`N:0] <= dct31; dct32_temp[`N:0] <= dct32; dct33_temp[`N:0] <= dct33; dct34_temp[`N:0] <= dct34;
		dct35_temp[`N:0] <= dct35; dct36_temp[`N:0] <= dct36; dct37_temp[`N:0] <= dct37; dct38_temp[`N:0] <= dct38;
		dct41_temp[`N:0] <= dct41; dct42_temp[`N:0] <= dct42; dct43_temp[`N:0] <= dct43; dct44_temp[`N:0] <= dct44;
		dct45_temp[`N:0] <= dct45; dct46_temp[`N:0] <= dct46; dct47_temp[`N:0] <= dct47; dct48_temp[`N:0] <= dct48;
		dct51_temp[`N:0] <= dct51; dct52_temp[`N:0] <= dct52; dct53_temp[`N:0] <= dct53; dct54_temp[`N:0] <= dct54;
		dct55_temp[`N:0] <= dct55; dct56_temp[`N:0] <= dct56; dct57_temp[`N:0] <= dct57; dct58_temp[`N:0] <= dct58;
		dct61_temp[`N:0] <= dct61; dct62_temp[`N:0] <= dct62; dct63_temp[`N:0] <= dct63; dct64_temp[`N:0] <= dct64;
		dct65_temp[`N:0] <= dct65; dct66_temp[`N:0] <= dct66; dct67_temp[`N:0] <= dct67; dct68_temp[`N:0] <= dct68;
		dct71_temp[`N:0] <= dct71; dct72_temp[`N:0] <= dct72; dct73_temp[`N:0] <= dct73; dct74_temp[`N:0] <= dct74;
		dct75_temp[`N:0] <= dct75; dct76_temp[`N:0] <= dct76; dct77_temp[`N:0] <= dct77; dct78_temp[`N:0] <= dct78;
		dct81_temp[`N:0] <= dct81; dct82_temp[`N:0] <= dct82; dct83_temp[`N:0] <= dct83; dct84_temp[`N:0] <= dct84;
		dct85_temp[`N:0] <= dct85; dct86_temp[`N:0] <= dct86; dct87_temp[`N:0] <= dct87; dct88_temp[`N:0] <= dct88;
		// sign extend to make dct11_temp a twos complement representation of dct11
		dct11_temp[`N+`M:`N+1] <= dct11[`N] ? `M'b111111111111 : `M'b000000000000;
		dct12_temp[`N+`M:`N+1] <= dct12[`N] ? `M'b111111111111 : `M'b000000000000;
		dct13_temp[`N+`M:`N+1] <= dct13[`N] ? `M'b111111111111 : `M'b000000000000;
		dct14_temp[`N+`M:`N+1] <= dct14[`N] ? `M'b111111111111 : `M'b000000000000;
		dct15_temp[`N+`M:`N+1] <= dct15[`N] ? `M'b111111111111 : `M'b000000000000;
		dct16_temp[`N+`M:`N+1] <= dct16[`N] ? `M'b111111111111 : `M'b000000000000;
		dct17_temp[`N+`M:`N+1] <= dct17[`N] ? `M'b111111111111 : `M'b000000000000;
		dct18_temp[`N+`M:`N+1] <= dct18[`N] ? `M'b111111111111 : `M'b000000000000;
		dct21_temp[`N+`M:`N+1] <= dct21[`N] ? `M'b111111111111 : `M'b000000000000;
		dct22_temp[`N+`M:`N+1] <= dct22[`N] ? `M'b111111111111 : `M'b000000000000;
		dct23_temp[`N+`M:`N+1] <= dct23[`N] ? `M'b111111111111 : `M'b000000000000;
		dct24_temp[`N+`M:`N+1] <= dct24[`N] ? `M'b111111111111 : `M'b000000000000;
		dct25_temp[`N+`M:`N+1] <= dct25[`N] ? `M'b111111111111 : `M'b000000000000;
		dct26_temp[`N+`M:`N+1] <= dct26[`N] ? `M'b111111111111 : `M'b000000000000;
		dct27_temp[`N+`M:`N+1] <= dct27[`N] ? `M'b111111111111 : `M'b000000000000;
		dct28_temp[`N+`M:`N+1] <= dct28[`N] ? `M'b111111111111 : `M'b000000000000;
		dct31_temp[`N+`M:`N+1] <= dct31[`N] ? `M'b111111111111 : `M'b000000000000;
		dct32_temp[`N+`M:`N+1] <= dct32[`N] ? `M'b111111111111 : `M'b000000000000;
		dct33_temp[`N+`M:`N+1] <= dct33[`N] ? `M'b111111111111 : `M'b000000000000;
		dct34_temp[`N+`M:`N+1] <= dct34[`N] ? `M'b111111111111 : `M'b000000000000;
		dct35_temp[`N+`M:`N+1] <= dct35[`N] ? `M'b111111111111 : `M'b000000000000;
		dct36_temp[`N+`M:`N+1] <= dct36[`N] ? `M'b111111111111 : `M'b000000000000;
		dct37_temp[`N+`M:`N+1] <= dct37[`N] ? `M'b111111111111 : `M'b000000000000;
		dct38_temp[`N+`M:`N+1] <= dct38[`N] ? `M'b111111111111 : `M'b000000000000;
		dct41_temp[`N+`M:`N+1] <= dct41[`N] ? `M'b111111111111 : `M'b000000000000;
		dct42_temp[`N+`M:`N+1] <= dct42[`N] ? `M'b111111111111 : `M'b000000000000;
		dct43_temp[`N+`M:`N+1] <= dct43[`N] ? `M'b111111111111 : `M'b000000000000;
		dct44_temp[`N+`M:`N+1] <= dct44[`N] ? `M'b111111111111 : `M'b000000000000;
		dct45_temp[`N+`M:`N+1] <= dct45[`N] ? `M'b111111111111 : `M'b000000000000;
		dct46_temp[`N+`M:`N+1] <= dct46[`N] ? `M'b111111111111 : `M'b000000000000;
		dct47_temp[`N+`M:`N+1] <= dct47[`N] ? `M'b111111111111 : `M'b000000000000;
		dct48_temp[`N+`M:`N+1] <= dct48[`N] ? `M'b111111111111 : `M'b000000000000;
		dct51_temp[`N+`M:`N+1] <= dct51[`N] ? `M'b111111111111 : `M'b000000000000;
		dct52_temp[`N+`M:`N+1] <= dct52[`N] ? `M'b111111111111 : `M'b000000000000;
		dct53_temp[`N+`M:`N+1] <= dct53[`N] ? `M'b111111111111 : `M'b000000000000;
		dct54_temp[`N+`M:`N+1] <= dct54[`N] ? `M'b111111111111 : `M'b000000000000;
		dct55_temp[`N+`M:`N+1] <= dct55[`N] ? `M'b111111111111 : `M'b000000000000;
		dct56_temp[`N+`M:`N+1] <= dct56[`N] ? `M'b111111111111 : `M'b000000000000;
		dct57_temp[`N+`M:`N+1] <= dct57[`N] ? `M'b111111111111 : `M'b000000000000;
		dct58_temp[`N+`M:`N+1] <= dct58[`N] ? `M'b111111111111 : `M'b000000000000;
		dct61_temp[`N+`M:`N+1] <= dct61[`N] ? `M'b111111111111 : `M'b000000000000;
		dct62_temp[`N+`M:`N+1] <= dct62[`N] ? `M'b111111111111 : `M'b000000000000;
		dct63_temp[`N+`M:`N+1] <= dct63[`N] ? `M'b111111111111 : `M'b000000000000;
		dct64_temp[`N+`M:`N+1] <= dct64[`N] ? `M'b111111111111 : `M'b000000000000;
		dct65_temp[`N+`M:`N+1] <= dct65[`N] ? `M'b111111111111 : `M'b000000000000;
		dct66_temp[`N+`M:`N+1] <= dct66[`N] ? `M'b111111111111 : `M'b000000000000;
		dct67_temp[`N+`M:`N+1] <= dct67[`N] ? `M'b111111111111 : `M'b000000000000;
		dct68_temp[`N+`M:`N+1] <= dct68[`N] ? `M'b111111111111 : `M'b000000000000;
		dct71_temp[`N+`M:`N+1] <= dct71[`N] ? `M'b111111111111 : `M'b000000000000;
		dct72_temp[`N+`M:`N+1] <= dct72[`N] ? `M'b111111111111 : `M'b000000000000;
		dct73_temp[`N+`M:`N+1] <= dct73[`N] ? `M'b111111111111 : `M'b000000000000;
		dct74_temp[`N+`M:`N+1] <= dct74[`N] ? `M'b111111111111 : `M'b000000000000;
		dct75_temp[`N+`M:`N+1] <= dct75[`N] ? `M'b111111111111 : `M'b000000000000;
		dct76_temp[`N+`M:`N+1] <= dct76[`N] ? `M'b111111111111 : `M'b000000000000;
		dct77_temp[`N+`M:`N+1] <= dct77[`N] ? `M'b111111111111 : `M'b000000000000;
		dct78_temp[`N+`M:`N+1] <= dct78[`N] ? `M'b111111111111 : `M'b000000000000;
		dct81_temp[`N+`M:`N+1] <= dct81[`N] ? `M'b111111111111 : `M'b000000000000;
		dct82_temp[`N+`M:`N+1] <= dct82[`N] ? `M'b111111111111 : `M'b000000000000;
		dct83_temp[`N+`M:`N+1] <= dct83[`N] ? `M'b111111111111 : `M'b000000000000;
		dct84_temp[`N+`M:`N+1] <= dct84[`N] ? `M'b111111111111 : `M'b000000000000;
		dct85_temp[`N+`M:`N+1] <= dct85[`N] ? `M'b111111111111 : `M'b000000000000;
		dct86_temp[`N+`M:`N+1] <= dct86[`N] ? `M'b111111111111 : `M'b000000000000;
		dct87_temp[`N+`M:`N+1] <= dct87[`N] ? `M'b111111111111 : `M'b000000000000;
		dct88_temp[`N+`M:`N+1] <= dct88[`N] ? `M'b111111111111 : `M'b000000000000;	 
	end
end	   

always @(posedge clk) begin
	if (~srst_n) begin
		q11_temp <= 0;
		q12_temp <= 0;
		q13_temp <= 0;
		q14_temp <= 0;
		q15_temp <= 0;
		q16_temp <= 0;
		q17_temp <= 0;
		q18_temp <= 0;
		q21_temp <= 0;
		q22_temp <= 0;
		q23_temp <= 0;
		q24_temp <= 0;
		q25_temp <= 0;
		q26_temp <= 0;
		q27_temp <= 0;
		q28_temp <= 0;
		q31_temp <= 0;
		q32_temp <= 0;
		q33_temp <= 0;
		q34_temp <= 0;
		q35_temp <= 0;
		q36_temp <= 0;
		q37_temp <= 0;
		q38_temp <= 0;
		q41_temp <= 0;
		q42_temp <= 0;
		q43_temp <= 0;
		q44_temp <= 0;
		q45_temp <= 0;
		q46_temp <= 0;
		q47_temp <= 0;
		q48_temp <= 0;
		q51_temp <= 0;
		q52_temp <= 0;
		q53_temp <= 0;
		q54_temp <= 0;
		q55_temp <= 0;
		q56_temp <= 0;
		q57_temp <= 0;
		q58_temp <= 0;
		q61_temp <= 0;
		q62_temp <= 0;
		q63_temp <= 0;
		q64_temp <= 0;
		q65_temp <= 0;
		q66_temp <= 0;
		q67_temp <= 0;
		q68_temp <= 0;
		q71_temp <= 0;
		q72_temp <= 0;
		q73_temp <= 0;
		q74_temp <= 0;
		q75_temp <= 0;
		q76_temp <= 0;
		q77_temp <= 0;
		q78_temp <= 0;
		q81_temp <= 0;
		q82_temp <= 0;
		q83_temp <= 0;
		q84_temp <= 0;
		q85_temp <= 0;
		q86_temp <= 0;
		q87_temp <= 0;
		q88_temp <= 0;
	end else if (enable_1) begin
		q11_temp <= dct11_temp * qM1_1;
		q12_temp <= dct12_temp * qM1_2;
		q13_temp <= dct13_temp * qM1_3;
		q14_temp <= dct14_temp * qM1_4;
		q15_temp <= dct15_temp * qM1_5;
		q16_temp <= dct16_temp * qM1_6;
		q17_temp <= dct17_temp * qM1_7;
		q18_temp <= dct18_temp * qM1_8;
		q21_temp <= dct21_temp * qM2_1;
		q22_temp <= dct22_temp * qM2_2;
		q23_temp <= dct23_temp * qM2_3;
		q24_temp <= dct24_temp * qM2_4;
		q25_temp <= dct25_temp * qM2_5;
		q26_temp <= dct26_temp * qM2_6;
		q27_temp <= dct27_temp * qM2_7;
		q28_temp <= dct28_temp * qM2_8;
		q31_temp <= dct31_temp * qM3_1;
		q32_temp <= dct32_temp * qM3_2;
		q33_temp <= dct33_temp * qM3_3;
		q34_temp <= dct34_temp * qM3_4;
		q35_temp <= dct35_temp * qM3_5;
		q36_temp <= dct36_temp * qM3_6;
		q37_temp <= dct37_temp * qM3_7;
		q38_temp <= dct38_temp * qM3_8;
		q41_temp <= dct41_temp * qM4_1;
		q42_temp <= dct42_temp * qM4_2;
		q43_temp <= dct43_temp * qM4_3;
		q44_temp <= dct44_temp * qM4_4;
		q45_temp <= dct45_temp * qM4_5;
		q46_temp <= dct46_temp * qM4_6;
		q47_temp <= dct47_temp * qM4_7;
		q48_temp <= dct48_temp * qM4_8;
		q51_temp <= dct51_temp * qM5_1;
		q52_temp <= dct52_temp * qM5_2;
		q53_temp <= dct53_temp * qM5_3;
		q54_temp <= dct54_temp * qM5_4;
		q55_temp <= dct55_temp * qM5_5;
		q56_temp <= dct56_temp * qM5_6;
		q57_temp <= dct57_temp * qM5_7;
		q58_temp <= dct58_temp * qM5_8;
		q61_temp <= dct61_temp * qM6_1;
		q62_temp <= dct62_temp * qM6_2;
		q63_temp <= dct63_temp * qM6_3;
		q64_temp <= dct64_temp * qM6_4;
		q65_temp <= dct65_temp * qM6_5;
		q66_temp <= dct66_temp * qM6_6;
		q67_temp <= dct67_temp * qM6_7;
		q68_temp <= dct68_temp * qM6_8;
		q71_temp <= dct71_temp * qM7_1;
		q72_temp <= dct72_temp * qM7_2;
		q73_temp <= dct73_temp * qM7_3;
		q74_temp <= dct74_temp * qM7_4;
		q75_temp <= dct75_temp * qM7_5;
		q76_temp <= dct76_temp * qM7_6;
		q77_temp <= dct77_temp * qM7_7;
		q78_temp <= dct78_temp * qM7_8;
		q81_temp <= dct81_temp * qM8_1;
		q82_temp <= dct82_temp * qM8_2;
		q83_temp <= dct83_temp * qM8_3;
		q84_temp <= dct84_temp * qM8_4;
		q85_temp <= dct85_temp * qM8_5;
		q86_temp <= dct86_temp * qM8_6;
		q87_temp <= dct87_temp * qM8_7;
		q88_temp <= dct88_temp * qM8_8;
	end
end	 


always @(posedge clk) begin
	if (~srst_n) begin
		q11 <= 0; q12 <= 0; q13 <= 0; q14 <= 0; q15 <= 0; q16 <= 0; q17 <= 0; q18 <= 0;
		q21 <= 0; q22 <= 0; q23 <= 0; q24 <= 0; q25 <= 0; q26 <= 0; q27 <= 0; q28 <= 0;
		q31 <= 0; q32 <= 0; q33 <= 0; q34 <= 0; q35 <= 0; q36 <= 0; q37 <= 0; q38 <= 0;
		q41 <= 0; q42 <= 0; q43 <= 0; q44 <= 0; q45 <= 0; q46 <= 0; q47 <= 0; q48 <= 0;
		q51 <= 0; q52 <= 0; q53 <= 0; q54 <= 0; q55 <= 0; q56 <= 0; q57 <= 0; q58 <= 0;
		q61 <= 0; q62 <= 0; q63 <= 0; q64 <= 0; q65 <= 0; q66 <= 0; q67 <= 0; q68 <= 0;
		q71 <= 0; q72 <= 0; q73 <= 0; q74 <= 0; q75 <= 0; q76 <= 0; q77 <= 0; q78 <= 0;
		q81 <= 0; q82 <= 0; q83 <= 0; q84 <= 0; q85 <= 0; q86 <= 0; q87 <= 0; q88 <= 0;
	end else if (enable_2) begin
		// rounding q11 based on the bit in the 11th place of dct11_temp	
		q11 <= q11_temp[`N+1] + q11_temp[`N+`M:`M];
		q12 <= q12_temp[`N+1] + q12_temp[`N+`M:`M];
		q13 <= q13_temp[`N+1] + q13_temp[`N+`M:`M];
		q14 <= q14_temp[`N+1] + q14_temp[`N+`M:`M];
		q15 <= q15_temp[`N+1] + q15_temp[`N+`M:`M];
		q16 <= q16_temp[`N+1] + q16_temp[`N+`M:`M];
		q17 <= q17_temp[`N+1] + q17_temp[`N+`M:`M];
		q18 <= q18_temp[`N+1] + q18_temp[`N+`M:`M];
		q21 <= q21_temp[`N+1] + q21_temp[`N+`M:`M];
		q22 <= q22_temp[`N+1] + q22_temp[`N+`M:`M];
		q23 <= q23_temp[`N+1] + q23_temp[`N+`M:`M];
		q24 <= q24_temp[`N+1] + q24_temp[`N+`M:`M];
		q25 <= q25_temp[`N+1] + q25_temp[`N+`M:`M];
		q26 <= q26_temp[`N+1] + q26_temp[`N+`M:`M];
		q27 <= q27_temp[`N+1] + q27_temp[`N+`M:`M];
		q28 <= q28_temp[`N+1] + q28_temp[`N+`M:`M];
		q31 <= q31_temp[`N+1] + q31_temp[`N+`M:`M];
		q32 <= q32_temp[`N+1] + q32_temp[`N+`M:`M];
		q33 <= q33_temp[`N+1] + q33_temp[`N+`M:`M];
		q34 <= q34_temp[`N+1] + q34_temp[`N+`M:`M];
		q35 <= q35_temp[`N+1] + q35_temp[`N+`M:`M];
		q36 <= q36_temp[`N+1] + q36_temp[`N+`M:`M];
		q37 <= q37_temp[`N+1] + q37_temp[`N+`M:`M];
		q38 <= q38_temp[`N+1] + q38_temp[`N+`M:`M];
		q41 <= q41_temp[`N+1] + q41_temp[`N+`M:`M];
		q42 <= q42_temp[`N+1] + q42_temp[`N+`M:`M];
		q43 <= q43_temp[`N+1] + q43_temp[`N+`M:`M];
		q44 <= q44_temp[`N+1] + q44_temp[`N+`M:`M];
		q45 <= q45_temp[`N+1] + q45_temp[`N+`M:`M];
		q46 <= q46_temp[`N+1] + q46_temp[`N+`M:`M];
		q47 <= q47_temp[`N+1] + q47_temp[`N+`M:`M];
		q48 <= q48_temp[`N+1] + q48_temp[`N+`M:`M];
		q51 <= q51_temp[`N+1] + q51_temp[`N+`M:`M];
		q52 <= q52_temp[`N+1] + q52_temp[`N+`M:`M];
		q53 <= q53_temp[`N+1] + q53_temp[`N+`M:`M];
		q54 <= q54_temp[`N+1] + q54_temp[`N+`M:`M];
		q55 <= q55_temp[`N+1] + q55_temp[`N+`M:`M];
		q56 <= q56_temp[`N+1] + q56_temp[`N+`M:`M];
		q57 <= q57_temp[`N+1] + q57_temp[`N+`M:`M];
		q58 <= q58_temp[`N+1] + q58_temp[`N+`M:`M];
		q61 <= q61_temp[`N+1] + q61_temp[`N+`M:`M];
		q62 <= q62_temp[`N+1] + q62_temp[`N+`M:`M];
		q63 <= q63_temp[`N+1] + q63_temp[`N+`M:`M];
		q64 <= q64_temp[`N+1] + q64_temp[`N+`M:`M];
		q65 <= q65_temp[`N+1] + q65_temp[`N+`M:`M];
		q66 <= q66_temp[`N+1] + q66_temp[`N+`M:`M];
		q67 <= q67_temp[`N+1] + q67_temp[`N+`M:`M];
		q68 <= q68_temp[`N+1] + q68_temp[`N+`M:`M];
		q71 <= q71_temp[`N+1] + q71_temp[`N+`M:`M];
		q72 <= q72_temp[`N+1] + q72_temp[`N+`M:`M];
		q73 <= q73_temp[`N+1] + q73_temp[`N+`M:`M];
		q74 <= q74_temp[`N+1] + q74_temp[`N+`M:`M];
		q75 <= q75_temp[`N+1] + q75_temp[`N+`M:`M];
		q76 <= q76_temp[`N+1] + q76_temp[`N+`M:`M];
		q77 <= q77_temp[`N+1] + q77_temp[`N+`M:`M];
		q78 <= q78_temp[`N+1] + q78_temp[`N+`M:`M];
		q81 <= q81_temp[`N+1] + q81_temp[`N+`M:`M];
		q82 <= q82_temp[`N+1] + q82_temp[`N+`M:`M];
		q83 <= q83_temp[`N+1] + q83_temp[`N+`M:`M];
		q84 <= q84_temp[`N+1] + q84_temp[`N+`M:`M];
		q85 <= q85_temp[`N+1] + q85_temp[`N+`M:`M];
		q86 <= q86_temp[`N+1] + q86_temp[`N+`M:`M];
		q87 <= q87_temp[`N+1] + q87_temp[`N+`M:`M];
		q88 <= q88_temp[`N+1] + q88_temp[`N+`M:`M];
	end
end	 


always @(posedge clk) begin
	if (~srst_n) begin
		enable_1 <= 0; 
		enable_2 <= 0;
		enable_3 <= 0;
		vaild <= 0;
		end
	else begin
		enable_1 <= enable; 
		enable_2 <= enable_1;
		enable_3 <= enable_2;
		vaild <= enable_3;
		end
end	


endmodule
module huffman(
    input clk,
    input rst_n,
    input valid,
    input [180-1:0] sram_data,
    output reg  [10-1:0] sram_addr,

    input [11:0] DC,
    input [60-1:0] R,
    input [60-1:0] L,
    input [60-1:0] F,

    output reg [8-1:0] code_length,
    output reg [256-1:0] code_out
);


reg [2:0] state;
reg [2:0] state_next;

reg [8-1:0] code_length_next;
reg [256-1:0] code_out_next;

reg [10-1:0] sram_addr_next;
reg [180-1:0] sram_data_ff;

reg [10:0] AC_frequency [0:256-1];
reg [10:0] AC_frequency_next [0:256-1];

reg [10:0] min1;
reg [10:0] min2;

reg [256-1:0] AC_hcode [0:256-1];
reg [256-1:0] AC_hcode_next [0:256-1];

reg [8:0] AC_length [0:256-1];
reg [8:0] AC_length_next [0:256-1];

reg [256-1:0] layer [0:256-1];
reg [256-1:0] layer_next [0:256-1];

reg count_finish,build_finish,encode_finish;

localparam IDLE = 3'b000, COUNT = 3'b001, TREE = 3'b010, ENCODE = 3'b011, FINISH = 3'b100;

integer i,j,k,l,m,n,o,p;

//layer_next
always@(*) begin
    for (i = 0;i < 256;i = i + 1) begin
        AC_frequency_next[i] = AC_frequency[i] + 1;
        AC_length_next[i] = AC_length[i] + 1;
    end
    for (i = 0;i < 255;i = i + 1) begin
        layer_next[i] = layer[i] | layer[i + 1];
        AC_hcode_next[i] = AC_hcode[i] | AC_hcode[i + 1];
    end
    layer_next[255] = layer[255];
    AC_hcode_next[255] = AC_hcode[255];
end

reg [10:0] min1_1 [0:64-1];
reg [10:0] min2_1 [0:64-1];
reg [10:0] min1_2 [0:32-1];
reg [10:0] min2_2 [0:32-1];
reg [10:0] min1_3 [0:16-1];
reg [10:0] min2_3 [0:16-1];
reg [10:0] min1_4 [0:8-1];
reg [10:0] min2_4 [0:8-1];
reg [10:0] min1_5 [0:4-1];
reg [10:0] min2_5 [0:4-1];
reg [10:0] min1_6 [0:2-1];
reg [10:0] min2_6 [0:2-1];

reg [2-1:0] min1_addr1 [0:64-1];
reg [2-1:0] min2_addr1 [0:64-1];
reg [2-1:0] min1_addr2 [0:32-1];
reg [2-1:0] min2_addr2 [0:32-1];
reg [2-1:0] min1_addr3 [0:16-1];
reg [2-1:0] min2_addr3 [0:16-1];
reg [2-1:0] min1_addr4 [0:8-1];
reg [2-1:0] min2_addr4 [0:8-1];
reg [2-1:0] min1_addr5 [0:4-1];
reg [2-1:0] min2_addr5 [0:4-1];
reg [2-1:0] min1_addr6 [0:2-1];
reg [2-1:0] min2_addr6 [0:2-1];
reg [2-1:0] min1_addr7;
reg [2-1:0] min2_addr7;

//select 2min from256
select4to2 U0 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[0]),.input1(AC_frequency[1]),.input2(AC_frequency[2]),
              .input3(AC_frequency[3]),.min1_addr(min1_addr1[0]),.min2_addr(min2_addr1[0]).min1(min1_1[0]),.min2(min2_1[0]));
select4to2 U1 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[4]),.input1(AC_frequency[5]),.input2(AC_frequency[6]),
               .input3(AC_frequency[7]),.min1_addr(min1_addr1[1]),.min2_addr(min2_addr1[1]).min1(min1_1[1]),.min2(min2_1[1]));
select4to2 U2 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[8]),.input1(AC_frequency[9]),.input2(AC_frequency[10]),
              .input3(AC_frequency[11]),.min1_addr(min1_addr1[2]),.min2_addr(min2_addr1[2]).min1(min1_1[2]),.min2(min2_1[2]));
select4to2 U3 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[12]),.input1(AC_frequency[13]),.input2(AC_frequency[14]),
              .input3(AC_frequency[15]),.min1_addr(min1_addr1[3]),.min2_addr(min2_addr1[3]).min1(min1_1[3]),.min2(min2_1[3]));
select4to2 U4 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[16]),.input1(AC_frequency[17]),.input2(AC_frequency[18]),
              .input3(AC_frequency[19]),.min1_addr(min1_addr1[4]),.min2_addr(min2_addr1[4]).min1(min1_1[4]),.min2(min2_1[4]));
select4to2 U5 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[20]),.input1(AC_frequency[21]),.input2(AC_frequency[22]),
              .input3(AC_frequency[23]),.min1_addr(min1_addr1[5]),.min2_addr(min2_addr1[5]).min1(min1_1[5]),.min2(min2_1[5]));
select4to2 U6 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[24]),.input1(AC_frequency[25]),.input2(AC_frequency[26]),
              .input3(AC_frequency[27]),.min1_addr(min1_addr1[6]),.min2_addr(min2_addr1[6]).min1(min1_1[6]),.min2(min2_1[6]));
select4to2 U7 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[28]),.input1(AC_frequency[29]),.input2(AC_frequency[30]),
              .input3(AC_frequency[31]),.min1_addr(min1_addr1[7]),.min2_addr(min2_addr1[7]).min1(min1_1[7]),.min2(min2_1[7]));
select4to2 U8 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[32]),.input1(AC_frequency[33]),.input2(AC_frequency[34]),
              .input3(AC_frequency[35]),.min1_addr(min1_addr1[8]),.min2_addr(min2_addr1[8]).min1(min1_1[8]),.min2(min2_1[8]));
select4to2 U9 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[36]),.input1(AC_frequency[37]),.input2(AC_frequency[38]),
              .input3(AC_frequency[39]),.min1_addr(min1_addr1[9]),.min2_addr(min2_addr1[9]).min1(min1_1[9]),.min2(min2_1[9]));
select4to2 U10 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[40]),.input1(AC_frequency[41]),.input2(AC_frequency[42]),
                .input3(AC_frequency[43]),.min1_addr(min1_addr1[10]),.min2_addr(min2_addr1[10]).min1(min1_1[10]),.min2(min2_1[10]));
select4to2 U11 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[44]),.input1(AC_frequency[45]),.input2(AC_frequency[46]),
              .input3(AC_frequency[47]),.min1_addr(min1_addr1[11]),.min2_addr(min2_addr1[11]).min1(min1_1[11]),.min2(min2_1[11]));
select4to2 U12 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[48]),.input1(AC_frequency[49]),.input2(AC_frequency[50]),
              .input3(AC_frequency[51]),.min1_addr(min1_addr1[12]),.min2_addr(min2_addr1[12]).min1(min1_1[12]),.min2(min2_1[12]));
select4to2 U13 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[52]),.input1(AC_frequency[53]),.input2(AC_frequency[54]),
              .input3(AC_frequency[55]),.min1_addr(min1_addr1[13]),.min2_addr(min2_addr1[13]).min1(min1_1[13]),.min2(min2_1[13]));
select4to2 U14 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[56]),.input1(AC_frequency[57]),.input2(AC_frequency[58]),
              .input3(AC_frequency[59]),.min1_addr(min1_addr1[14]),.min2_addr(min2_addr1[14]).min1(min1_1[14]),.min2(min2_1[14]));
select4to2 U15 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[60]),.input1(AC_frequency[61]),.input2(AC_frequency[62]),
              .input3(AC_frequency[63]),.min1_addr(min1_addr1[15]),.min2_addr(min2_addr1[15]).min1(min1_1[15]),.min2(min2_1[15]));
select4to2 U16 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[64]),.input1(AC_frequency[65]),.input2(AC_frequency[66]),
              .input3(AC_frequency[67]),.min1_addr(min1_addr1[16]),.min2_addr(min2_addr1[16]).min1(min1_1[16]),.min2(min2_1[16]));
select4to2 U17 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[68]),.input1(AC_frequency[69]),.input2(AC_frequency[70]),
              .input3(AC_frequency[71]),.min1_addr(min1_addr1[17]),.min2_addr(min2_addr1[17]).min1(min1_1[17]),.min2(min2_1[17]));
select4to2 U18 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[72]),.input1(AC_frequency[73]),.input2(AC_frequency[74]),
              .input3(AC_frequency[75]),.min1_addr(min1_addr1[18]),.min2_addr(min2_addr1[18]).min1(min1_1[18]),.min2(min2_1[18]));
select4to2 U19 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[76]),.input1(AC_frequency[77]),.input2(AC_frequency[78]),
              .input3(AC_frequency[79]),.min1_addr(min1_addr1[19]),.min2_addr(min2_addr1[19]).min1(min1_1[19]),.min2(min2_1[19]));
select4to2 U20 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[80]),.input1(AC_frequency[81]),.input2(AC_frequency[82]),
              .input3(AC_frequency[83]),.min1_addr(min1_addr1[20]),.min2_addr(min2_addr1[20]).min1(min1_1[20]),.min2(min2_1[20]));
select4to2 U21 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[84]),.input1(AC_frequency[85]),.input2(AC_frequency[86]),
              .input3(AC_frequency[87]),.min1_addr(min1_addr1[21]),.min2_addr(min2_addr1[21]).min1(min1_1[21]),.min2(min2_1[21]));
select4to2 U22 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[88]),.input1(AC_frequency[89]),.input2(AC_frequency[90]),
              .input3(AC_frequency[91]),.min1_addr(min1_addr1[22]),.min2_addr(min2_addr1[22]).min1(min1_1[22]),.min2(min2_1[22]));
select4to2 U23 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[92]),.input1(AC_frequency[93]),.input2(AC_frequency[94]),
              .input3(AC_frequency[95]),.min1_addr(min1_addr1[23]),.min2_addr(min2_addr1[23]).min1(min1_1[23]),.min2(min2_1[23]));
select4to2 U24 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[96]),.input1(AC_frequency[97]),.input2(AC_frequency[98]),
              .input3(AC_frequency[99]),.min1_addr(min1_addr1[24]),.min2_addr(min2_addr1[24]).min1(min1_1[24]),.min2(min2_1[24]));
select4to2 U25 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[100]),.input1(AC_frequency[101]),.input2(AC_frequency[102]),
              .input3(AC_frequency[103]),.min1_addr(min1_addr1[25]),.min2_addr(min2_addr1[25]).min1(min1_1[25]),.min2(min2_1[25]));
select4to2 U26 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[104]),.input1(AC_frequency[105]),.input2(AC_frequency[106]),
              .input3(AC_frequency[107]),.min1_addr(min1_addr1[26]),.min2_addr(min2_addr1[26]).min1(min1_1[26]),.min2(min2_1[26]));
select4to2 U27 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[108]),.input1(AC_frequency[109]),.input2(AC_frequency[110]),
              .input3(AC_frequency[111]),.min1_addr(min1_addr1[27]),.min2_addr(min2_addr1[27]).min1(min1_1[27]),.min2(min2_1[27]));
select4to2 U28 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[112]),.input1(AC_frequency[113]),.input2(AC_frequency[114]),
              .input3(AC_frequency[115]),.min1_addr(min1_addr1[28]),.min2_addr(min2_addr1[28]).min1(min1_1[28]),.min2(min2_1[28]));
select4to2 U29 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[116]),.input1(AC_frequency[117]),.input2(AC_frequency[118]),
              .input3(AC_frequency[119]),.min1_addr(min1_addr1[29]),.min2_addr(min2_addr1[29]).min1(min1_1[29]),.min2(min2_1[29]));
select4to2 U30 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[120]),.input1(AC_frequency[121]),.input2(AC_frequency[122]),
              .input3(AC_frequency[123]),.min1_addr(min1_addr1[30]),.min2_addr(min2_addr1[30]).min1(min1_1[30]),.min2(min2_1[30]));
select4to2 U31 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[124]),.input1(AC_frequency[125]),.input2(AC_frequency[126]),
              .input3(AC_frequency[127]),.min1_addr(min1_addr1[31]),.min2_addr(min2_addr1[31]).min1(min1_1[31]),.min2(min2_1[31]));
select4to2 U32 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[128]),.input1(AC_frequency[129]),.input2(AC_frequency[130]),
              .input3(AC_frequency[131]),.min1_addr(min1_addr1[32]),.min2_addr(min2_addr1[32]).min1(min1_1[32]),.min2(min2_1[32]));
select4to2 U33 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[132]),.input1(AC_frequency[133]),.input2(AC_frequency[134]),
              .input3(AC_frequency[135]),.min1_addr(min1_addr1[33]),.min2_addr(min2_addr1[33]).min1(min1_1[33]),.min2(min2_1[33]));
select4to2 U34 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[136]),.input1(AC_frequency[137]),.input2(AC_frequency[138]),
              .input3(AC_frequency[139]),.min1_addr(min1_addr1[34]),.min2_addr(min2_addr1[34]).min1(min1_1[34]),.min2(min2_1[34]));
select4to2 U35 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[140]),.input1(AC_frequency[141]),.input2(AC_frequency[142]),
              .input3(AC_frequency[143]),.min1_addr(min1_addr1[35]),.min2_addr(min2_addr1[35]).min1(min1_1[35]),.min2(min2_1[35]));
select4to2 U36 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[144]),.input1(AC_frequency[145]),.input2(AC_frequency[146]),
              .input3(AC_frequency[147]),.min1_addr(min1_addr1[36]),.min2_addr(min2_addr1[36]).min1(min1_1[36]),.min2(min2_1[36]));
select4to2 U37 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[148]),.input1(AC_frequency[149]),.input2(AC_frequency[150]),
              .input3(AC_frequency[151]),.min1_addr(min1_addr1[37]),.min2_addr(min2_addr1[37]).min1(min1_1[37]),.min2(min2_1[37]));
select4to2 U38 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[152]),.input1(AC_frequency[153]),.input2(AC_frequency[154]),
              .input3(AC_frequency[155]),.min1_addr(min1_addr1[38]),.min2_addr(min2_addr1[38]).min1(min1_1[38]),.min2(min2_1[38]));
select4to2 U39 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[156]),.input1(AC_frequency[157]),.input2(AC_frequency[158]),
              .input3(AC_frequency[159]),.min1_addr(min1_addr1[39]),.min2_addr(min2_addr1[39]).min1(min1_1[39]),.min2(min2_1[39]));
select4to2 U40 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[160]),.input1(AC_frequency[161]),.input2(AC_frequency[162]),
              .input3(AC_frequency[163]),.min1_addr(min1_addr1[40]),.min2_addr(min2_addr1[40]).min1(min1_1[40]),.min2(min2_1[40]));
select4to2 U41 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[164]),.input1(AC_frequency[165]),.input2(AC_frequency[166]),
              .input3(AC_frequency[167]),.min1_addr(min1_addr1[41]),.min2_addr(min2_addr1[41]).min1(min1_1[41]),.min2(min2_1[41]));
select4to2 U42 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[168]),.input1(AC_frequency[169]),.input2(AC_frequency[170]),
              .input3(AC_frequency[171]),.min1_addr(min1_addr1[42]),.min2_addr(min2_addr1[42]).min1(min1_1[42]),.min2(min2_1[42]));
select4to2 U43 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[172]),.input1(AC_frequency[173]),.input2(AC_frequency[174]),
              .input3(AC_frequency[175]),.min1_addr(min1_addr1[43]),.min2_addr(min2_addr1[43]).min1(min1_1[43]),.min2(min2_1[43]));
select4to2 U44 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[176]),.input1(AC_frequency[177]),.input2(AC_frequency[178]),
              .input3(AC_frequency[179]),.min1_addr(min1_addr1[44]),.min2_addr(min2_addr1[44]).min1(min1_1[44]),.min2(min2_1[44]));
select4to2 U45 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[180]),.input1(AC_frequency[181]),.input2(AC_frequency[182]),
              .input3(AC_frequency[183]),.min1_addr(min1_addr1[45]),.min2_addr(min2_addr1[45]).min1(min1_1[45]),.min2(min2_1[45]));
select4to2 U46 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[184]),.input1(AC_frequency[185]),.input2(AC_frequency[186]),
              .input3(AC_frequency[187]),.min1_addr(min1_addr1[46]),.min2_addr(min2_addr1[46]).min1(min1_1[46]),.min2(min2_1[46]));
select4to2 U47 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[188]),.input1(AC_frequency[189]),.input2(AC_frequency[190]),
              .input3(AC_frequency[191]),.min1_addr(min1_addr1[47]),.min2_addr(min2_addr1[47]).min1(min1_1[47]),.min2(min2_1[47]));
select4to2 U48 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[192]),.input1(AC_frequency[193]),.input2(AC_frequency[194]),
              .input3(AC_frequency[195]),.min1_addr(min1_addr1[48]),.min2_addr(min2_addr1[48]).min1(min1_1[48]),.min2(min2_1[48]));
select4to2 U49 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[196]),.input1(AC_frequency[197]),.input2(AC_frequency[198]),
              .input3(AC_frequency[199]),.min1_addr(min1_addr1[49]),.min2_addr(min2_addr1[49]).min1(min1_1[49]),.min2(min2_1[49]));
select4to2 U50 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[200]),.input1(AC_frequency[201]),.input2(AC_frequency[202]),
              .input3(AC_frequency[203]),.min1_addr(min1_addr1[50]),.min2_addr(min2_addr1[50]).min1(min1_1[50]),.min2(min2_1[50]));
select4to2 U51 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[204]),.input1(AC_frequency[205]),.input2(AC_frequency[206]),
              .input3(AC_frequency[207]),.min1_addr(min1_addr1[51]),.min2_addr(min2_addr1[51]).min1(min1_1[51]),.min2(min2_1[51]));
select4to2 U52 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[208]),.input1(AC_frequency[209]),.input2(AC_frequency[210]),
              .input3(AC_frequency[211]),.min1_addr(min1_addr1[52]),.min2_addr(min2_addr1[52]).min1(min1_1[52]),.min2(min2_1[52]));
select4to2 U53 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[212]),.input1(AC_frequency[213]),.input2(AC_frequency[214]),
              .input3(AC_frequency[215]),.min1_addr(min1_addr1[53]),.min2_addr(min2_addr1[53]).min1(min1_1[53]),.min2(min2_1[53]));
select4to2 U54 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[216]),.input1(AC_frequency[217]),.input2(AC_frequency[218]),
              .input3(AC_frequency[219]),.min1_addr(min1_addr1[54]),.min2_addr(min2_addr1[54]).min1(min1_1[54]),.min2(min2_1[54]));
select4to2 U55 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[220]),.input1(AC_frequency[221]),.input2(AC_frequency[222]),
              .input3(AC_frequency[223]),.min1_addr(min1_addr1[55]),.min2_addr(min2_addr1[55]).min1(min1_1[55]),.min2(min2_1[55]));
select4to2 U56 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[224]),.input1(AC_frequency[225]),.input2(AC_frequency[226]),
              .input3(AC_frequency[227]),.min1_addr(min1_addr1[56]),.min2_addr(min2_addr1[56]).min1(min1_1[56]),.min2(min2_1[56]));
select4to2 U57 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[228]),.input1(AC_frequency[229]),.input2(AC_frequency[230]),
              .input3(AC_frequency[231]),.min1_addr(min1_addr1[57]),.min2_addr(min2_addr1[57]).min1(min1_1[57]),.min2(min2_1[57]));
select4to2 U58 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[232]),.input1(AC_frequency[233]),.input2(AC_frequency[234]),
              .input3(AC_frequency[235]),.min1_addr(min1_addr1[58]),.min2_addr(min2_addr1[58]).min1(min1_1[58]),.min2(min2_1[58]));
select4to2 U59 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[236]),.input1(AC_frequency[237]),.input2(AC_frequency[238]),
              .input3(AC_frequency[239]),.min1_addr(min1_addr1[59]),.min2_addr(min2_addr1[59]).min1(min1_1[59]),.min2(min2_1[59]));
select4to2 U60 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[240]),.input1(AC_frequency[241]),.input2(AC_frequency[242]),
              .input3(AC_frequency[243]),.min1_addr(min1_addr1[60]),.min2_addr(min2_addr1[60]).min1(min1_1[60]),.min2(min2_1[60]));
select4to2 U61 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[244]),.input1(AC_frequency[245]),.input2(AC_frequency[246]),
              .input3(AC_frequency[247]),.min1_addr(min1_addr1[61]),.min2_addr(min2_addr1[61]).min1(min1_1[61]),.min2(min2_1[61]));
select4to2 U62 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[248]),.input1(AC_frequency[249]),.input2(AC_frequency[250]),
              .input3(AC_frequency[251]),.min1_addr(min1_addr1[62]),.min2_addr(min2_addr1[62]).min1(min1_1[62]),.min2(min2_1[62]));
select4to2 U63 (.rst_n(rst_n),.clk(clk),.input0(AC_frequency[252]),.input1(AC_frequency[253]),.input2(AC_frequency[254]),
              .input3(AC_frequency[255]),.min1_addr(min1_addr1[63]),.min2_addr(min2_addr1[63]).min1(min1_1[63]),.min2(min2_1[63]));
select4to2 U64 (.rst_n(rst_n),.clk(clk),.input0(min1_1[0]),.input1(min2_1[0]),.input2(min1_1[1]),
              .input3(min2_1[1]),.min1_addr(min1_addr2[0]),.min2_addr(min2_addr2[0]).min1(min1_2[0]),.min2(min2_2[0]));
select4to2 U65 (.rst_n(rst_n),.clk(clk),.input0(min1_1[2]),.input1(min2_1[2]),.input2(min1_1[3]),
              .input3(min2_1[3]),.min1_addr(min1_addr2[1]),.min2_addr(min2_addr2[1]).min1(min1_2[1]),.min2(min2_2[1]));
select4to2 U66 (.rst_n(rst_n),.clk(clk),.input0(min1_1[4]),.input1(min2_1[4]),.input2(min1_1[5]),
              .input3(min2_1[5]),.min1_addr(min1_addr2[2]),.min2_addr(min2_addr2[2]).min1(min1_2[2]),.min2(min2_2[2]));
select4to2 U67 (.rst_n(rst_n),.clk(clk),.input0(min1_1[6]),.input1(min2_1[6]),.input2(min1_1[7]),
              .input3(min2_1[7]),.min1_addr(min1_addr2[3]),.min2_addr(min2_addr2[3]).min1(min1_2[3]),.min2(min2_2[3]));
select4to2 U68 (.rst_n(rst_n),.clk(clk),.input0(min1_1[8]),.input1(min2_1[8]),.input2(min1_1[9]),
              .input3(min2_1[9]),.min1_addr(min1_addr2[4]),.min2_addr(min2_addr2[4]).min1(min1_2[4]),.min2(min2_2[4]));
select4to2 U69 (.rst_n(rst_n),.clk(clk),.input0(min1_1[10]),.input1(min2_1[10]),.input2(min1_1[11]),
              .input3(min2_1[11]),.min1_addr(min1_addr2[5]),.min2_addr(min2_addr2[5]).min1(min1_2[5]),.min2(min2_2[5]));
select4to2 U70 (.rst_n(rst_n),.clk(clk),.input0(min1_1[12]),.input1(min2_1[12]),.input2(min1_1[13]),
              .input3(min2_1[13]),.min1_addr(min1_addr2[6]),.min2_addr(min2_addr2[6]).min1(min1_2[6]),.min2(min2_2[6]));
select4to2 U71 (.rst_n(rst_n),.clk(clk),.input0(min1_1[14]),.input1(min2_1[14]),.input2(min1_1[15]),
              .input3(min2_1[15]),.min1_addr(min1_addr2[7]),.min2_addr(min2_addr2[7]).min1(min1_2[7]),.min2(min2_2[7]));
select4to2 U72 (.rst_n(rst_n),.clk(clk),.input0(min1_1[16]),.input1(min2_1[16]),.input2(min1_1[17]),
              .input3(min2_1[17]),.min1_addr(min1_addr2[8]),.min2_addr(min2_addr2[8]).min1(min1_2[8]),.min2(min2_2[8]));
select4to2 U73 (.rst_n(rst_n),.clk(clk),.input0(min1_1[18]),.input1(min2_1[18]),.input2(min1_1[19]),
              .input3(min2_1[19]),.min1_addr(min1_addr2[9]),.min2_addr(min2_addr2[9]).min1(min1_2[9]),.min2(min2_2[9]));
select4to2 U74 (.rst_n(rst_n),.clk(clk),.input0(min1_1[20]),.input1(min2_1[20]),.input2(min1_1[21]),
              .input3(min2_1[21]),.min1_addr(min1_addr2[10]),.min2_addr(min2_addr2[10]).min1(min1_2[10]),.min2(min2_2[10]));
select4to2 U75 (.rst_n(rst_n),.clk(clk),.input0(min1_1[22]),.input1(min2_1[22]),.input2(min1_1[23]),
              .input3(min2_1[23]),.min1_addr(min1_addr2[11]),.min2_addr(min2_addr2[11]).min1(min1_2[11]),.min2(min2_2[11]));
select4to2 U76 (.rst_n(rst_n),.clk(clk),.input0(min1_1[24]),.input1(min2_1[24]),.input2(min1_1[25]),
              .input3(min2_1[25]),.min1_addr(min1_addr2[12]),.min2_addr(min2_addr2[12]).min1(min1_2[12]),.min2(min2_2[12]));
select4to2 U77 (.rst_n(rst_n),.clk(clk),.input0(min1_1[26]),.input1(min2_1[26]),.input2(min1_1[27]),
              .input3(min2_1[27]),.min1_addr(min1_addr2[13]),.min2_addr(min2_addr2[13]).min1(min1_2[13]),.min2(min2_2[13]));
select4to2 U78 (.rst_n(rst_n),.clk(clk),.input0(min1_1[28]),.input1(min2_1[28]),.input2(min1_1[29]),
              .input3(min2_1[29]),.min1_addr(min1_addr2[14]),.min2_addr(min2_addr2[14]).min1(min1_2[14]),.min2(min2_2[14]));
select4to2 U79 (.rst_n(rst_n),.clk(clk),.input0(min1_1[30]),.input1(min2_1[30]),.input2(min1_1[31]),
              .input3(min2_1[31]),.min1_addr(min1_addr2[15]),.min2_addr(min2_addr2[15]).min1(min1_2[15]),.min2(min2_2[15]));
select4to2 U80 (.rst_n(rst_n),.clk(clk),.input0(min1_1[32]),.input1(min2_1[32]),.input2(min1_1[33]),
              .input3(min2_1[33]),.min1_addr(min1_addr2[16]),.min2_addr(min2_addr2[16]).min1(min1_2[16]),.min2(min2_2[16]));
select4to2 U81 (.rst_n(rst_n),.clk(clk),.input0(min1_1[34]),.input1(min2_1[34]),.input2(min1_1[35]),
              .input3(min2_1[35]),.min1_addr(min1_addr2[17]),.min2_addr(min2_addr2[17]).min1(min1_2[17]),.min2(min2_2[17]));
select4to2 U82 (.rst_n(rst_n),.clk(clk),.input0(min1_1[36]),.input1(min2_1[36]),.input2(min1_1[37]),
              .input3(min2_1[37]),.min1_addr(min1_addr2[18]),.min2_addr(min2_addr2[18]).min1(min1_2[18]),.min2(min2_2[18]));
select4to2 U83 (.rst_n(rst_n),.clk(clk),.input0(min1_1[38]),.input1(min2_1[38]),.input2(min1_1[39]),
              .input3(min2_1[39]),.min1_addr(min1_addr2[19]),.min2_addr(min2_addr2[19]).min1(min1_2[19]),.min2(min2_2[19]));
select4to2 U84 (.rst_n(rst_n),.clk(clk),.input0(min1_1[40]),.input1(min2_1[40]),.input2(min1_1[41]),
              .input3(min2_1[41]),.min1_addr(min1_addr2[20]),.min2_addr(min2_addr2[20]).min1(min1_2[20]),.min2(min2_2[20]));
select4to2 U85 (.rst_n(rst_n),.clk(clk),.input0(min1_1[42]),.input1(min2_1[42]),.input2(min1_1[43]),
              .input3(min2_1[43]),.min1_addr(min1_addr2[21]),.min2_addr(min2_addr2[21]).min1(min1_2[21]),.min2(min2_2[21]));
select4to2 U86 (.rst_n(rst_n),.clk(clk),.input0(min1_1[44]),.input1(min2_1[44]),.input2(min1_1[45]),
              .input3(min2_1[45]),.min1_addr(min1_addr2[22]),.min2_addr(min2_addr2[22]).min1(min1_2[22]),.min2(min2_2[22]));
select4to2 U87 (.rst_n(rst_n),.clk(clk),.input0(min1_1[46]),.input1(min2_1[46]),.input2(min1_1[47]),
              .input3(min2_1[47]),.min1_addr(min1_addr2[23]),.min2_addr(min2_addr2[23]).min1(min1_2[23]),.min2(min2_2[23]));
select4to2 U88 (.rst_n(rst_n),.clk(clk),.input0(min1_1[48]),.input1(min2_1[48]),.input2(min1_1[49]),
              .input3(min2_1[49]),.min1_addr(min1_addr2[24]),.min2_addr(min2_addr2[24]).min1(min1_2[24]),.min2(min2_2[24]));
select4to2 U89 (.rst_n(rst_n),.clk(clk),.input0(min1_1[50]),.input1(min2_1[50]),.input2(min1_1[51]),
              .input3(min2_1[51]),.min1_addr(min1_addr2[25]),.min2_addr(min2_addr2[25]).min1(min1_2[25]),.min2(min2_2[25]));
select4to2 U90 (.rst_n(rst_n),.clk(clk),.input0(min1_1[52]),.input1(min2_1[52]),.input2(min1_1[53]),
              .input3(min2_1[53]),.min1_addr(min1_addr2[26]),.min2_addr(min2_addr2[26]).min1(min1_2[26]),.min2(min2_2[26]));
select4to2 U91 (.rst_n(rst_n),.clk(clk),.input0(min1_1[54]),.input1(min2_1[54]),.input2(min1_1[55]),
              .input3(min2_1[55]),.min1_addr(min1_addr2[27]),.min2_addr(min2_addr2[27]).min1(min1_2[27]),.min2(min2_2[27]));
select4to2 U92 (.rst_n(rst_n),.clk(clk),.input0(min1_1[56]),.input1(min2_1[56]),.input2(min1_1[57]),
              .input3(min2_1[57]),.min1_addr(min1_addr2[28]),.min2_addr(min2_addr2[28]).min1(min1_2[28]),.min2(min2_2[28]));
select4to2 U93 (.rst_n(rst_n),.clk(clk),.input0(min1_1[58]),.input1(min2_1[58]),.input2(min1_1[59]),
              .input3(min2_1[59]),.min1_addr(min1_addr2[29]),.min2_addr(min2_addr2[29]).min1(min1_2[29]),.min2(min2_2[29]));
select4to2 U94 (.rst_n(rst_n),.clk(clk),.input0(min1_1[60]),.input1(min2_1[60]),.input2(min1_1[61]),
              .input3(min2_1[61]),.min1_addr(min1_addr2[30]),.min2_addr(min2_addr2[30]).min1(min1_2[30]),.min2(min2_2[30]));
select4to2 U95 (.rst_n(rst_n),.clk(clk),.input0(min1_1[62]),.input1(min2_1[62]),.input2(min1_1[63]),
              .input3(min2_1[63]),.min1_addr(min1_addr2[31]),.min2_addr(min2_addr2[31]).min1(min1_2[31]),.min2(min2_2[31]));
select4to2 U96 (.rst_n(rst_n),.clk(clk),.input0(min1_2[0]),.input1(min2_2[0]),.input2(min1_2[1]),
              .input3(min2_2[1]),.min1_addr(min1_addr3[0]),.min2_addr(min2_addr3[0]).min1(min1_3[0]),.min2(min2_3[0]));
select4to2 U97 (.rst_n(rst_n),.clk(clk),.input0(min1_2[2]),.input1(min2_2[2]),.input2(min1_2[3]),
              .input3(min2_2[3]),.min1_addr(min1_addr3[1]),.min2_addr(min2_addr3[1]).min1(min1_3[1]),.min2(min2_3[1]));
select4to2 U98 (.rst_n(rst_n),.clk(clk),.input0(min1_2[4]),.input1(min2_2[4]),.input2(min1_2[5]),
              .input3(min2_2[5]),.min1_addr(min1_addr3[2]),.min2_addr(min2_addr3[2]).min1(min1_3[2]),.min2(min2_3[2]));
select4to2 U99 (.rst_n(rst_n),.clk(clk),.input0(min1_2[6]),.input1(min2_2[6]),.input2(min1_2[7]),
              .input3(min2_2[7]),.min1_addr(min1_addr3[3]),.min2_addr(min2_addr3[3]).min1(min1_3[3]),.min2(min2_3[3]));
select4to2 U100 (.rst_n(rst_n),.clk(clk),.input0(min1_2[8]),.input1(min2_2[8]),.input2(min1_2[9]),
              .input3(min2_2[9]),.min1_addr(min1_addr3[4]),.min2_addr(min2_addr3[4]).min1(min1_3[4]),.min2(min2_3[4]));
select4to2 U101 (.rst_n(rst_n),.clk(clk),.input0(min1_2[10]),.input1(min2_2[10]),.input2(min1_2[11]),
              .input3(min2_2[11]),.min1_addr(min1_addr3[5]),.min2_addr(min2_addr3[5]).min1(min1_3[5]),.min2(min2_3[5]));
select4to2 U102 (.rst_n(rst_n),.clk(clk),.input0(min1_2[12]),.input1(min2_2[12]),.input2(min1_2[13]),
              .input3(min2_2[13]),.min1_addr(min1_addr3[6]),.min2_addr(min2_addr3[6]).min1(min1_3[6]),.min2(min2_3[6]));
select4to2 U103 (.rst_n(rst_n),.clk(clk),.input0(min1_2[14]),.input1(min2_2[14]),.input2(min1_2[15]),
              .input3(min2_2[15]),.min1_addr(min1_addr3[7]),.min2_addr(min2_addr3[7]).min1(min1_3[7]),.min2(min2_3[7]));
select4to2 U104 (.rst_n(rst_n),.clk(clk),.input0(min1_2[16]),.input1(min2_2[16]),.input2(min1_2[17]),
              .input3(min2_2[17]),.min1_addr(min1_addr3[8]),.min2_addr(min2_addr3[8]).min1(min1_3[8]),.min2(min2_3[8]));
select4to2 U105 (.rst_n(rst_n),.clk(clk),.input0(min1_2[18]),.input1(min2_2[18]),.input2(min1_2[19]),
              .input3(min2_2[19]),.min1_addr(min1_addr3[9]),.min2_addr(min2_addr3[9]).min1(min1_3[9]),.min2(min2_3[9]));
select4to2 U106 (.rst_n(rst_n),.clk(clk),.input0(min1_2[20]),.input1(min2_2[20]),.input2(min1_2[21]),
              .input3(min2_2[21]),.min1_addr(min1_addr3[10]),.min2_addr(min2_addr3[10]).min1(min1_3[10]),.min2(min2_3[10]));
select4to2 U107 (.rst_n(rst_n),.clk(clk),.input0(min1_2[22]),.input1(min2_2[22]),.input2(min1_2[23]),
              .input3(min2_2[23]),.min1_addr(min1_addr3[11]),.min2_addr(min2_addr3[11]).min1(min1_3[11]),.min2(min2_3[11]));
select4to2 U108 (.rst_n(rst_n),.clk(clk),.input0(min1_2[24]),.input1(min2_2[24]),.input2(min1_2[25]),
              .input3(min2_2[25]),.min1_addr(min1_addr3[12]),.min2_addr(min2_addr3[12]).min1(min1_3[12]),.min2(min2_3[12]));
select4to2 U109 (.rst_n(rst_n),.clk(clk),.input0(min1_2[26]),.input1(min2_2[26]),.input2(min1_2[27]),
              .input3(min2_2[27]),.min1_addr(min1_addr3[13]),.min2_addr(min2_addr3[13]).min1(min1_3[13]),.min2(min2_3[13]));
select4to2 U110 (.rst_n(rst_n),.clk(clk),.input0(min1_2[28]),.input1(min2_2[28]),.input2(min1_2[29]),
              .input3(min2_2[29]),.min1_addr(min1_addr3[14]),.min2_addr(min2_addr3[14]).min1(min1_3[14]),.min2(min2_3[14]));
select4to2 U111 (.rst_n(rst_n),.clk(clk),.input0(min1_2[30]),.input1(min2_2[30]),.input2(min1_2[31]),
              .input3(min2_2[31]),.min1_addr(min1_addr3[15]),.min2_addr(min2_addr3[15]).min1(min1_3[15]),.min2(min2_3[15]));
select4to2 U112 (.rst_n(rst_n),.clk(clk),.input0(min1_3[0]),.input1(min2_3[0]),.input2(min1_3[1]),
                 .input3(min2_3[1]),.min1_addr(min1_addr4[0]),.min2_addr(min2_addr4[0]).min1(min1_4[0]),.min2(min2_4[0]));
select4to2 U113 (.rst_n(rst_n),.clk(clk),.input0(min1_3[2]),.input1(min2_3[2]),.input2(min1_3[3]),
                 .input3(min2_3[3]),.min1_addr(min1_addr4[1]),.min2_addr(min2_addr4[1]).min1(min1_4[1]),.min2(min2_4[1]));
select4to2 U114 (.rst_n(rst_n),.clk(clk),.input0(min1_3[4]),.input1(min2_3[4]),.input2(min1_3[5]),
                 .input3(min2_3[5]),.min1_addr(min1_addr4[2]),.min2_addr(min2_addr4[2]).min1(min1_4[2]),.min2(min2_4[2]));
select4to2 U115 (.rst_n(rst_n),.clk(clk),.input0(min1_3[6]),.input1(min2_3[6]),.input2(min1_3[7]),
                 .input3(min2_3[7]),.min1_addr(min1_addr4[3]),.min2_addr(min2_addr4[3]).min1(min1_4[3]),.min2(min2_4[3]));
select4to2 U116 (.rst_n(rst_n),.clk(clk),.input0(min1_3[8]),.input1(min2_3[8]),.input2(min1_3[9]),
                 .input3(min2_3[9]),.min1_addr(min1_addr4[4]),.min2_addr(min2_addr4[4]).min1(min1_4[4]),.min2(min2_4[4]));
select4to2 U117 (.rst_n(rst_n),.clk(clk),.input0(min1_3[10]),.input1(min2_3[10]),.input2(min1_3[11]),
                 .input3(min2_3[11]),.min1_addr(min1_addr4[5]),.min2_addr(min2_addr4[5]).min1(min1_4[5]),.min2(min2_4[5]));
select4to2 U118 (.rst_n(rst_n),.clk(clk),.input0(min1_3[12]),.input1(min2_3[12]),.input2(min1_3[13]),
                 .input3(min2_3[13]),.min1_addr(min1_addr4[6]),.min2_addr(min2_addr4[6]).min1(min1_4[6]),.min2(min2_4[6]));
select4to2 U119 (.rst_n(rst_n),.clk(clk),.input0(min1_3[14]),.input1(min2_3[14]),.input2(min1_3[15]),
                 .input3(min2_3[15]),.min1_addr(min1_addr4[7]),.min2_addr(min2_addr4[7]).min1(min1_4[7]),.min2(min2_4[7]));
select4to2 U120 (.rst_n(rst_n),.clk(clk),.input0(min1_4[0]),.input1(min2_4[0]),.input2(min1_4[1]),
                 .input3(min2_4[1]),.min1_addr(min1_addr5[0]),.min2_addr(min2_addr5[0]).min1(min1_5[0]),.min2(min2_5[0]));
select4to2 U121 (.rst_n(rst_n),.clk(clk),.input0(min1_4[2]),.input1(min2_4[2]),.input2(min1_4[3]),
                 .input3(min2_4[3]),.min1_addr(min1_addr5[1]),.min2_addr(min2_addr5[1]).min1(min1_5[1]),.min2(min2_5[1]));
select4to2 U122 (.rst_n(rst_n),.clk(clk),.input0(min1_4[4]),.input1(min2_4[4]),.input2(min1_4[5]),
                 .input3(min2_4[5]),.min1_addr(min1_addr5[2]),.min2_addr(min2_addr5[2]).min1(min1_5[2]),.min2(min2_5[2]));
select4to2 U123 (.rst_n(rst_n),.clk(clk),.input0(min1_4[6]),.input1(min2_4[6]),.input2(min1_4[7]),
                 .input3(min2_4[7]),.min1_addr(min1_addr5[3]),.min2_addr(min2_addr5[3]).min1(min1_5[3]),.min2(min2_5[3]));
select4to2 U124 (.rst_n(rst_n),.clk(clk),.input0(min1_5[0]),.input1(min2_5[0]),.input2(min1_5[1]),
                 .input3(min2_5[1]),.min1_addr(min1_addr6[0]),.min2_addr(min2_addr6[0]).min1(min1_6[0]),.min2(min2_6[0]));
select4to2 U125 (.rst_n(rst_n),.clk(clk),.input0(min1_5[2]),.input1(min2_5[2]),.input2(min1_5[3]),
                 .input3(min2_5[3]),.min1_addr(min1_addr6[1]),.min2_addr(min2_addr6[1]).min1(min1_6[1]),.min2(min2_6[1]));
select4to2 U126 (.rst_n(rst_n),.clk(clk),.input0(min1_6[0]),.input1(min2_6[0]),.input2(min1_6[1]),
              .input3(min2_6[1]),.min1_addr(min1_addr7),.min2_addr(min2_addr7).min1(min1),.min2(min2));


//sram_next
always @(*) begin
    sram_addr_next = sram_addr;
end

//sram_next
always @(*) begin
    code_length_next = AC_length[50];
end

//sram_next
always @(*) begin
    code_out_next = layer[50];
end

//state_next
always @(*) begin
    case (state)
        IDLE: begin
            if(valid) state_next = FINISH;
            else state_next = IDLE;
        end
        /*COUNT: begin
            if(count_finish) state_next = TREE;
            else state_next = COUNT;
        end
        TREE: begin
            if(build_finish) state_next = ENCODE;
            else state_next = ENCODE;
        end
        ENCODE: begin
            if(encode_finish) state_next = FINISH;
            else state_next = ENCODE;
        end */
        FINISH: begin
            state_next = IDLE;
        end
        default: begin
            state_next = IDLE;
        end
    endcase
end


//sequential
always @(posedge clk) begin
    if(~rst_n) begin
        state <=  3'b0;
        code_length <= 0;
        code_out <= 0;
        sram_addr <= 0;
        sram_data_ff <= 0;
        for(i = 0;i < 256;i = i + 1) begin
            AC_frequency[i] <= 0;
            AC_length[i] <= 0;
            AC_hcode[i] <= 0;
            for (j = 0;j < 256;j = j + 1) begin
                if(i == j) layer[i][j] <= 1;
                else layer[i][j] <= 0;
            end
        end
    end
    else begin
        state <= state_next;
        code_length <= code_length_next;
        code_out <= code_out_next;
        sram_addr <= sram_addr_next;
        sram_data_ff <= sram_data;
        for(i = 0;i < 256;i = i + 1) begin
            AC_frequency[i] <= AC_frequency_next[i];
            AC_length[i] <= AC_length_next[i];
            AC_hcode[i] <= AC_hcode_next[i];
            layer[i] <= layer_next[i];
        end
    end
end
endmodule

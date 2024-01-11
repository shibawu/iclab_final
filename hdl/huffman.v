module huffman(
    input clk,
    input rst_n,
    input valid,
    input [99-1:0] sram_data,
    /*input [11-1:0] DC_in,
    input [24-1:0] R_in,
    input [32-1:0] L_in,
    input [32-1:0] F_in,*/
    output reg  [11-1:0] sram_addr,

    output reg [5-1:0] code_length1,
    output reg [32-1:0] code_out1,
    output reg [5-1:0] code_length2,
    output reg [32-1:0] code_out2,
    output reg [5-1:0] code_length3,
    output reg [32-1:0] code_out3,
    output reg [5-1:0] code_length4,
    output reg [32-1:0] code_out4,
    output reg [5-1:0] code_length5,
    output reg [32-1:0] code_out5,
    output reg [5-1:0] code_length6,
    output reg [32-1:0] code_out6,
    output reg [5-1:0] code_length7,
    output reg [32-1:0] code_out7,
    output reg [5-1:0] code_length8,
    output reg [32-1:0] code_out8,

    output [5-1:0] code_length_DC,
    output [20-1:0] code_out_DC,

    output reg [5-1:0] code_length_table,
    output reg [32-1:0] code_out_table,

    output reg out_valid
);

reg out_valid_next;

reg [11-1:0] DC_in;
reg [24-1:0] R_in;
reg [32-1:0] L_in;
reg [32-1:0] F_in;
reg [11-1:0] DC;
reg [24-1:0] R;
reg [32-1:0] L;
reg [32-1:0] F;

reg count_finish;
reg count_finish_ff;

reg [2:0] state;
reg [2:0] state_next;

reg [5-1:0] code_length_next1;
reg [32-1:0] code_out_next1;
reg [5-1:0] code_length_next2;
reg [32-1:0] code_out_next2;
reg [5-1:0] code_length_next3;
reg [32-1:0] code_out_next3;
reg [5-1:0] code_length_next4;
reg [32-1:0] code_out_next4;
reg [5-1:0] code_length_next5;
reg [32-1:0] code_out_next5;
reg [5-1:0] code_length_next6;
reg [32-1:0] code_out_next6;
reg [5-1:0] code_length_next7;
reg [32-1:0] code_out_next7;
reg [5-1:0] code_length_next8;
reg [32-1:0] code_out_next8;

reg [5-1:0] code_length_table_next;
reg [32-1:0] code_out_table_next;

reg [11-1:0] sram_addr_next;
reg [99-1:0] sram_data_ff;

reg [10:0] AC_frequency [0:128-1];
reg [10:0] AC_frequency_next [0:128-1];

reg [128-1:0] AC_hcode [0:128-1];
reg [128-1:0] AC_hcode_next [0:128-1];

reg [7-1:0] AC_length [0:128-1];
reg [7-1:0] AC_length_next [0:128-1];

reg [128-1:0] layer [0:128-1];
reg [128-1:0] layer_next [0:128-1];


wire [7-1:0] min1_addr_inv;
wire [7-1:0] min2_addr_inv;

reg [7-1:0] min1_addr;
reg [7-1:0] min2_addr;

wire [10:0] min1;
wire [10:0] min2;

reg [11-1:0] cnt;
reg [11-1:0] cnt_next;

reg [1:0]cnt_tree;
reg [1:0]cnt_tree_next;

reg [1:0] cnt_channel;
reg [1:0] cnt_channel_next;

wire [10:0] min1_1 [0:32-1];
wire [10:0] min2_1 [0:32-1];
reg  [10:0] min1_2 [0:16-1];
reg  [10:0] min2_2 [0:16-1];
wire [10:0] min1_3 [0:8-1];
wire [10:0] min2_3 [0:8-1];
wire [10:0] min1_4 [0:4-1];
wire [10:0] min2_4 [0:4-1];
reg  [10:0] min1_5 [0:2-1];
reg  [10:0] min2_5 [0:2-1];

wire [7-1:0] min1_addr1 [0:32-1];
wire [7-1:0] min2_addr1 [0:32-1];
reg  [7-1:0] min1_addr2 [0:16-1];
reg  [7-1:0] min2_addr2 [0:16-1];
wire [7-1:0] min1_addr3 [0:8-1];
wire [7-1:0] min2_addr3 [0:8-1];
wire [7-1:0] min1_addr4 [0:4-1];
wire [7-1:0] min2_addr4 [0:4-1];
reg  [7-1:0] min1_addr5 [0:2-1];
reg  [7-1:0] min2_addr5 [0:2-1];

wire [7-1:0] min1_addr2_next [0:16-1];
wire [7-1:0] min2_addr2_next [0:16-1];
wire [10:0] min1_2_next [0:16-1];
wire [10:0] min2_2_next [0:16-1];

wire [7-1:0] min1_addr5_next [0:2-1];
wire [7-1:0] min2_addr5_next [0:2-1];
wire [10:0] min1_5_next [0:2-1];
wire [10:0] min2_5_next [0:2-1];

reg build_finish,encode_finish;

localparam IDLE = 3'b000, COUNT = 3'b001, TREE = 3'b010, ENCODE = 3'b011, FINISH = 3'b100, DONE = 3'b101;

integer i,j,k,l,m,n,o,p;

always @(*) begin
    DC_in = sram_data[98:88];
    R_in = sram_data[87:64];
    L_in = sram_data[63:32];
    F_in = sram_data[31:0];
end

huffman_DC U_DC0(.clk(clk),.rst_n(rst_n),.DC(DC),.code_length(code_length_DC),.code_out(code_out_DC));

//layer next
always @(*) begin
    for (i = 0;i < 128;i = i + 1) begin
        layer_next[i] = layer[i];
    end
    if(state == TREE  && !build_finish && cnt_tree == 2) begin
        layer_next[min1_addr] = layer[min1_addr] | layer[min2_addr];
    end
    else if(state == FINISH) begin
        for(i = 0;i < 128;i = i + 1) begin
            for (j = 0;j < 128;j = j + 1) begin
                if(i == j) layer_next[i][j] = 1;
                else layer_next[i][j] = 0;
            end
        end
    end
    else begin
        for (i = 0;i < 128;i = i + 1) begin
            layer_next[i] = layer[i];
        end
    end
end

// AC_hcode_next
always @(*) begin
    if(state == TREE && !build_finish  && cnt_tree == 2) begin
        for (i = 0;i < 128;i = i + 1) begin
            AC_hcode_next[i] = AC_hcode[i];
            if(layer[min1_addr][i] == 1) begin
                AC_hcode_next[i][AC_length[i]] = 1;
            end
            else if(layer[min2_addr][i] == 1) begin
                AC_hcode_next[i][AC_length[i]] = 0;
            end
        end
    end
    else if(state == FINISH) begin
        for(i = 0;i < 128;i = i + 1) begin
            AC_hcode_next[i] = 0;
        end
    end
    else begin
        for (i = 0;i < 128;i = i + 1) begin
            AC_hcode_next[i] = AC_hcode[i];
        end
    end
end
//build_finish
always@(*)begin
    build_finish = (min1 == 0 || min2 == 0);
end

//AC_frequency_next
always @(*) begin
    case(state)
    IDLE: begin
        for (i = 0;i < 128;i = i + 1) begin
            AC_frequency_next[i] = 0;
        end
    end
    COUNT: begin
        for (i = 0;i < 128;i = i + 1) begin
            AC_frequency_next[i] = AC_frequency[i];
        end
        if(!count_finish && cnt >= 2) begin
        AC_frequency_next[0] = AC_frequency[0] + 1;
        if({R[2:0],L[3:0]} != 0) AC_frequency_next[{R[2:0],L[3:0]}] = (F[3:0] != 0) ? (AC_frequency[{R[2:0],L[3:0]}] + F[3:0]) : AC_frequency[{R[2:0],L[3:0]}]; 
        if({R[5:3],L[7:4]} != 0) AC_frequency_next[{R[5:3],L[7:4]}] = (F[7:4] != 0) ? (AC_frequency[{R[5:3],L[7:4]}] + F[7:4]) : AC_frequency[{R[5:3],L[7:4]}];
        if({R[8:6],L[11:8]} != 0) AC_frequency_next[{R[8:6],L[11:8]}] = (F[11:8] != 0) ? (AC_frequency[{R[8:6],L[11:8]}] + F[11:8]) : AC_frequency[{R[8:6],L[11:0]}];
        if({R[11:9],L[15:12]} != 0) AC_frequency_next[{R[11:9],L[15:12]}] = (F[15:12] != 0) ? (AC_frequency[{R[11:9],L[15:12]}] + F[15:12]) : AC_frequency[{R[11:9],L[15:12]}];
        if({R[14:12],L[19:16]} != 0) AC_frequency_next[{R[14:12],L[19:16]}] = (F[19:16] != 0) ? (AC_frequency[{R[14:12],L[19:16]}] + F[19:16]) : AC_frequency[{R[14:12],L[19:16]}];
        if({R[17:15],L[23:20]} != 0) AC_frequency_next[{R[17:15],L[23:20]}] = (F[23:20] != 0) ? (AC_frequency[{R[17:15],L[23:20]}] + F[23:20]) : AC_frequency[{R[17:15],L[23:20]}];
        if({R[20:18],L[27:24]} != 0) AC_frequency_next[{R[20:18],L[27:24]}] = (F[27:24] != 0) ? (AC_frequency[{R[20:18],L[27:24]}] + F[27:24]) : AC_frequency[{R[20:18],L[27:24]}];
        if({R[23:21],L[31:25]} != 0) AC_frequency_next[{R[23:21],L[31:25]}] = (F[31:25] != 0) ? (AC_frequency[{R[23:21],L[31:25]}] + F[31:25]) : AC_frequency[{R[23:21],L[31:25]}];
            /*for (i = 1;i < 128;i = i + 1) begin
                AC_frequency_next[i] = AC_frequency[i];
            end*/
        end
        else begin
            for (i = 0;i < 128;i = i + 1) begin
                AC_frequency_next[i] = AC_frequency[i];
            end
        end
    end
    TREE: begin
        for (i = 0;i < 128;i = i + 1) begin
            AC_frequency_next[i] = AC_frequency[i];
        end
        if(!build_finish  && cnt_tree == 2) begin
        AC_frequency_next[min1_addr] = min1 + min2;
        AC_frequency_next[min2_addr] = 0;
        end
    end
    default: begin
        for (i = 0;i < 128;i = i + 1) begin
            AC_frequency_next[i] = AC_frequency[i];
        end
    end
    endcase
end

//AC_length_next
always@(*) begin
    if(state == TREE && cnt_tree == 2)
        for (i = 0;i < 128;i = i + 1) begin
            AC_length_next[i] = AC_length[i];
            if((layer[min1_addr][i] == 1 || layer[min2_addr][i] == 1) && !build_finish) begin
                AC_length_next[i] = AC_length[i] + 1;
            end
        end
    else if(state == FINISH) begin
        for(i = 0;i < 128;i = i + 1) begin
            AC_length_next[i] = 0;
        end
    end
    else begin
        for (i = 0;i < 128;i = i + 1) begin
            AC_length_next[i] = AC_length[i];
        end
    end
end

always @(*) begin
    if(state == TREE && cnt_tree != 2) begin
        cnt_tree_next = cnt_tree + 1;
    end
    else cnt_tree_next = 0;
end

always @(*) begin
    min1_addr = {min1_addr_inv[0],min1_addr_inv[1],min1_addr_inv[2],min1_addr_inv[3],min1_addr_inv[4],min1_addr_inv[5],min1_addr_inv[6]};
    min2_addr = {min2_addr_inv[0],min2_addr_inv[1],min2_addr_inv[2],min2_addr_inv[3],min2_addr_inv[4],min2_addr_inv[5],min2_addr_inv[6]};
end

//select 2min from256
select4to2 U0 (.input0(AC_frequency[0]),.input1(AC_frequency[1]),.input2(AC_frequency[2]),.input3(AC_frequency[3]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[0]),.min2_addr(min2_addr1[0]),.min1(min1_1[0]),.min2(min2_1[0]));
select4to2 U1 (.input0(AC_frequency[4]),.input1(AC_frequency[5]),.input2(AC_frequency[6]),.input3(AC_frequency[7]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[1]),.min2_addr(min2_addr1[1]),.min1(min1_1[1]),.min2(min2_1[1]));
select4to2 U2 (.input0(AC_frequency[8]),.input1(AC_frequency[9]),.input2(AC_frequency[10]),.input3(AC_frequency[11]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[2]),.min2_addr(min2_addr1[2]),.min1(min1_1[2]),.min2(min2_1[2]));
select4to2 U3 (.input0(AC_frequency[12]),.input1(AC_frequency[13]),.input2(AC_frequency[14]),.input3(AC_frequency[15]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[3]),.min2_addr(min2_addr1[3]),.min1(min1_1[3]),.min2(min2_1[3]));
select4to2 U4 (.input0(AC_frequency[16]),.input1(AC_frequency[17]),.input2(AC_frequency[18]),.input3(AC_frequency[19]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[4]),.min2_addr(min2_addr1[4]),.min1(min1_1[4]),.min2(min2_1[4]));
select4to2 U5 (.input0(AC_frequency[20]),.input1(AC_frequency[21]),.input2(AC_frequency[22]),.input3(AC_frequency[23]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[5]),.min2_addr(min2_addr1[5]),.min1(min1_1[5]),.min2(min2_1[5]));
select4to2 U6 (.input0(AC_frequency[24]),.input1(AC_frequency[25]),.input2(AC_frequency[26]),.input3(AC_frequency[27]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[6]),.min2_addr(min2_addr1[6]),.min1(min1_1[6]),.min2(min2_1[6]));
select4to2 U7 (.input0(AC_frequency[28]),.input1(AC_frequency[29]),.input2(AC_frequency[30]),.input3(AC_frequency[31]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[7]),.min2_addr(min2_addr1[7]),.min1(min1_1[7]),.min2(min2_1[7]));
select4to2 U8 (.input0(AC_frequency[32]),.input1(AC_frequency[33]),.input2(AC_frequency[34]),.input3(AC_frequency[35]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[8]),.min2_addr(min2_addr1[8]),.min1(min1_1[8]),.min2(min2_1[8]));
select4to2 U9 (.input0(AC_frequency[36]),.input1(AC_frequency[37]),.input2(AC_frequency[38]),.input3(AC_frequency[39]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[9]),.min2_addr(min2_addr1[9]),.min1(min1_1[9]),.min2(min2_1[9]));
select4to2 U10 (.input0(AC_frequency[40]),.input1(AC_frequency[41]),.input2(AC_frequency[42]),.input3(AC_frequency[43]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[10]),.min2_addr(min2_addr1[10]),.min1(min1_1[10]),.min2(min2_1[10]));
select4to2 U11 (.input0(AC_frequency[44]),.input1(AC_frequency[45]),.input2(AC_frequency[46]),.input3(AC_frequency[47]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
                .min1_addr(min1_addr1[11]),.min2_addr(min2_addr1[11]),.min1(min1_1[11]),.min2(min2_1[11]));
select4to2 U12 (.input0(AC_frequency[48]),.input1(AC_frequency[49]),.input2(AC_frequency[50]),.input3(AC_frequency[51]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[12]),.min2_addr(min2_addr1[12]),.min1(min1_1[12]),.min2(min2_1[12]));
select4to2 U13 (.input0(AC_frequency[52]),.input1(AC_frequency[53]),.input2(AC_frequency[54]),.input3(AC_frequency[55]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[13]),.min2_addr(min2_addr1[13]),.min1(min1_1[13]),.min2(min2_1[13]));
select4to2 U14 (.input0(AC_frequency[56]),.input1(AC_frequency[57]),.input2(AC_frequency[58]),.input3(AC_frequency[59]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[14]),.min2_addr(min2_addr1[14]),.min1(min1_1[14]),.min2(min2_1[14]));
select4to2 U15 (.input0(AC_frequency[60]),.input1(AC_frequency[61]),.input2(AC_frequency[62]),.input3(AC_frequency[63]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[15]),.min2_addr(min2_addr1[15]),.min1(min1_1[15]),.min2(min2_1[15]));
select4to2 U16 (.input0(AC_frequency[64]),.input1(AC_frequency[65]),.input2(AC_frequency[66]),.input3(AC_frequency[67]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[16]),.min2_addr(min2_addr1[16]),.min1(min1_1[16]),.min2(min2_1[16]));
select4to2 U17 (.input0(AC_frequency[68]),.input1(AC_frequency[69]),.input2(AC_frequency[70]),.input3(AC_frequency[71]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[17]),.min2_addr(min2_addr1[17]),.min1(min1_1[17]),.min2(min2_1[17]));
select4to2 U18 (.input0(AC_frequency[72]),.input1(AC_frequency[73]),.input2(AC_frequency[74]),.input3(AC_frequency[75]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[18]),.min2_addr(min2_addr1[18]),.min1(min1_1[18]),.min2(min2_1[18]));
select4to2 U19 (.input0(AC_frequency[76]),.input1(AC_frequency[77]),.input2(AC_frequency[78]),.input3(AC_frequency[79]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[19]),.min2_addr(min2_addr1[19]),.min1(min1_1[19]),.min2(min2_1[19]));
select4to2 U20 (.input0(AC_frequency[80]),.input1(AC_frequency[81]),.input2(AC_frequency[82]),.input3(AC_frequency[83]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[20]),.min2_addr(min2_addr1[20]),.min1(min1_1[20]),.min2(min2_1[20]));
select4to2 U21 (.input0(AC_frequency[84]),.input1(AC_frequency[85]),.input2(AC_frequency[86]),.input3(AC_frequency[87]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[21]),.min2_addr(min2_addr1[21]),.min1(min1_1[21]),.min2(min2_1[21]));
select4to2 U22 (.input0(AC_frequency[88]),.input1(AC_frequency[89]),.input2(AC_frequency[90]),.input3(AC_frequency[91]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[22]),.min2_addr(min2_addr1[22]),.min1(min1_1[22]),.min2(min2_1[22]));
select4to2 U23 (.input0(AC_frequency[92]),.input1(AC_frequency[93]),.input2(AC_frequency[94]),.input3(AC_frequency[95]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[23]),.min2_addr(min2_addr1[23]),.min1(min1_1[23]),.min2(min2_1[23]));
select4to2 U24 (.input0(AC_frequency[96]),.input1(AC_frequency[97]),.input2(AC_frequency[98]),.input3(AC_frequency[99]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[24]),.min2_addr(min2_addr1[24]),.min1(min1_1[24]),.min2(min2_1[24]));
select4to2 U25 (.input0(AC_frequency[100]),.input1(AC_frequency[101]),.input2(AC_frequency[102]),.input3(AC_frequency[103]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[25]),.min2_addr(min2_addr1[25]),.min1(min1_1[25]),.min2(min2_1[25]));
select4to2 U26 (.input0(AC_frequency[104]),.input1(AC_frequency[105]),.input2(AC_frequency[106]),.input3(AC_frequency[107]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[26]),.min2_addr(min2_addr1[26]),.min1(min1_1[26]),.min2(min2_1[26]));
select4to2 U27 (.input0(AC_frequency[108]),.input1(AC_frequency[109]),.input2(AC_frequency[110]),.input3(AC_frequency[111]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[27]),.min2_addr(min2_addr1[27]),.min1(min1_1[27]),.min2(min2_1[27]));
select4to2 U28 (.input0(AC_frequency[112]),.input1(AC_frequency[113]),.input2(AC_frequency[114]),.input3(AC_frequency[115]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[28]),.min2_addr(min2_addr1[28]),.min1(min1_1[28]),.min2(min2_1[28]));
select4to2 U29 (.input0(AC_frequency[116]),.input1(AC_frequency[117]),.input2(AC_frequency[118]),.input3(AC_frequency[119]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[29]),.min2_addr(min2_addr1[29]),.min1(min1_1[29]),.min2(min2_1[29]));
select4to2 U30 (.input0(AC_frequency[120]),.input1(AC_frequency[121]),.input2(AC_frequency[122]),.input3(AC_frequency[123]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[30]),.min2_addr(min2_addr1[30]),.min1(min1_1[30]),.min2(min2_1[30]));
select4to2 U31 (.input0(AC_frequency[124]),.input1(AC_frequency[125]),.input2(AC_frequency[126]),.input3(AC_frequency[127]),
               .input_addr0(6'd0),.input_addr1(6'd1),.input_addr2(6'd0),.input_addr3(6'd1),
               .min1_addr(min1_addr1[31]),.min2_addr(min2_addr1[31]),.min1(min1_1[31]),.min2(min2_1[31]));
select4to2 U32 (.input0(min1_1[0]),.input1(min2_1[0]),.input2(min1_1[1]),.input3(min2_1[1]),
              .input_addr0(min1_addr1[0][5:0]),.input_addr1(min2_addr1[0][5:0]),.input_addr2(min1_addr1[1][5:0]),.input_addr3(min2_addr1[1][5:0]),
               .min1_addr(min1_addr2_next[0]),.min2_addr(min2_addr2_next[0]),.min1(min1_2_next[0]),.min2(min2_2_next[0]));
select4to2 U33 (.input0(min1_1[2]),.input1(min2_1[2]),.input2(min1_1[3]),.input3(min2_1[3]),
              .input_addr0(min1_addr1[2][5:0]),.input_addr1(min2_addr1[2][5:0]),.input_addr2(min1_addr1[3][5:0]),.input_addr3(min2_addr1[3][5:0]),
               .min1_addr(min1_addr2_next[1]),.min2_addr(min2_addr2_next[1]),.min1(min1_2_next[1]),.min2(min2_2_next[1]));
select4to2 U34 (.input0(min1_1[4]),.input1(min2_1[4]),.input2(min1_1[5]),.input3(min2_1[5]),
              .input_addr0(min1_addr1[4][5:0]),.input_addr1(min2_addr1[4][5:0]),.input_addr2(min1_addr1[5][5:0]),.input_addr3(min2_addr1[5][5:0]),
               .min1_addr(min1_addr2_next[2]),.min2_addr(min2_addr2_next[2]),.min1(min1_2_next[2]),.min2(min2_2_next[2]));
select4to2 U35 (.input0(min1_1[6]),.input1(min2_1[6]),.input2(min1_1[7]),.input3(min2_1[7]),
              .input_addr0(min1_addr1[6][5:0]),.input_addr1(min2_addr1[6][5:0]),.input_addr2(min1_addr1[7][5:0]),.input_addr3(min2_addr1[7][5:0]),
               .min1_addr(min1_addr2_next[3]),.min2_addr(min2_addr2_next[3]),.min1(min1_2_next[3]),.min2(min2_2_next[3]));
select4to2 U36 (.input0(min1_1[8]),.input1(min2_1[8]),.input2(min1_1[9]),.input3(min2_1[9]),
              .input_addr0(min1_addr1[8][5:0]),.input_addr1(min2_addr1[8][5:0]),.input_addr2(min1_addr1[9][5:0]),.input_addr3(min2_addr1[9][5:0]),
               .min1_addr(min1_addr2_next[4]),.min2_addr(min2_addr2_next[4]),.min1(min1_2_next[4]),.min2(min2_2_next[4]));
select4to2 U37 (.input0(min1_1[10]),.input1(min2_1[10]),.input2(min1_1[11]),.input3(min2_1[11]),
              .input_addr0(min1_addr1[10][5:0]),.input_addr1(min2_addr1[10][5:0]),.input_addr2(min1_addr1[11][5:0]),.input_addr3(min2_addr1[11][5:0]),
               .min1_addr(min1_addr2_next[5]),.min2_addr(min2_addr2_next[5]),.min1(min1_2_next[5]),.min2(min2_2_next[5]));
select4to2 U38 (.input0(min1_1[12]),.input1(min2_1[12]),.input2(min1_1[13]),.input3(min2_1[13]),
              .input_addr0(min1_addr1[12][5:0]),.input_addr1(min2_addr1[12][5:0]),.input_addr2(min1_addr1[13][5:0]),.input_addr3(min2_addr1[13][5:0]),
               .min1_addr(min1_addr2_next[6]),.min2_addr(min2_addr2_next[6]),.min1(min1_2_next[6]),.min2(min2_2_next[6]));
select4to2 U39 (.input0(min1_1[14]),.input1(min2_1[14]),.input2(min1_1[15]),.input3(min2_1[15]),
              .input_addr0(min1_addr1[14][5:0]),.input_addr1(min2_addr1[14][5:0]),.input_addr2(min1_addr1[15][5:0]),.input_addr3(min2_addr1[15][5:0]),
               .min1_addr(min1_addr2_next[7]),.min2_addr(min2_addr2_next[7]),.min1(min1_2_next[7]),.min2(min2_2_next[7]));
select4to2 U40 (.input0(min1_1[16]),.input1(min2_1[16]),.input2(min1_1[17]),.input3(min2_1[17]),
              .input_addr0(min1_addr1[16][5:0]),.input_addr1(min2_addr1[16][5:0]),.input_addr2(min1_addr1[17][5:0]),.input_addr3(min2_addr1[17][5:0]),
               .min1_addr(min1_addr2_next[8]),.min2_addr(min2_addr2_next[8]),.min1(min1_2_next[8]),.min2(min2_2_next[8]));
select4to2 U41 (.input0(min1_1[18]),.input1(min2_1[18]),.input2(min1_1[19]),.input3(min2_1[19]),
              .input_addr0(min1_addr1[18][5:0]),.input_addr1(min2_addr1[18][5:0]),.input_addr2(min1_addr1[19][5:0]),.input_addr3(min2_addr1[19][5:0]),
               .min1_addr(min1_addr2_next[9]),.min2_addr(min2_addr2_next[9]),.min1(min1_2_next[9]),.min2(min2_2_next[9]));
select4to2 U42 (.input0(min1_1[20]),.input1(min2_1[20]),.input2(min1_1[21]),.input3(min2_1[21]),
              .input_addr0(min1_addr1[20][5:0]),.input_addr1(min2_addr1[20][5:0]),.input_addr2(min1_addr1[21][5:0]),.input_addr3(min2_addr1[21][5:0]),
               .min1_addr(min1_addr2_next[10]),.min2_addr(min2_addr2_next[10]),.min1(min1_2_next[10]),.min2(min2_2_next[10]));
select4to2 U43 (.input0(min1_1[22]),.input1(min2_1[22]),.input2(min1_1[23]),.input3(min2_1[23]),
              .input_addr0(min1_addr1[22][5:0]),.input_addr1(min2_addr1[22][5:0]),.input_addr2(min1_addr1[23][5:0]),.input_addr3(min2_addr1[23][5:0]),
               .min1_addr(min1_addr2_next[11]),.min2_addr(min2_addr2_next[11]),.min1(min1_2_next[11]),.min2(min2_2_next[11]));
select4to2 U44 (.input0(min1_1[24]),.input1(min2_1[24]),.input2(min1_1[25]),.input3(min2_1[25]),
              .input_addr0(min1_addr1[24][5:0]),.input_addr1(min2_addr1[24][5:0]),.input_addr2(min1_addr1[25][5:0]),.input_addr3(min2_addr1[25][5:0]),
               .min1_addr(min1_addr2_next[12]),.min2_addr(min2_addr2_next[12]),.min1(min1_2_next[12]),.min2(min2_2_next[12]));
select4to2 U45 (.input0(min1_1[26]),.input1(min2_1[26]),.input2(min1_1[27]),.input3(min2_1[27]),
              .input_addr0(min1_addr1[26][5:0]),.input_addr1(min2_addr1[26][5:0]),.input_addr2(min1_addr1[27][5:0]),.input_addr3(min2_addr1[27][5:0]),
               .min1_addr(min1_addr2_next[13]),.min2_addr(min2_addr2_next[13]),.min1(min1_2_next[13]),.min2(min2_2_next[13]));
select4to2 U46 (.input0(min1_1[28]),.input1(min2_1[28]),.input2(min1_1[29]),.input3(min2_1[29]),
              .input_addr0(min1_addr1[28][5:0]),.input_addr1(min2_addr1[28][5:0]),.input_addr2(min1_addr1[29][5:0]),.input_addr3(min2_addr1[29][5:0]),
               .min1_addr(min1_addr2_next[14]),.min2_addr(min2_addr2_next[14]),.min1(min1_2_next[14]),.min2(min2_2_next[14]));
select4to2 U47 (.input0(min1_1[30]),.input1(min2_1[30]),.input2(min1_1[31]),.input3(min2_1[31]),
                .input_addr0(min1_addr1[30][5:0]),.input_addr1(min2_addr1[30][5:0]),.input_addr2(min1_addr1[31][5:0]),.input_addr3(min2_addr1[31][5:0]),
               .min1_addr(min1_addr2_next[15]),.min2_addr(min2_addr2_next[15]),.min1(min1_2_next[15]),.min2(min2_2_next[15]));
select4to2 U48 (.input0(min1_2[0]),.input1(min2_2[0]),.input2(min1_2[1]),.input3(min2_2[1]),
              .input_addr0(min1_addr2[0][5:0]),.input_addr1(min2_addr2[0][5:0]),.input_addr2(min1_addr2[1][5:0]),.input_addr3(min2_addr2[1][5:0]),
               .min1_addr(min1_addr3[0]),.min2_addr(min2_addr3[0]),.min1(min1_3[0]),.min2(min2_3[0]));
select4to2 U49 (.input0(min1_2[2]),.input1(min2_2[2]),.input2(min1_2[3]),.input3(min2_2[3]),
              .input_addr0(min1_addr2[2][5:0]),.input_addr1(min2_addr2[2][5:0]),.input_addr2(min1_addr2[3][5:0]),.input_addr3(min2_addr2[3][5:0]),
               .min1_addr(min1_addr3[1]),.min2_addr(min2_addr3[1]),.min1(min1_3[1]),.min2(min2_3[1]));
select4to2 U50 (.input0(min1_2[4]),.input1(min2_2[4]),.input2(min1_2[5]),.input3(min2_2[5]),
              .input_addr0(min1_addr2[4][5:0]),.input_addr1(min2_addr2[4][5:0]),.input_addr2(min1_addr2[5][5:0]),.input_addr3(min2_addr2[5][5:0]),
               .min1_addr(min1_addr3[2]),.min2_addr(min2_addr3[2]),.min1(min1_3[2]),.min2(min2_3[2]));
select4to2 U51 (.input0(min1_2[6]),.input1(min2_2[6]),.input2(min1_2[7]),.input3(min2_2[7]),
              .input_addr0(min1_addr2[6][5:0]),.input_addr1(min2_addr2[6][5:0]),.input_addr2(min1_addr2[7][5:0]),.input_addr3(min2_addr2[7][5:0]),
               .min1_addr(min1_addr3[3]),.min2_addr(min2_addr3[3]),.min1(min1_3[3]),.min2(min2_3[3]));
select4to2 U52 (.input0(min1_2[8]),.input1(min2_2[8]),.input2(min1_2[9]),.input3(min2_2[9]),
              .input_addr0(min1_addr2[8][5:0]),.input_addr1(min2_addr2[8][5:0]),.input_addr2(min1_addr2[9][5:0]),.input_addr3(min2_addr2[9][5:0]),
               .min1_addr(min1_addr3[4]),.min2_addr(min2_addr3[4]),.min1(min1_3[4]),.min2(min2_3[4]));
select4to2 U53 (.input0(min1_2[10]),.input1(min2_2[10]),.input2(min1_2[11]),.input3(min2_2[11]),
              .input_addr0(min1_addr2[10][5:0]),.input_addr1(min2_addr2[10][5:0]),.input_addr2(min1_addr2[11][5:0]),.input_addr3(min2_addr2[11][5:0]),
               .min1_addr(min1_addr3[5]),.min2_addr(min2_addr3[5]),.min1(min1_3[5]),.min2(min2_3[5]));
select4to2 U54 (.input0(min1_2[12]),.input1(min2_2[12]),.input2(min1_2[13]),.input3(min2_2[13]),
              .input_addr0(min1_addr2[12][5:0]),.input_addr1(min2_addr2[12][5:0]),.input_addr2(min1_addr2[13][5:0]),.input_addr3(min2_addr2[13][5:0]),
               .min1_addr(min1_addr3[6]),.min2_addr(min2_addr3[6]),.min1(min1_3[6]),.min2(min2_3[6]));
select4to2 U55 (.input0(min1_2[14]),.input1(min2_2[14]),.input2(min1_2[15]),.input3(min2_2[15]),
              .input_addr0(min1_addr2[14][5:0]),.input_addr1(min2_addr2[14][5:0]),.input_addr2(min1_addr2[15][5:0]),.input_addr3(min2_addr2[15][5:0]),
               .min1_addr(min1_addr3[7]),.min2_addr(min2_addr3[7]),.min1(min1_3[7]),.min2(min2_3[7]));
select4to2 U56 (.input0(min1_3[0]),.input1(min2_3[0]),.input2(min1_3[1]),.input3(min2_3[1]),
              .input_addr0(min1_addr3[0][5:0]),.input_addr1(min2_addr3[0][5:0]),.input_addr2(min1_addr3[1][5:0]),.input_addr3(min2_addr3[1][5:0]),
               .min1_addr(min1_addr4[0]),.min2_addr(min2_addr4[0]),.min1(min1_4[0]),.min2(min2_4[0]));
select4to2 U57 (.input0(min1_3[2]),.input1(min2_3[2]),.input2(min1_3[3]),.input3(min2_3[3]),
              .input_addr0(min1_addr3[2][5:0]),.input_addr1(min2_addr3[2][5:0]),.input_addr2(min1_addr3[3][5:0]),.input_addr3(min2_addr3[3][5:0]),
               .min1_addr(min1_addr4[1]),.min2_addr(min2_addr4[1]),.min1(min1_4[1]),.min2(min2_4[1]));
select4to2 U58 (.input0(min1_3[4]),.input1(min2_3[4]),.input2(min1_3[5]),.input3(min2_3[5]),
              .input_addr0(min1_addr3[4][5:0]),.input_addr1(min2_addr3[4][5:0]),.input_addr2(min1_addr3[5][5:0]),.input_addr3(min2_addr3[5][5:0]),
               .min1_addr(min1_addr4[2]),.min2_addr(min2_addr4[2]),.min1(min1_4[2]),.min2(min2_4[2]));
select4to2 U59 (.input0(min1_3[6]),.input1(min2_3[6]),.input2(min1_3[7]),.input3(min2_3[7]),
              .input_addr0(min1_addr3[6][5:0]),.input_addr1(min2_addr3[6][5:0]),.input_addr2(min1_addr3[7][5:0]),.input_addr3(min2_addr3[7][5:0]),
               .min1_addr(min1_addr4[3]),.min2_addr(min2_addr4[3]),.min1(min1_4[3]),.min2(min2_4[3]));
select4to2 U60 (.input0(min1_4[0]),.input1(min2_4[0]),.input2(min1_4[1]),.input3(min2_4[1]),
              .input_addr0(min1_addr4[0][5:0]),.input_addr1(min2_addr4[0][5:0]),.input_addr2(min1_addr4[1][5:0]),.input_addr3(min2_addr4[1][5:0]),
               .min1_addr(min1_addr5_next[0]),.min2_addr(min2_addr5_next[0]),.min1(min1_5_next[0]),.min2(min2_5_next[0]));
select4to2 U61 (.input0(min1_4[2]),.input1(min2_4[2]),.input2(min1_4[3]),.input3(min2_4[3]),
              .input_addr0(min1_addr4[2][5:0]),.input_addr1(min2_addr4[2][5:0]),.input_addr2(min1_addr4[3][5:0]),.input_addr3(min2_addr4[3][5:0]),
               .min1_addr(min1_addr5_next[1]),.min2_addr(min2_addr5_next[1]),.min1(min1_5_next[1]),.min2(min2_5_next[1]));
select4to2 U62 (.input0(min1_5[0]),.input1(min2_5[0]),.input2(min1_5[1]),.input3(min2_5[1]),
              .input_addr0(min1_addr5[0][5:0]),.input_addr1(min2_addr5[0][5:0]),.input_addr2(min1_addr5[1][5:0]),.input_addr3(min2_addr5[1][5:0]),
               .min1_addr(min1_addr_inv),.min2_addr(min2_addr_inv),.min1(min1),.min2(min2));



//sram_addr_next
always @(*) begin
    if(state == COUNT || state == ENCODE) sram_addr_next = cnt*3 + cnt_channel;
    else sram_addr_next = sram_addr;
end


always @(*) begin
    if(state == COUNT || state == ENCODE) cnt_next = cnt + 1;
    else cnt_next = 0;
end


//sram_next
always @(*) begin
    code_length_next1 = AC_length[{R[2:0],L[3:0]}];
    code_length_next2 = AC_length[{R[5:3],L[7:4]}];
    code_length_next3 = AC_length[{R[8:6],L[11:8]}];
    code_length_next4 = AC_length[{R[11:9],L[15:12]}];
    code_length_next5 = AC_length[{R[14:12],L[19:16]}];
    code_length_next6 = AC_length[{R[17:15],L[23:20]}];
    code_length_next7 = AC_length[{R[20:18],L[27:24]}];
    code_length_next8 = AC_length[{R[23:21],L[31:28]}];
end

//sram_next
always @(*) begin
    code_out_next1 = AC_length[{R[2:0],L[3:0]}];
    code_out_next2 = AC_length[{R[5:3],L[7:4]}];
    code_out_next3 = AC_length[{R[8:6],L[11:8]}];
    code_out_next4 = AC_length[{R[11:9],L[15:12]}];
    code_out_next5 = AC_length[{R[14:12],L[19:16]}];
    code_out_next6 = AC_length[{R[17:15],L[23:20]}];
    code_out_next7 = AC_length[{R[20:18],L[27:24]}];
    code_out_next8 = AC_length[{R[23:21],L[31:28]}];
end

//count_finish
always@(*) begin
    count_finish = (cnt == 576 + 2);
end

//encode_finish
always @(*) begin
    encode_finish = (cnt == 576 + 2);
end
//code table
always @(*) begin
    if(state == ENCODE && cnt >= 2) begin
        code_length_table_next = AC_length[cnt-2];
        code_out_table_next = AC_hcode[cnt-2];
    end
    else begin
        code_length_table_next = code_length_table;
        code_out_table_next = code_out_table;
    end
end

//out valid
always @(*) begin
    if(state_next == ENCODE && cnt >= 2) out_valid_next = 1;
    else out_valid_next = 0;
end
//state_next
always @(*) begin
    case (state)
        IDLE: begin
            if(valid) state_next = COUNT;
            else state_next = IDLE;
        end
        COUNT: begin
            if(count_finish) state_next = TREE;
            else state_next = COUNT;
        end
        TREE: begin
            if(build_finish) state_next = ENCODE;
            else state_next = TREE;
        end
        ENCODE: begin
            if(encode_finish && cnt_channel == 2) state_next = DONE;
            else if(encode_finish) state_next = FINISH;
            else state_next = ENCODE;
        end 
        FINISH: begin
            state_next = IDLE;
        end
        DONE: begin
            state_next = DONE;
        end
        default: begin
            state_next = IDLE;
        end
    endcase
end

//cnt_channel_next
always@(*) begin
    if(state == FINISH) cnt_channel_next = cnt_channel + 1;
    else cnt_channel_next = cnt_channel;
end


//sequential
always @(posedge clk) begin
    if(~rst_n) begin
        cnt_tree <= 0;
        cnt <= 0;
        state <=  3'b0;
        code_length1 <= 0;
        code_length2 <= 0;
        code_length3 <= 0;
        code_length4 <= 0;
        code_length5 <= 0;
        code_length6 <= 0;
        code_length7 <= 0;
        code_length8 <= 0;
        code_out1 <= 0;
        code_out2 <= 0;
        code_out3 <= 0;
        code_out4 <= 0;
        code_out5 <= 0;
        code_out6 <= 0;
        code_out7 <= 0;
        code_out8 <= 0;

        code_out_table <= 0;
        code_length_table <= 0;

        cnt_channel <= 0;
        sram_addr <= 0;
        out_valid <= 0;
        //sram_data_ff <= 0;
        for(i = 0;i < 128;i = i + 1) begin
            AC_frequency[i] <= 0;
            AC_length[i] <= 0;
            AC_hcode[i] <= 0;
            for (j = 0;j < 128;j = j + 1) begin
                if(i == j) layer[i][j] <= 1;
                else layer[i][j] <= 0;
            end
        end
    end
    else begin
        out_valid <= out_valid_next;
        cnt_channel <= cnt_channel_next;
        cnt_tree <= cnt_tree_next;
        count_finish_ff <= count_finish;
        DC <= DC_in;
        R <= R_in;
        L <= L_in;
        F <= F_in;
        cnt <= cnt_next;
        state <= state_next;
        code_length1 <= code_length_next1;
        code_length2 <= code_length_next2;
        code_length3 <= code_length_next3;
        code_length4 <= code_length_next4;
        code_length5 <= code_length_next5;
        code_length6 <= code_length_next6;
        code_length7 <= code_length_next7;
        code_length8 <= code_length_next8;
        code_out1 <= code_out_next1;
        code_out2 <= code_out_next2;
        code_out3 <= code_out_next3;
        code_out4 <= code_out_next4;
        code_out5 <= code_out_next5;
        code_out6 <= code_out_next6;
        code_out7 <= code_out_next7;
        code_out8 <= code_out_next8;

        code_out_table <= code_out_table_next;
        code_length_table <= code_length_table_next;

        for(i = 0;i < 16;i = i + 1) begin
            min1_addr2[i] <= min1_addr2_next[i];
            min2_addr2[i] <= min2_addr2_next[i];
            min1_2[i] <= min1_2_next[i];
            min2_2[i] <= min2_2_next[i];
        end
        for(i = 0;i < 2;i = i + 1) begin
            min1_addr5[i] <= min1_addr5_next[i];
            min2_addr5[i] <= min2_addr5_next[i];
            min1_5[i] <= min1_5_next[i];
            min2_5[i] <= min2_5_next[i];
        end
        sram_addr <= sram_addr_next;
        //sram_data_ff <= sram_data;
        for(i = 0;i < 128;i = i + 1) begin
            AC_frequency[i] <= AC_frequency_next[i];
            AC_length[i] <= AC_length_next[i];
            AC_hcode[i] <= AC_hcode_next[i];
            layer[i] <= layer_next[i];
        end
    end
end
endmodule

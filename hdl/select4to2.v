module select4to2 (
  input [10:0]input0,
  input [10:0]input1,
  input [10:0]input2,
  input [10:0]input3,
  input [6-1:0] input_addr0,
  input [6-1:0] input_addr1,
  input [6-1:0] input_addr2,
  input [6-1:0] input_addr3,
  output reg [7-1:0] min1_addr,
  output reg [7-1:0] min2_addr,
  output reg [10:0] min1,
  output reg [10:0] min2
);

reg comp01,comp02,comp03,comp12,comp13,comp23;
reg iszero_0,iszero_1,iszero_2,iszero_3;
wire one_zero;

always @(*) begin
    comp01 = input0 >= input1;
    comp02 = input0 >= input2;
    comp03 = input0 >= input3;
    comp12 = input1 >= input2;
    comp13 = input1 >= input3;
    comp23 = input2 >= input3;
end

always @(*) begin
    iszero_0 = input0 == 0;
    iszero_1 = input1 == 0;
    iszero_2 = input2 == 0;
    iszero_3 = input3 == 0;
end

assign one_zero = (iszero_0 + iszero_1 + iszero_2 + iszero_3 == 1);
assign two_zero = (iszero_0 + iszero_1 + iszero_2 + iszero_3 == 2);
assign three_zero = (iszero_0 + iszero_1 + iszero_2 + iszero_3 == 3);

always@(*) begin
    case (1'b1)
        ((iszero_0||iszero_1||iszero_2||iszero_3) == 0): begin
            if((!comp02) & (!comp03) & (!comp12) & (!comp13)) begin
                min1 = input0;
                min2 = input1;
                min1_addr = {input_addr0,1'b0};
                min2_addr = {input_addr1,1'b0};
            end
            else if (comp02 & comp03 & comp12 & comp13) begin
                min1 = input2;
                min2 = input3;
                min1_addr = {input_addr2,1'b1};
                min2_addr = {input_addr3,1'b1};
            end
            else if ((!comp01) & (!comp03) & comp12 & (!comp23)) begin
                min1 = input0;
                min2 = input2;
                min1_addr = {input_addr0,1'b0};
                min2_addr = {input_addr2,1'b1};
            end
            else if (comp01 & comp03 & (!comp12) & comp23) begin
                min1 = input1;
                min2 = input3;
                min1_addr = {input_addr1,1'b0};
                min2_addr = {input_addr3,1'b1};
            end
            else if ((!comp01) & (!comp02) & comp13 & comp23) begin
                min1 = input0;
                min2 = input3;
                min1_addr = {input_addr0,1'b0};
                min2_addr = {input_addr3,1'b1};
            end
            else begin
                min1 = input1;
                min2 = input2;
                min1_addr = {input_addr1,1'b0};
                min2_addr = {input_addr2,1'b1};
            end
            /*else if (comp01 & comp02 & (!comp13) & (!comp23)) begin
                min1 = input1;
                min2 = input2;
            end*/
        end 
        one_zero: begin
            if(iszero_0) begin
                if((!comp13) & (!comp23))begin
                    min1 = input1;
                    min2 = input2;
                    min1_addr = {input_addr1,1'b0};
                    min2_addr = {input_addr2,1'b1};
                end
                else if(comp12 & comp23) begin
                    min1 = input2;
                    min2 = input3;
                    min1_addr = {input_addr2,1'b1};
                    min2_addr = {input_addr3,1'b1};
                end
                else begin
                    min1 = input1;
                    min2 = input3;
                    min1_addr = {input_addr1,1'b0};
                    min2_addr = {input_addr3,1'b1};
                end
            end
            else if(iszero_1) begin
                if((!comp03) & (!comp23))begin
                    min1 = input0;
                    min2 = input2;
                    min1_addr = {input_addr0,1'b0};
                    min2_addr = {input_addr2,1'b1};
                end
                else if(comp02 & comp03) begin
                    min1 = input2;
                    min2 = input3;
                    min1_addr = {input_addr2,1'b1};
                    min2_addr = {input_addr3,1'b1};
                end
                else begin
                    min1 = input0;
                    min2 = input3;
                    min1_addr = {input_addr0,1'b0};
                    min2_addr = {input_addr3,1'b1};
                end
            end
            else if (iszero_2) begin
                if((!comp03) & (!comp13))begin
                    min1 = input0;
                    min2 = input1;
                    min1_addr = {input_addr0,1'b0};
                    min2_addr = {input_addr1,1'b0};
                end
                else if((!comp01) & comp13) begin
                    min1 = input0;
                    min2 = input3;
                    min1_addr = {input_addr0,1'b0};
                    min2_addr = {input_addr3,1'b1};
                end
                else begin
                    min1 = input1;
                    min2 = input3;
                    min1_addr = {input_addr1,1'b0};
                    min2_addr = {input_addr3,1'b1};
                end
            end
            else begin
                if((!comp02) & (!comp12))begin
                    min1 = input0;
                    min2 = input1;
                    min1_addr = {input_addr0,1'b0};
                    min2_addr = {input_addr1,1'b0};
                end
                else if((!comp01) & comp12) begin
                    min1 = input0;
                    min2 = input2;
                    min1_addr = {input_addr0,1'b0};
                    min2_addr = {input_addr2,1'b1};
                end
                else begin
                    min1 = input1;
                    min2 = input2;
                    min1_addr = {input_addr1,1'b0};
                    min2_addr = {input_addr2,1'b1};
                end
            end
        end
        two_zero: begin
            if(!iszero_0 & !iszero_1) begin
                min1 = input0;
                min2 = input1;
                min1_addr = {input_addr0,1'b0};
                min2_addr = {input_addr1,1'b0};
            end
            else if(!iszero_0 & !iszero_2) begin
                min1 = input0;
                min2 = input2;
                min1_addr = {input_addr0,1'b0};
                min2_addr = {input_addr2,1'b1};
            end
            else if(!iszero_0 & !iszero_3) begin
                min1 = input0;
                min2 = input3;
                min1_addr = {input_addr0,1'b0};
                min2_addr = {input_addr3,1'b1};
            end
            else if(!iszero_1 & !iszero_2) begin
                min1 = input1;
                min2 = input2;
                min1_addr = {input_addr1,1'b0};
                min2_addr = {input_addr2,1'b1};
            end
            else if(!iszero_1 & !iszero_3) begin
                min1 = input1;
                min2 = input3;
                min1_addr = {input_addr1,1'b0};
                min2_addr = {input_addr3,1'b1};
            end
            else begin
                min1 = input2;
                min2 = input3;
                min1_addr = {input_addr2,1'b1};
                min2_addr = {input_addr3,1'b1};
            end
        end
        three_zero: begin
            if(!iszero_0) begin
                min1 = input0;
                min2 = input1;
                min1_addr = {input_addr0,1'b0};
                min2_addr = {input_addr1,1'b0};
            end
            else if(!iszero_1) begin
                min1 = input1;
                min2 = input2;
                min1_addr = {input_addr1,1'b0};
                min2_addr = {input_addr2,1'b1};
            end
            else if(!iszero_2) begin
                min1 = input2;
                min2 = input3;
                min1_addr = {input_addr2,1'b1};
                min2_addr = {input_addr3,1'b1};
            end
            else begin
                min1 = input2;
                min2 = input3;
                min1_addr = {input_addr2,1'b1};
                min2_addr = {input_addr3,1'b1};
            end
        end
        default: begin
            min1 = input0;
            min2 = input1;
            min1_addr = {input_addr0,1'b0};
            min2_addr = {input_addr1,1'b0};
        end 
    endcase
end

endmodule
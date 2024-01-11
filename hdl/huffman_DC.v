module huffman_DC(
    input clk,
    input rst_n,
    input signed [11-1:0] DC,

    output reg [5-1:0] code_length,
    output reg [20-1:0] code_out
);


reg [5-1:0] code_length_next;
reg [20-1:0] code_out_next;

wire [10:0] DC_abs;
wire [10:0] DC_abs_inv;

assign DC_abs = DC[10] ? (~DC + 1): DC;
assign DC_abs_inv = ~DC_abs;
//static huffman encoding
always @(*) begin
    if(DC == 1'b0) begin    //cat0
        code_length_next = 1 + 2;
        code_out_next = {{2'b00},DC_abs[0]};
    end
    else if(DC >= -1 && DC <= 1) begin  //cat1
        code_length_next = 1 + 3;
        code_out_next = DC[10] ? {{3'b010},DC_abs_inv[0]} :{{3'b010},DC_abs[0]};
    end
    else if(DC >= -3 && DC <= 3) begin  //cat2
        code_length_next = 2 + 3;
        code_out_next = DC[10] ? {{3'b011},DC_abs_inv[1:0]} :{{3'b011},DC_abs[1:0]};
    end
    else if(DC >= -7 && DC <= 7) begin  //cat3
        code_length_next = 3 + 3;
        code_out_next = DC[10] ? {{3'b100},DC_abs_inv[2:0]} :{{3'b100},DC_abs[2:0]};
    end
    else if(DC >= -15 && DC <= 15) begin    //cat4
        code_length_next = 4 + 3;
        code_out_next = DC[10] ? {{3'b101},DC_abs_inv[3:0]} :{{3'b101},DC_abs[3:0]};
    end
    else if(DC >= -31 && DC <= 31) begin    //cat5
        code_length_next = 5 + 3;
        code_out_next = DC[10] ? {{3'b110},DC_abs_inv[4:0]} :{{3'b110},DC_abs[4:0]};
    end
    else if(DC >= -63 && DC <= 63) begin    //cat6
        code_length_next = 6 + 4;
        code_out_next = DC[10] ? {{4'b1110},DC_abs_inv[5:0]} :{{4'b1110},DC_abs[5:0]};
    end
    else if(DC >= -127 && DC <= 127) begin  //cat7
        code_length_next = 7 + 5;
        code_out_next = DC[10] ? {{5'b11110},DC_abs_inv[6:0]} :{{5'b11110},DC_abs[6:0]};
    end
    else if(DC >= -255 && DC <= 255) begin  //cat8
        code_length_next = 8 + 6;
        code_out_next = DC[10] ? {{6'b111110},DC_abs_inv[7:0]} :{{6'b111110},DC_abs[7:0]};
    end
    else if(DC >= -511 && DC <= 511) begin  //cat9
        code_length_next = 9 + 7;
        code_out_next = DC[10] ? {{7'b1111110},DC_abs_inv[8:0]} :{{7'b1111110},DC_abs[8:0]};
    end
    else if(DC >= -1023 && DC <= 1023) begin    //cat10
        code_length_next = 10 + 8;
        code_out_next = DC[10] ? {{8'b11111110},DC_abs_inv[9:0]} :{{8'b11111110},DC_abs[9:0]};
    end
    else begin  //cat11
        code_length_next = 11 + 9;
        code_out_next = DC[10] ? {{9'b111111110},DC_abs_inv[10:0]} :{{9'b111111110},DC_abs[10:0]};
    end
end


always @(posedge clk) begin
    if(~rst_n) begin
        code_length <= 0;
        code_out <= 0;
    end
    else begin
        code_length <= code_length_next;
        code_out <= code_out_next;
    end
end
endmodule

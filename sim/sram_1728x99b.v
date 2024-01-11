//==================================================================================================
//  Note:          Use only for teaching materials of IC Design Lab, NTHU.
//  Copyright: (c) 2022 Vision Circuits and Systems Lab, NTHU, Taiwan. ALL Rights Reserved.
//==================================================================================================


module sram_1728x99b (
    input clk,
    input csb,  //chip enable
    input wsb,  //write enable
    input [99-1:0] wdata, //write data
    input [11-1:0] waddr, //write address
    input [11-1:0] raddr, //read address

    output reg [99-1:0] rdata
);

reg [99-1:0] mem [0:1728-1];
reg [99-1:0] _rdata;

always @(negedge clk) begin
    if(~csb && ~wsb)
        mem[waddr] <= wdata;
end

always @(negedge clk) begin
    if(~csb)
        _rdata <= mem[raddr];
end

always @* begin
    rdata = #(1) _rdata;
end

task load_param(
    input integer index,
    input [99-1:0] param_input
);
    mem[index] = param_input;
endtask

endmodule
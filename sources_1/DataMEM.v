`timescale 1ns / 1ps
module DataMEM(
    input CLK,
    input RD,
    input WR,
    input [31:0] DAddr,
    input [31:0] DataIn,
    output reg [31:0] DataOut
    );
    
    initial begin 
        DataOut <= 16'b0;
    end
    reg [7:0] ram [0:31];      
    
    always@(RD or DAddr) begin
        DataOut[7:0] = RD ? ram[DAddr + 3] : 8'bz;      
        DataOut[15:8] = RD ? ram[DAddr + 2] : 8'bz;     
        DataOut[23:16] = RD ? ram[DAddr + 1] : 8'bz;     
        DataOut[31:24] = RD ? ram[DAddr] : 8'bz;
    end
     
    always@(posedge CLK) begin   
        if(WR) begin
                ram[DAddr] = DataIn[31:24];    
                ram[DAddr + 1] = DataIn[23:16];
                ram[DAddr + 2] = DataIn[15:8];     
                ram[DAddr + 3] = DataIn[7:0];    
         end
    end
endmodule

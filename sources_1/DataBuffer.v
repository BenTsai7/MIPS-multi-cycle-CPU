module DataBuffer(
    input CLK,
    input [31:0] data,
    output reg[31:0] out
    );
    initial begin
        out = 0;
    end
    always@(negedge CLK) begin
        out <= data;
    end
endmodule

module IR(
        input CLK,
        input IRWre,
        input [31:0] instruction,
        output reg[31:0] out
    );
    initial begin
        out = 0;
    end
    always@(posedge CLK) begin
        if (IRWre) begin
            out <= instruction;
        end
        else begin
            out <= out;
        end
    end
endmodule

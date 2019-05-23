module SignZeroExtend(
        input wire [15:0] immediate,
        input ExtSel,                   
        output [31:0] extendImmediate
    );
    assign extendImmediate[15:0] = immediate;
    assign extendImmediate[31:16] = ExtSel ? (immediate[15] ? 16'hffff : 16'h0000) : 16'h0000;
endmodule
module dithering_process(
        input CLK,
        input signal,
        output out
    );
    parameter SAMPLE_TIME = 50000;
    reg [21:0] count_low;
    reg [21:0] count_high;
    reg key_out_reg;
    always @(posedge CLK)
    if(signal ==1'b0)
    count_low <= count_low + 1;
    else
    count_low <= 0;
    always @(posedge CLK)
    if(signal ==1'b1)
    count_high <= count_high + 1;
    else
    count_high <= 0;
    always @(posedge CLK)
    if(count_high == SAMPLE_TIME)
    key_out_reg <= 1;
    else if(count_low == SAMPLE_TIME)
    key_out_reg <= 0;
    assign out = key_out_reg;
    endmodule 

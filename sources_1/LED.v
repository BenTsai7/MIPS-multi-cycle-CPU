module LED(
    input clk,
    input [15:0] display,
    output reg [6:0] seg,
    output reg [3:0] AN
    );

    
     
    parameter MAX= 99999;
    wire change;
    reg [27:0] counter_div;
    reg [3:0] counter;
    reg [3:0] data;  
    wire [3:0] display1, display2, display3, display4;
    assign display1 = display[15:12];
    assign display2 = display[11:8];
    assign display3 = display[7:4];
    assign display4 = display[3:0];
    assign change = (counter_div == 0);

    always@ (posedge clk)
    begin
        if (counter_div == MAX)
            counter_div <= 0;
        else
            counter_div <= counter_div + 1;    
    end

    always @(posedge clk)
    begin
      if(change)
        if (counter == 3)
               counter = 0;
        else
           counter = counter + 1'b1; 
    end

    always @(counter)
    begin
        case(counter)
            0: AN = 4'b0111;
            1: AN = 4'b1011;
            2: AN = 4'b1101;
            3: AN = 4'b1110;
            default: AN = 4'b0111;
        endcase
    end

    always @(data)
    begin
        case(data)
            0: seg = 7'b100_0000;
            1: seg = 7'b111_1001;
            2: seg = 7'b010_0100;
            3: seg = 7'b011_0000;
            4: seg = 7'b001_1001;
            5: seg = 7'b001_0010;
            6: seg = 7'b000_0010;
            7: seg = 7'b111_1000;
            8: seg = 7'b000_0000;
            9: seg = 7'b001_0000;
            10: seg = 7'b000_1000;
            11: seg = 7'b001_0011;
            12: seg = 7'b100_0110;
            13: seg = 7'b010_0001;
            14: seg = 7'b000_0110;
            15: seg = 7'b000_1110;
            default: seg = 7'b111_1111;
        endcase
    end

    always @(counter, display1, display2, display3, display4)
    begin
        case(counter)
            0: data = display1;
            1: data = display2;
            2: data = display3;
            3: data = display4;
            default: data = display1;
        endcase
    end   

endmodule
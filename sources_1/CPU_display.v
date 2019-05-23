module CPU_Basy3(
    input clk,
    input button,
    input Reset,
    input [2:0] sw,
    output reg [6:0] seg,
    output reg [3:0] AN
    );                   

    wire CLK;
    reg [15:0] display;
    initial 
    begin
        display = 0;
    end
    wire [6:0] w1;
    wire [3:0] w2;
    wire [2:0] w3;
    wire [31:0] curPC,nextPC,ALUResult,DB,ReadData1,ReadData2;
    wire [4:0] rs,rt;
    reg [2:0] status;

    always@(w1) begin
        seg = w1;
    end
    
    always@(w2) begin
        AN = w2;
    end
    
    always@(w3) begin
        status = w3;
    end
    
    dithering_process dp(clk,button,CLK);
 
    MultipleCycleCPU CPU(CLK,Reset,curPC, nextPC,DB,ALUResult,rs, rt,ReadData1,ReadData2,w3);
        always@(sw or curPC or nextPC or ALUResult or DB or rs or ReadData1 or rt or ReadData2) begin
            case(sw) 
                3'b000: 
                    begin
                        display[15:8] = curPC[7:0];
                        display[7:0] = nextPC[7:0];
                    end
                3'b001:
                    begin
                        display[15:13] = 0;
                        display[12:8] = rs[4:0];
                        display[7:0] = ReadData1[7:0];
                    end                
                3'b010:
                    begin
                        display[15:13] = 0;
                        display[12:8] = rt[4:0];
                        display[7:0] = ReadData2[7:0];
                    end   
                3'b011:
                    begin
                        display[15:8] = ALUResult[7:0];
                        display[7:0] = DB[7:0];
                    end
                3'b100:
                    begin
                        display[15:8] = 0;
                        display[7:3] = 0;
                        display[2:0] = status;
                    end
            endcase
        end
    LED led(clk,display,w1,w2);
endmodule
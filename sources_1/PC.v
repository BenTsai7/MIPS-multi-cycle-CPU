module PC(
       input CLK,              
       input Reset,             
       input PCWre,             
       input [1:0] PCSrc,            
       input [31:0] immediate,  
       input [25:0] addr,
       input [31:0] rs_val,
       output reg [31:0] curPC, 
       output reg [31:0] PC4,
       output reg [31:0] nextPC
    );
    initial begin
        curPC <= 0;
        nextPC <= 0; 
    end

    always@(curPC) begin
        PC4 = curPC + 4;
    end    

    always@(negedge CLK or negedge Reset)
    begin

        if(!Reset) begin
            nextPC <= 0;
        end
        else begin
            case(PCSrc)
                2'b00: nextPC <= curPC + 4;
                2'b01: nextPC <= curPC + 4 + immediate * 4;
                2'b10: nextPC <= rs_val;
                2'b11: nextPC <= {PC4[31:28],addr,2'b00};
            endcase
        end
    end
    
    always@(posedge CLK or negedge Reset)
    begin
        if(!Reset) 
                curPC <= 0;
        else 
            begin
                if(PCWre) 
                        curPC <= nextPC;
                else   
                        curPC <= curPC;
            end
    end
endmodule
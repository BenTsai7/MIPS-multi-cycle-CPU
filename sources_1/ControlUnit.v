module ControlUnit(
        input zero,
        input sign,
        input CLK,
        input RST,         
        input [5:0] op,     
        output reg PCWre, 
        output reg ALUSrcA,     
        output reg ALUSrcB,      
        output reg DBDataSrc, 
        output reg RegWre, 
        output reg WrRegDSrc,
        output reg InsMemRW, 
        output reg mRD,         
        output reg mWR, 
        output reg IRWre,     
        output reg ExtSel,   
        output reg [1:0] PCSrc,  
        output reg [1:0] RegDst,  
        output reg [2:0] ALUOp, 
        output reg [2:0] status  
    );
    
    parameter ADD  = 6'b000000;
    parameter SUB  = 6'b000001;
    parameter ADDI = 6'b000010;
    parameter AND  = 6'b010000;
    parameter ORI  = 6'b010010;
    parameter ANDI = 6'b010001;
    parameter XORI = 6'b010011;
    parameter SLL  = 6'b011000;
    parameter SLT  = 6'b100110;
    parameter SLTIU= 6'b100111;
    parameter SW   = 6'b110000;
    parameter LW   = 6'b110001;
    parameter BEQ  = 6'b110100;
    parameter BNE = 6'b110101;
    parameter BLTZ = 6'b110110;
    parameter J    = 6'b111000;
    parameter JR   = 6'b111001;
    parameter JAL  = 6'b111010;
    parameter HALT = 6'b111111;
    
    parameter sIF = 3'b000;
    parameter sID = 3'b001;
    parameter sEXE= 3'b010;
    parameter sMEM= 3'b100;
    parameter sWB = 3'b011;
    initial begin
        InsMemRW = 1;
        PCWre = 1;
        mRD = 0;
        mWR = 0;
        DBDataSrc = 0;
        status = 3'b000;
    end
    
    always@(negedge CLK or negedge RST) begin
        if (RST == 0) begin
            status <= 3'b000;
        end
        else begin
            case (status) 
                sIF: status <= sID;
                sID: begin
                        case (op)
                            J, JR, HALT: status <= sIF;
                            JAL: status <= sWB;
                            default: status <= sEXE;
                        endcase
                end
                sEXE: begin
                        case (op)
                            BEQ, BNE,BLTZ: status <= sIF;
                            SW, LW: status <= sMEM;
                            default: status <= sWB;
                        endcase
                end
                sMEM: begin
                        case (op)
                            SW: status <= sIF;
                            default: status <= sWB;
                        endcase
                end
                sWB: status <= sIF;
                default: status <= sIF;           
            endcase
        end
    end
    
    always@(op or zero or sign or status) 
    begin
        InsMemRW = 1;  
        PCWre = (op != HALT && status == sIF) ? 1 : 0;   //halt
        ALUSrcA = (op == SLL) ? 1 : 0;
        ALUSrcB = (op == ADDI || op == ORI || op == SLTIU || op==ANDI || op==XORI || op == LW || op == SW) ? 1 : 0;
        DBDataSrc = (op == LW) ? 1 : 0;
        RegWre = (status != sWB || op == BEQ ||op == BNE || op == BLTZ || op == J || op == SW || op == JR || op == HALT) ? 0 : 1;
        WrRegDSrc = (op == JAL) ? 0 : 1;
        
        mRD = (status == sMEM && op == LW) ? 1 : 0;
        mWR = (status == sMEM && op == SW) ? 1 : 0;     //sw
        IRWre = (status == sID) ? 1 : 0;
        ExtSel = (op == ORI || op == SLTIU || op==ANDI || op==XORI) ? 0 : 1;
        
        case (op) 
            J, JAL: PCSrc = 2'b11;
            JR: PCSrc = 2'b10;
            BEQ: PCSrc = (zero == 1) ? 2'b01 : 2'b00;
            BNE: PCSrc = (zero == 0) ? 2'b01 : 2'b00;
            BLTZ: PCSrc = (sign == 1 && zero == 0) ? 2'b01: 2'b00;
            default: PCSrc = 2'b00;
        endcase
        
        case (op)
            JAL: RegDst = 2'b00;
            ADDI, ORI, SLTIU, ANDI,XORI,LW: RegDst = 2'b01;
            default: RegDst = 2'b10;
        endcase
        
        case (op) 
            ADD, ADDI, SW, LW: 
                    ALUOp = 3'b000;
            SUB, BEQ,BNE,BLTZ: 
                    ALUOp = 3'b001;
            SLTIU:
                    ALUOp = 3'b010;
            SLT:
                    ALUOp = 3'b011;
            SLL:
                    ALUOp = 3'b100;
            ORI:
                    ALUOp = 3'b101;
            AND,ANDI:
                    ALUOp = 3'b110;
            XORI:
                    ALUOp=3'b111;
            default:
                    ALUOp = 3'b000;         
        endcase
    end
endmodule

module MultipleCycleCPU(
        input CLK,
        input RST,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] DB,
        output [31:0] ALUResult,
        output [4:0] rs,
        output [4:0] rt,
        output [31:0] ReadData1,
        output [31:0]  ReadData2,
        output [2:0] status  
    );
    //信号
    wire zero, sign, PCWre, ALUSrcA, ALUSrcB, DBDataSrc, RegWre, WrRegDSrc, InsMemRW, mRD, mWR, IRWre, ExtSel;   
    wire [1:0] PCSrc;
    wire [1:0] RegDst;
    wire [2:0] ALUOp;

    //指令相关
    wire [31:0] ins;
    wire [5:0] op;
    wire [4:0] rd, sa;
    wire [15:0] immediate;
    wire [31:0] extend;
    wire [25:0] addr;

    //数据线
    wire [31:0]  ADR_out,BDR_out,PC4, IDataOut,ALUoutDR_out, DataOut;
       
    //指令解码
    assign op = ins[31:26];
    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    assign sa = ins[10:6];
    assign immediate = ins[15:0];
    assign addr = ins[25:0];
    
    RegisterFile RegisterFile(.CLK(CLK),.RegWre(RegWre),.rs(rs),.rt(rt),.rd(rd),.RegDst(RegDst),
        .WriteData(WrRegDSrc ? DB : PC4),.ReadData1(ReadData1),.ReadData2(ReadData2));
    SignZeroExtend SignZeroExtend(.immediate(immediate),.ExtSel(ExtSel),.extendImmediate(extend));
    PC PC(.CLK(CLK),.Reset(RST),.PCWre(PCWre),.PCSrc(PCSrc),.immediate(extend),.addr(addr),.curPC(curPC),.PC4(PC4),.nextPC(nextPC),.rs_val(ReadData1));            
    InsMEM InsMEM(.IAddr(curPC), .RW(InsMemRW), .IDataOut(IDataOut));    
    IR IR(.CLK(CLK),.IRWre(IRWre),.instruction(IDataOut),.out(ins)); 
    DataBuffer ADR(.CLK(CLK),.data(ReadData1),.out(ADR_out));
    DataBuffer BDR(.CLK(CLK), .data(ReadData2),.out(BDR_out));
    ALU ALU(.ALUOp(ALUOp),.A(ALUSrcA ? sa : ADR_out),.B(ALUSrcB ? extend: BDR_out),.result(ALUResult),.zero(zero),.sign(sign));        
    DataBuffer ALUoutDR(.CLK(CLK),.data(ALUResult),.out(ALUoutDR_out)); 
    ControlUnit ControlUnit(.zero(zero),.sign(sign),.CLK(CLK),.RST(RST),.op(op),.PCWre(PCWre),.ALUSrcA(ALUSrcA),.ALUSrcB(ALUSrcB),   .DBDataSrc(DBDataSrc),
                            .RegWre(RegWre),.WrRegDSrc(WrRegDSrc),.InsMemRW(InsMemRW),        .mRD(mRD),.mWR(mWR),
                            .IRWre(IRWre),.ExtSel(ExtSel),.PCSrc(PCSrc),.RegDst(RegDst),.ALUOp(ALUOp),.status(status)
                            );
    DataMEM DataMEM(.RD(mRD),.WR(mWR),.CLK(CLK),.DAddr(ALUoutDR_out),.DataIn(BDR_out),.DataOut(DataOut));
    DataBuffer DBDR(.CLK(CLK),.data(DBDataSrc==1 ? DataOut : ALUResult),.out(DB));
endmodule
//----------------------------------------------------------------------
//  TimDecode: Decode Operation Timings
//----------------------------------------------------------------------
module  TimDecode (
    input   [15:0]  ir,             //  Instruction word
    input   [1:0]   cycle,          //  Cycle count
    input           skip_en,        //  Skip enable (operation inhibit)
    output          tim_cyc_end,    //  Timing of cycle termination
    output          tim_pc_en,      //  Timing of program counter update
    output          tim_pm_re,      //  Timing of program memory read
    output          tim_dm_re,      //  Timing of data memory space read
    output          tim_dm_we,      //  Timing of data memory space write
    output          tim_rf_we,      //  Timing of register file write
    output          tim_sr_en,      //  Timing of status register update
    output          tim_sp_en       //  Timing of stack pointer update
);

reg [0:7]   tim_decode;

assign  tim_cyc_end = tim_decode[0] & ~skip_en;
assign  tim_pc_en   = tim_decode[1] & ~skip_en;
assign  tim_pm_re   = tim_decode[2] & ~skip_en;
assign  tim_dm_re   = tim_decode[3] & ~skip_en;
assign  tim_dm_we   = tim_decode[4] & ~skip_en;
assign  tim_rf_we   = tim_decode[5] & ~skip_en;
assign  tim_sr_en   = tim_decode[6] & ~skip_en;
assign  tim_sp_en   = tim_decode[7] & ~skip_en;

`include "OpDefine.v"
always @* begin
    tim_decode = 8'b 0000_0000;
    casex (ir)
    //--------------------------------------------------
    //  Arithmetic and Logic Instructions
    //--------------------------------------------------
    C_ADD    ,  //  ADD  Rd,Rr
    C_ADC    ,  //  ADC  Rd,Rr
    C_ADIW   ,  //  ADIW Rd,K
    C_SUB    ,  //  SUB  Rd,Rr
    C_SUBI   ,  //  SUBI Rd,K
    C_SBC    ,  //  SBC  Rd,Rr
    C_SBCI   ,  //  SBCI Rd,K
    C_SBIW   ,  //  SBIW Rd,K
    C_AND    ,  //  AND  Rd,Rr
    C_ANDI   ,  //  ANDI Rd,K
    C_OR     ,  //  OR   Rd,Rr
    C_ORI    ,  //  ORI  Rd,K
    C_EOR    ,  //  EOR  Rd,Rr
    C_COM    ,  //  COM  Rd
    C_NEG    ,  //  NEG  Rd
    C_INC    ,  //  INC  Rd
    C_DEC    :  //  DEC  Rd
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0110;
                default : ;
                endcase
    C_MUL    ,  //  MUL  Rd,Rr
    C_MULS   ,  //  MULS Rd,Rr
    C_MULSU  ,  //  MULSU  Rd,Rr
    C_FMUL   ,  //  FMUL   Rd,Rr
    C_FMULS  ,  //  FMULS  Rd,Rr
    C_FMULSU :  //  FMULSU Rd,Rr
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0000_0000;
                2'd1    : tim_decode = 8'b 1110_0110;
                default : ;
                endcase
    //--------------------------------------------------
    //  Branch Instructions
    //--------------------------------------------------
    C_JMP    :  //  JMP  k
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0110_0000;
                2'd1    : tim_decode = 8'b 0110_0000;
                2'd2    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    C_RJMP   ,  //  RJMP k
    C_IJMP   :  //  IJMP
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0110_0000;
                2'd1    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    C_CALL   :  //  CALL k
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0110_0000;
                2'd1    : tim_decode = 8'b 0000_1001;
                2'd2    : tim_decode = 8'b 0110_1001;
                2'd3    : tim_decode = 8'b 1110_0000;
                endcase
    C_RCALL  ,  //  RCALL k
    C_ICALL  :  //  ICALL
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0000_1001;
                2'd1    : tim_decode = 8'b 0110_1001;
                2'd2    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    C_RET    :  //  RET
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0001;
                2'd1    : tim_decode = 8'b 0101_0001;
                2'd2    : tim_decode = 8'b 0110_0000;
                2'd3    : tim_decode = 8'b 1110_0000;
                endcase
    C_RETI   :  //  RETI
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0001;
                2'd1    : tim_decode = 8'b 0101_0001;
                2'd2    : tim_decode = 8'b 0110_0010;
                2'd3    : tim_decode = 8'b 1110_0000;
                endcase
    C_CP     ,  //  CP   Rd,Rr
    C_CPC    ,  //  CPC  Rd,Rr
    C_CPI    :  //  CPI  Rd,K
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0010;
                default : ;
                endcase
    C_CPSE   ,  //  CPSE Rd,Rr
    C_SBRC   ,  //  SBRC Rr,b
    C_SBRS   :  //  SBRS Rr,b
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    C_SBIC   ,  //  SBIC A,b
    C_SBIS   :  //  SBIS A,b
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0000;
                2'd1    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    C_BRBS   ,  //  BRBS s,k
    C_BRBC   :  //  BRBC s,k (true condition timing)
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0110_0000;
                2'd1    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    //--------------------------------------------------
    //  Data Transfer Instructions
    //--------------------------------------------------
    C_MOV    ,  //  MOV  Rd,Rr
    C_MOVW   ,  //  MOVW Rd,Rr
    C_LDI    :  //  LDI  Rd,K
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0100;
                default : ;
                endcase
    C_LDS    :  //  LDS  Rd,k
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0110_0000;
                2'd1    : tim_decode = 8'b 0001_0000;
                2'd2    : tim_decode = 8'b 1110_0100;
                default : ;
                endcase
    C_LDX    ,  //  LD   Rd,X
    C_LDDY   ,  //  LDD  Rd,Y+q
    C_LDDZ   :  //  LDD  Rd,Z+q
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0000;
                2'd1    : tim_decode = 8'b 1110_0100;
                default : ;
                endcase
    C_LDXI   ,  //  LD   Rd,X+
    C_LDXD   ,  //  LD   Rd,-X
    C_LDYI   ,  //  LD   Rd,Y+
    C_LDYD   ,  //  LD   Rd,-Y
    C_LDZI   ,  //  LD   Rd,Z+
    C_LDZD   :  //  LD   Rd,-Z
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0100;
                2'd1    : tim_decode = 8'b 1110_0100;
                default : ;
                endcase
    C_STS    :  //  STS  k,Rr
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0110_0000;
                2'd1    : tim_decode = 8'b 1110_1000;
                default : ;
                endcase
    C_STX    ,  //  ST   X,Rr
    C_STDY   ,  //  STD  Y+q,Rr
    C_STDZ   :  //  STD  Z+q,Rr
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_1000;
                default : ;
                endcase
    C_STXI   ,  //  ST   X+,Rr
    C_STXD   ,  //  ST   -X,Rr
    C_STYI   ,  //  ST   Y+,Rr
    C_STYD   ,  //  ST   -Y,Rr
    C_STZI   ,  //  ST   Z+,Rr
    C_STZD   :  //  ST   -Z,Rr
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_1100;
                default : ;
                endcase
    C_LPM    ,  //  LPM
    C_LPMZ   :  //  LPM  Rd,Z
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0010_0000;
                2'd1    : tim_decode = 8'b 0010_0100;
                2'd2    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    C_LPMZI  :  //  LPM  Rd,Z+
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0010_0100;
                2'd1    : tim_decode = 8'b 0010_0100;
                2'd2    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    C_SPM    :  //  SPM
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0000_0000;
                2'd1    : tim_decode = 8'b 0000_0000;
                2'd2    : tim_decode = 8'b 0010_0000;
                2'd3    : tim_decode = 8'b 1110_0000;
                endcase
    C_IN     :  //  IN   Rd,A
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0000;
                2'd1    : tim_decode = 8'b 1110_0100;
                default : ;
                endcase
    C_OUT    :  //  OUT  A,Rr
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_1000;
                default : ;
                endcase
    C_PUSH   :  //  PUSH Rr
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_1001;
                default : ;
                endcase
    C_POP    :  //  POP  Rd
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0001;
                2'd1    : tim_decode = 8'b 1110_0100;
                default : ;
                endcase
    //--------------------------------------------------
    //  Bit and Bit-test Instructions
    //--------------------------------------------------
    C_ASR    ,  //  ASR  Rd
    C_LSR    ,  //  LSR  Rd
    C_ROR    ,  //  ROR  Rd
    C_SWAP   :  //  SWAP Rd
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0110;
                default : ;
                endcase
    C_SBI    ,  //  SBI  A,b
    C_CBI    :  //  CBI  A,b
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 0001_0000;
                2'd1    : tim_decode = 8'b 1110_1000;
                default : ;
                endcase
    C_BLD    :  //  BLD  Rd,b
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0100;
                default : ;
                endcase
    C_BST    ,  //  BST  Rd,b
    C_BSET   ,  //  BSET s
    C_BCLR   :  //  BCLR s
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0010;
                default : ;
                endcase
    //--------------------------------------------------
    //  MCU Control Instructions
    //--------------------------------------------------
    C_NOP    :  //  NOP
                //                         CPPD DRSS
                //                         YCMM MFRP
                //                         CERR WWEE
                case (cycle)
                2'd0    : tim_decode = 8'b 1110_0000;
                default : ;
                endcase
    default  :
                tim_decode = 8'b 0000_0000;
    endcase
end
endmodule
//----------------------------------------------------------------------
//  Decoder Template
//----------------------------------------------------------------------
//  always @* begin
//      casex (ir)
//      //--------------------------------------------------
//      //  Arithmetic and Logic Instructions
//      //--------------------------------------------------
//      C_ADD    :  //  000011rdddddrrrr    ADD  Rd,Rr
//      C_ADC    :  //  000111rdddddrrrr    ADC  Rd,Rr
//      C_ADIW   :  //  10010110KKddKKKK    ADIW Rd,K
//      C_SUB    :  //  000110rdddddrrrr    SUB  Rd,Rr
//      C_SUBI   :  //  0101KKKKddddKKKK    SUBI Rd,K
//      C_SBC    :  //  000010rdddddrrrr    SBC  Rd,Rr
//      C_SBCI   :  //  0100KKKKddddKKKK    SBCI Rd,K
//      C_SBIW   :  //  10010111KKddKKKK    SBIW Rd,K
//      C_AND    :  //  001000rdddddrrrr    AND  Rd,Rr
//      C_ANDI   :  //  0111KKKKddddKKKK    ANDI Rd,K
//      C_OR     :  //  001010rdddddrrrr    OR   Rd,Rr
//      C_ORI    :  //  0110KKKKddddKKKK    ORI  Rd,K
//      C_EOR    :  //  001001rdddddrrrr    EOR  Rd,Rr
//      C_COM    :  //  1001010ddddd0000    COM  Rd
//      C_NEG    :  //  1001010ddddd0001    NEG  Rd
//      C_INC    :  //  1001010ddddd0011    INC  Rd
//      C_DEC    :  //  1001010ddddd1010    DEC  Rd
//      C_MUL    :  //  100111rdddddrrrr    MUL  Rd,Rr
//      C_MULS   :  //  00000010ddddrrrr    MULS Rd,Rr
//      C_MULSU  :  //  000000110ddd0rrr    MULSU  Rd,Rr
//      C_FMUL   :  //  000000110ddd1rrr    FMUL   Rd,Rr
//      C_FMULS  :  //  000000111ddd0rrr    FMULS  Rd,Rr
//      C_FMULSU :  //  000000111ddd1rrr    FMULSU Rd,Rr
//      //--------------------------------------------------
//      //  Branch Instructions
//      //--------------------------------------------------
//      C_JMP    :  //  1001010kkkkk110k    JMP  k
//      C_RJMP   :  //  1100kkkkkkkkkkkk    RJMP k
//      C_IJMP   :  //  1001010000001001    IJMP
//      C_CALL   :  //  1001010kkkkk111k    CALL k
//      C_RCALL  :  //  1101kkkkkkkkkkkk    RCALL k
//      C_ICALL  :  //  1001010100001001    ICALL
//      C_RET    :  //  1001010100001000    RET
//      C_RETI   :  //  1001010100011000    RETI
//      C_CP     :  //  000101rdddddrrrr    CP   Rd,Rr
//      C_CPC    :  //  000001rdddddrrrr    CPC  Rd,Rr
//      C_CPI    :  //  0011KKKKddddKKKK    CPI  Rd,K
//      C_CPSE   :  //  000100rdddddrrrr    CPSE Rd,Rr
//      C_SBRC   :  //  1111110rrrrr0bbb    SBRC Rr,b
//      C_SBRS   :  //  1111111rrrrr0bbb    SBRS Rr,b
//      C_SBIC   :  //  10011001AAAAAbbb    SBIC A,b
//      C_SBIS   :  //  10011011AAAAAbbb    SBIS A,b
//      C_BRBS   :  //  111100kkkkkkksss    BRBS s,k
//      C_BRBC   :  //  111101kkkkkkksss    BRBC s,k
//      //--------------------------------------------------
//      //  Data Transfer Instructions
//      //--------------------------------------------------
//      C_MOV    :  //  001011rdddddrrrr    MOV  Rd,Rr
//      C_MOVW   :  //  00000001ddddrrrr    MOVW Rd,Rr
//      C_LDI    :  //  1110KKKKddddKKKK    LDI  Rd,K
//      C_LDS    :  //  1001000ddddd0000    LDS  Rd,k
//      C_LDX    :  //  1001000ddddd1100    LD   Rd,X
//      C_LDXI   :  //  1001000ddddd1101    LD   Rd,X+
//      C_LDXD   :  //  1001000ddddd1110    LD   Rd,-X
//      C_LDYI   :  //  1001000ddddd1001    LD   Rd,Y+
//      C_LDYD   :  //  1001000ddddd1010    LD   Rd,-Y
//      C_LDDY   :  //  10q0qq0ddddd1qqq    LDD  Rd,Y+q
//      C_LDZI   :  //  1001000ddddd0001    LD   Rd,Z+
//      C_LDZD   :  //  1001000ddddd0010    LD   Rd,-Z
//      C_LDDZ   :  //  10q0qq0ddddd0qqq    LDD  Rd,Z+q
//      C_STS    :  //  1001001rrrrr0000    STS  k,Rr
//      C_STX    :  //  1001001rrrrr1100    ST   X,Rr
//      C_STXI   :  //  1001001rrrrr1101    ST   X+,Rr
//      C_STXD   :  //  1001001rrrrr1110    ST   -X,Rr
//      C_STYI   :  //  1001001rrrrr1001    ST   Y+,Rr
//      C_STYD   :  //  1001001rrrrr1010    ST   -Y,Rr
//      C_STDY   :  //  10q0qq1rrrrr1qqq    STD  Y+q,Rr
//      C_STZI   :  //  1001001rrrrr0001    ST   Z+,Rr
//      C_STZD   :  //  1001001rrrrr0010    ST   -Z,Rr
//      C_STDZ   :  //  10q0qq1rrrrr0qqq    STD  Z+q,Rr
//      C_LPM    :  //  1001010111001000    LPM
//      C_LPMZ   :  //  1001000ddddd0100    LPM  Rd,Z
//      C_LPMZI  :  //  1001000ddddd0101    LPM  Rd,Z+
//      C_SPM    :  //  1001010111101000    SPM
//      C_IN     :  //  10110AAdddddAAAA    IN   Rd,A
//      C_OUT    :  //  10111AArrrrrAAAA    OUT  A,Rr
//      C_PUSH   :  //  1001001rrrrr1111    PUSH Rr
//      C_POP    :  //  1001000ddddd1111    POP  Rd
//      //--------------------------------------------------
//      //  Bit and Bit-test Instructions
//      //--------------------------------------------------
//      C_ASR    :  //  1001010ddddd0101    ASR  Rd
//      C_LSR    :  //  1001010ddddd0110    LSR  Rd
//      C_ROR    :  //  1001010ddddd0111    ROR  Rd
//      C_SWAP   :  //  1001010ddddd0010    SWAP Rd
//      C_SBI    :  //  10011010AAAAAbbb    SBI  A,b
//      C_CBI    :  //  10011000AAAAAbbb    CBI  A,b
//      C_BST    :  //  1111101ddddd0bbb    BST  Rd,b
//      C_BLD    :  //  1111100ddddd0bbb    BLD  Rd,b
//      C_BSET   :  //  100101000sss1000    BSET s
//      C_BCLR   :  //  100101001sss1000    BCLR s
//      //--------------------------------------------------
//      //  MCU Control Instructions
//      //--------------------------------------------------
//      C_NOP    :  //  0000000000000000    NOP
//      default  :
//      endcase
//  end

//----------------------------------------------------------------------
//  RfRead: Register File Read Address Selector
//----------------------------------------------------------------------
module  RfRead (
    input       [15:0]  ir,         //  Instruction word
    input       [1:0]   cycle,      //  Cycle count
    output  reg         re_word,    //  Port A word read enable
    output  reg [4:0]   raddr_a,    //  Port A read address
    output  reg [4:0]   raddr_b     //  Port B read address
);

parameter   DC = 1'bx;  //  Don't care value

`include "OpDefine.v"
always @* begin
    casex (ir)
    //--------------------------------------------------
    //  Arithmetic and Logic Instructions
    //--------------------------------------------------
    C_ADD    ,  //  000011rdddddrrrr    ADD  Rd,Rr
    C_ADC    ,  //  000111rdddddrrrr    ADC  Rd,Rr
    C_SUB    ,  //  000110rdddddrrrr    SUB  Rd,Rr
    C_SBC    ,  //  000010rdddddrrrr    SBC  Rd,Rr
    C_AND    ,  //  001000rdddddrrrr    AND  Rd,Rr
    C_OR     ,  //  001010rdddddrrrr    OR   Rd,Rr
    C_EOR    ,  //  001001rdddddrrrr    EOR  Rd,Rr
    C_MUL    :  //  100111rdddddrrrr    MUL  Rd,Rr
                begin
                    re_word = 1'b0;
                    raddr_a = ir[8:4];
                    raddr_b = {ir[9], ir[3:0]};
                end
    C_SUBI   ,  //  0101KKKKddddKKKK    SUBI Rd,K
    C_SBCI   ,  //  0100KKKKddddKKKK    SBCI Rd,K
    C_ANDI   ,  //  0111KKKKddddKKKK    ANDI Rd,K
    C_ORI    :  //  0110KKKKddddKKKK    ORI  Rd,K
                begin
                    re_word = 1'b0;
                    raddr_a = {1'b1, ir[7:4]};
                    raddr_b = {5{DC}};
                end
    C_ADIW   ,  //  10010110KKddKKKK    ADIW Rd,K
    C_SBIW   :  //  10010111KKddKKKK    SBIW Rd,K
                begin
                    re_word = 1'b1;
                    raddr_a = {2'b11, ir[5:4], 1'b0};
                    raddr_b = {5{DC}};
                end
    C_COM    ,  //  1001010ddddd0000    COM  Rd
    C_NEG    :  //  1001010ddddd0001    NEG  Rd
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = ir[8:4];
                end
    C_INC    ,  //  1001010ddddd0011    INC  Rd
    C_DEC    :  //  1001010ddddd1010    DEC  Rd
                begin
                    re_word = 1'b0;
                    raddr_a = ir[8:4];
                    raddr_b = {5{DC}};
                end
    C_MULS   :  //  00000010ddddrrrr    MULS Rd,Rr
                begin
                    re_word = 1'b0;
                    raddr_a = {1'b1, ir[7:4]};
                    raddr_b = {1'b1, ir[3:0]};
                end
    C_MULSU  ,  //  000000110ddd0rrr    MULSU  Rd,Rr
    C_FMUL   ,  //  000000110ddd1rrr    FMUL   Rd,Rr
    C_FMULS  ,  //  000000111ddd0rrr    FMULS  Rd,Rr
    C_FMULSU :  //  000000111ddd1rrr    FMULSU Rd,Rr
                begin
                    re_word = 1'b0;
                    raddr_a = {2'b10, ir[6:4]};
                    raddr_b = {2'b10, ir[2:0]};
                end
    //--------------------------------------------------
    //  Branch Instructions
    //--------------------------------------------------
    C_JMP    ,  //  1001010kkkkk110k    JMP  k
    C_RJMP   ,  //  1100kkkkkkkkkkkk    RJMP k
    C_CALL   ,  //  1001010kkkkk111k    CALL k
    C_RCALL  ,  //  1101kkkkkkkkkkkk    RCALL k
    C_RET    ,  //  1001010100001000    RET
    C_RETI   :  //  1001010100011000    RETI
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {5{DC}};
                end
    C_IJMP   ,  //  1001010000001001    IJMP
    C_ICALL  :  //  1001010100001001    ICALL
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd30;
                    raddr_b = {5{DC}};
                end
    C_CP     ,  //  000101rdddddrrrr    CP   Rd,Rr
    C_CPC    ,  //  000001rdddddrrrr    CPC  Rd,Rr
    C_CPSE   :  //  000100rdddddrrrr    CPSE Rd,Rr
                begin
                    re_word = 1'b0;
                    raddr_a = ir[8:4];
                    raddr_b = {ir[9], ir[3:0]};
                end
    C_CPI    :  //  0011KKKKddddKKKK    CPI  Rd,K
                begin
                    re_word = 1'b0;
                    raddr_a = {1'b1, ir[7:4]};
                    raddr_b = {5{DC}};
                end
    C_SBRC   ,  //  1111110rrrrr0bbb    SBRC Rr,b
    C_SBRS   :  //  1111111rrrrr0bbb    SBRS Rr,b
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = ir[8:4];
                end
    C_SBIC   ,  //  10011001AAAAAbbb    SBIC A,b
    C_SBIS   ,  //  10011011AAAAAbbb    SBIS A,b
    C_BRBS   ,  //  111100kkkkkkksss    BRBS s,k
    C_BRBC   :  //  111101kkkkkkksss    BRBC s,k
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {5{DC}};
                end
    //--------------------------------------------------
    //  Data Transfer Instructions
    //--------------------------------------------------
    C_MOV    :  //  001011rdddddrrrr    MOV  Rd,Rr
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {ir[9], ir[3:0]};
                end
    C_MOVW   :  //  00000001ddddrrrr    MOVW Rd,Rr
                begin
                    re_word = 1'b1;
                    raddr_a = {ir[3:0], 1'b0};
                    raddr_b = {5{DC}};
                end
    C_LDI    ,  //  1110KKKKddddKKKK    LDI  Rd,K
    C_LDS    :  //  1001000ddddd0000    LDS  Rd,k
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {5{DC}};
                end
    C_LDX    ,  //  1001000ddddd1100    LD   Rd,X
    C_LDXI   ,  //  1001000ddddd1101    LD   Rd,X+
    C_LDXD   :  //  1001000ddddd1110    LD   Rd,-X
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd26;
                    raddr_b = {5{DC}};
                end
    C_LDYI   ,  //  1001000ddddd1001    LD   Rd,Y+
    C_LDYD   ,  //  1001000ddddd1010    LD   Rd,-Y
    C_LDDY   :  //  10q0qq0ddddd1qqq    LDD  Rd,Y+q
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd28;
                    raddr_b = {5{DC}};
                end
    C_LDZI   ,  //  1001000ddddd0001    LD   Rd,Z+
    C_LDZD   ,  //  1001000ddddd0010    LD   Rd,-Z
    C_LDDZ   :  //  10q0qq0ddddd0qqq    LDD  Rd,Z+q
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd30;
                    raddr_b = {5{DC}};
                end
    C_STS    :  //  1001001rrrrr0000    STS  k,Rr
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = ir[8:4];
                end
    C_STX    ,  //  1001001rrrrr1100    ST   X,Rr
    C_STXI   ,  //  1001001rrrrr1101    ST   X+,Rr
    C_STXD   :  //  1001001rrrrr1110    ST   -X,Rr
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd26;
                    raddr_b = ir[8:4];
                end
    C_STYI   ,  //  1001001rrrrr1001    ST   Y+,Rr
    C_STYD   ,  //  1001001rrrrr1010    ST   -Y,Rr
    C_STDY   :  //  10q0qq1rrrrr1qqq    STD  Y+q,Rr
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd28;
                    raddr_b = ir[8:4];
                end
    C_STZI   ,  //  1001001rrrrr0001    ST   Z+,Rr
    C_STZD   ,  //  1001001rrrrr0010    ST   -Z,Rr
    C_STDZ   :  //  10q0qq1rrrrr0qqq    STD  Z+q,Rr
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd30;
                    raddr_b = ir[8:4];
                end
    C_LPM    ,  //  1001010111001000    LPM
    C_LPMZ   ,  //  1001000ddddd0100    LPM  Rd,Z
    C_LPMZI  :  //  1001000ddddd0101    LPM  Rd,Z+
                begin
                    re_word = 1'b1;
                    raddr_a = 5'd30;
                    raddr_b = {5{DC}};
                end
    C_SPM    :  //  1001010111101000    SPM
                case (cycle)
                2'd0:
                    begin
                        re_word = 1'b1;
                        raddr_a = 5'd0;
                        raddr_b = {5{DC}};
                    end
                2'd1:
                    begin
                        re_word = 1'b1;
                        raddr_a = 5'd30;
                        raddr_b = {5{DC}};
                    end
                2'd2:
                    begin
                        re_word = DC;
                        raddr_a = {5{DC}};
                        raddr_b = {5{DC}};
                    end
                2'd3:
                    begin
                        re_word = DC;
                        raddr_a = {5{DC}};
                        raddr_b = {5{DC}};
                    end
                endcase
    C_IN     ,  //  10110AAdddddAAAA    IN   Rd,A
    C_POP    :  //  1001000ddddd1111    POP  Rd
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {5{DC}};
                end
    C_OUT    ,  //  10111AArrrrrAAAA    OUT  A,Rr
    C_PUSH   :  //  1001001rrrrr1111    PUSH Rr
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = ir[8:4];
                end
    //--------------------------------------------------
    //  Bit and Bit-test Instructions
    //--------------------------------------------------
    C_ASR    ,  //  1001010ddddd0101    ASR  Rd
    C_LSR    ,  //  1001010ddddd0110    LSR  Rd
    C_ROR    ,  //  1001010ddddd0111    ROR  Rd
    C_SWAP   :  //  1001010ddddd0010    SWAP Rd
                begin
                    re_word = 1'b0;
                    raddr_a = ir[8:4];
                    raddr_b = {5{DC}};
                end
    C_BST    ,  //  1111101ddddd0bbb    BST  Rd,b
    C_BLD    :  //  1111100ddddd0bbb    BLD  Rd,b
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = ir[8:4];
                end
    C_SBI    ,  //  10011010AAAAAbbb    SBI  A,b
    C_CBI    ,  //  10011000AAAAAbbb    CBI  A,b
    C_BSET   ,  //  100101000sss1000    BSET s
    C_BCLR   :  //  100101001sss1000    BCLR s
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {5{DC}};
                end
    //--------------------------------------------------
    //  MCU Control Instructions
    //--------------------------------------------------
    C_NOP    :  //  0000000000000000    NOP
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {5{DC}};
                end
    default  :
                begin
                    re_word = DC;
                    raddr_a = {5{DC}};
                    raddr_b = {5{DC}};
                end
    endcase
end

endmodule

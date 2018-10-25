//----------------------------------------------------------------------
//  RfWrite: Register File Write Address/Data Selector
//----------------------------------------------------------------------
module  RfWrite (
    input       [15:0]  ir,             //  Instruction word
    input       [1:0]   cycle,          //  Cycle count
    input       [15:0]  alu_ro,         //  ALU result
    input       [15:0]  mul_ro,         //  Multiplication result
    input       [7:0]   bsc_ro,         //  Bit set/clear result
    input       [7:0]   mm_rdata,       //  Data memory space read data
    input               mm_rdata_en,    //  Data memory space read data enable
    input       [7:0]   lpm_data,       //  LPM instruction load data
    input               lpm_data_en,    //  LPM instruction load data enable
    input               tim_rf_we,      //  Timing of register file write
    output  reg [4:0]   waddr,          //  Register file write address
    output      [15:0]  wdata,          //  Register file write data
    output              we_byte,        //  Register file byte write enable
    output              we_word         //  Register file word write enable
);

parameter   DC = 1'bx;  //  Don't care value
reg         word_op;

assign  wdata = (mm_rdata_en | lpm_data_en)
                ? ({8'h00, mm_rdata} | {8'h00, lpm_data})
                : (alu_ro | mul_ro | {8'h00, bsc_ro});

assign  we_byte = tim_rf_we & ~word_op;
assign  we_word = tim_rf_we &  word_op;

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
    C_EOR    :  //  001001rdddddrrrr    EOR  Rd,Rr
                begin
                    word_op = 1'b0;
                    waddr   = ir[8:4];
                end
    C_SUBI   ,  //  0101KKKKddddKKKK    SUBI Rd,K
    C_SBCI   ,  //  0100KKKKddddKKKK    SBCI Rd,K
    C_ANDI   ,  //  0111KKKKddddKKKK    ANDI Rd,K
    C_ORI    :  //  0110KKKKddddKKKK    ORI  Rd,K
                begin
                    word_op = 1'b0;
                    waddr   = {1'b1, ir[7:4]};
                end
    C_ADIW   ,  //  10010110KKddKKKK    ADIW Rd,K
    C_SBIW   :  //  10010111KKddKKKK    SBIW Rd,K
                begin
                    word_op = 1'b1;
                    waddr   = {2'b11, ir[5:4], 1'b0};
                end
    C_COM    ,  //  1001010ddddd0000    COM  Rd
    C_NEG    ,  //  1001010ddddd0001    NEG  Rd
    C_INC    ,  //  1001010ddddd0011    INC  Rd
    C_DEC    :  //  1001010ddddd1010    DEC  Rd
                begin
                    word_op = 1'b0;
                    waddr   = ir[8:4];
                end
    C_MUL    ,  //  100111rdddddrrrr    MUL  Rd,Rr
    C_MULS   ,  //  00000010ddddrrrr    MULS Rd,Rr
    C_MULSU  ,  //  000000110ddd0rrr    MULSU  Rd,Rr
    C_FMUL   ,  //  000000110ddd1rrr    FMUL   Rd,Rr
    C_FMULS  ,  //  000000111ddd0rrr    FMULS  Rd,Rr
    C_FMULSU :  //  000000111ddd1rrr    FMULSU Rd,Rr
                begin
                    word_op = 1'b1;
                    waddr   = 5'd0;
                end
    //--------------------------------------------------
    //  Branch Instructions
    //--------------------------------------------------
    C_JMP    ,  //  1001010kkkkk110k    JMP  k
    C_RJMP   ,  //  1100kkkkkkkkkkkk    RJMP k
    C_IJMP   ,  //  1001010000001001    IJMP
    C_CALL   ,  //  1001010kkkkk111k    CALL k
    C_RCALL  ,  //  1101kkkkkkkkkkkk    RCALL k
    C_ICALL  ,  //  1001010100001001    ICALL
    C_RET    ,  //  1001010100001000    RET
    C_RETI   ,  //  1001010100011000    RETI
    C_CP     ,  //  000101rdddddrrrr    CP   Rd,Rr
    C_CPC    ,  //  000001rdddddrrrr    CPC  Rd,Rr
    C_CPI    ,  //  0011KKKKddddKKKK    CPI  Rd,K
    C_CPSE   ,  //  000100rdddddrrrr    CPSE Rd,Rr
    C_SBRC   ,  //  1111110rrrrr0bbb    SBRC Rr,b
    C_SBRS   ,  //  1111111rrrrr0bbb    SBRS Rr,b
    C_SBIC   ,  //  10011001AAAAAbbb    SBIC A,b
    C_SBIS   ,  //  10011011AAAAAbbb    SBIS A,b
    C_BRBS   ,  //  111100kkkkkkksss    BRBS s,k
    C_BRBC   :  //  111101kkkkkkksss    BRBC s,k
                begin
                    word_op = DC;
                    waddr   = {5{DC}};
                end
    //--------------------------------------------------
    //  Data Transfer Instructions
    //--------------------------------------------------
    C_MOV    :  //  001011rdddddrrrr    MOV  Rd,Rr
                begin
                    word_op = 1'b0;
                    waddr   = ir[8:4];
                end
    C_MOVW   :  //  00000001ddddrrrr    MOVW Rd,Rr
                begin
                    word_op = 1'b1;
                    waddr   = {ir[7:4], 1'b0};
                end
    C_LDI    :  //  1110KKKKddddKKKK    LDI  Rd,K
                begin
                    word_op = 1'b0;
                    waddr   = {1'b1, ir[7:4]};
                end
    C_LDS    ,  //  1001000ddddd0000    LDS  Rd,k
    C_LDX    ,  //  1001000ddddd1100    LD   Rd,X
    C_LDDY   ,  //  10q0qq0ddddd1qqq    LDD  Rd,Y+q
    C_LDDZ   ,  //  10q0qq0ddddd0qqq    LDD  Rd,Z+q
    C_LPMZ   ,  //  1001000ddddd0100    LPM  Rd,Z
    C_IN     ,  //  10110AAdddddAAAA    IN   Rd,A
    C_POP    :  //  1001000ddddd1111    POP  Rd
                begin
                    word_op = 1'b0;
                    waddr   = ir[8:4];
                end
    C_LDXI   ,  //  1001000ddddd1101    LD   Rd,X+
    C_LDXD   :  //  1001000ddddd1110    LD   Rd,-X
                case (cycle)
                2'd0:
                    begin
                        word_op = 1'b1;
                        waddr   = 5'd26;
                    end
                2'd1:
                    begin
                        word_op = 1'b0;
                        waddr   = ir[8:4];
                    end
                default:
                    begin
                        word_op = DC;
                        waddr   = {5{DC}};
                    end
                endcase
    C_LDYI   ,  //  1001000ddddd1001    LD   Rd,Y+
    C_LDYD   :  //  1001000ddddd1010    LD   Rd,-Y
                case (cycle)
                2'd0:
                    begin
                        word_op = 1'b1;
                        waddr   = 5'd28;
                    end
                2'd1:
                    begin
                        word_op = 1'b0;
                        waddr   = ir[8:4];
                    end
                default:
                    begin
                        word_op = DC;
                        waddr   = {5{DC}};
                    end
                endcase
    C_LDZI   ,  //  1001000ddddd0001    LD   Rd,Z+
    C_LDZD   ,  //  1001000ddddd0010    LD   Rd,-Z
    C_LPMZI  :  //  1001000ddddd0101    LPM  Rd,Z+
                case (cycle)
                2'd0:
                    begin
                        word_op = 1'b1;
                        waddr   = 5'd30;
                    end
                2'd1:
                    begin
                        word_op = 1'b0;
                        waddr   = ir[8:4];
                    end
                default:
                    begin
                        word_op = DC;
                        waddr   = {5{DC}};
                    end
                endcase
    C_STS    ,  //  1001001rrrrr0000    STS  k,Rr
    C_STX    ,  //  1001001rrrrr1100    ST   X,Rr
    C_STDY   ,  //  10q0qq1rrrrr1qqq    STD  Y+q,Rr
    C_STDZ   ,  //  10q0qq1rrrrr0qqq    STD  Z+q,Rr
    C_SPM    ,  //  1001010111101000    SPM
    C_OUT    ,  //  10111AArrrrrAAAA    OUT  A,Rr
    C_PUSH   :  //  1001001rrrrr1111    PUSH Rr
                begin
                    word_op = DC;
                    waddr   = {5{DC}};
                end
    C_STXI   ,  //  1001001rrrrr1101    ST   X+,Rr
    C_STXD   :  //  1001001rrrrr1110    ST   -X,Rr
                begin
                    word_op = 1'b1;
                    waddr   = 5'd26;
                end
    C_STYI   ,  //  1001001rrrrr1001    ST   Y+,Rr
    C_STYD   :  //  1001001rrrrr1010    ST   -Y,Rr
                begin
                    word_op = 1'b1;
                    waddr   = 5'd28;
                end
    C_STZI   ,  //  1001001rrrrr0001    ST   Z+,Rr
    C_STZD   :  //  1001001rrrrr0010    ST   -Z,Rr
                begin
                    word_op = 1'b1;
                    waddr   = 5'd30;
                end
    C_LPM    :  //  1001010111001000    LPM
                begin
                    word_op = 1'b0;
                    waddr   = 5'd0;
                end
    //--------------------------------------------------
    //  Bit and Bit-test Instructions
    //--------------------------------------------------
    C_ASR    ,  //  1001010ddddd0101    ASR  Rd
    C_LSR    ,  //  1001010ddddd0110    LSR  Rd
    C_ROR    ,  //  1001010ddddd0111    ROR  Rd
    C_SWAP   ,  //  1001010ddddd0010    SWAP Rd
    C_BLD    :  //  1111100ddddd0bbb    BLD  Rd,b
                begin
                    word_op = 1'b0;
                    waddr   = ir[8:4];
                end
    C_SBI    ,  //  10011010AAAAAbbb    SBI  A,b
    C_CBI    ,  //  10011000AAAAAbbb    CBI  A,b
    C_BST    ,  //  1111101ddddd0bbb    BST  Rd,b
    C_BSET   ,  //  100101000sss1000    BSET s
    C_BCLR   :  //  100101001sss1000    BCLR s
                begin
                    word_op = DC;
                    waddr   = {5{DC}};
                end
    //--------------------------------------------------
    //  MCU Control Instructions
    //--------------------------------------------------
    C_NOP    :  //  0000000000000000    NOP
                begin
                    word_op = DC;
                    waddr   = {5{DC}};
                end
    default  :
                begin
                    word_op = DC;
                    waddr   = {5{DC}};
                end
    endcase
end

endmodule

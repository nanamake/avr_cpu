//----------------------------------------------------------------------
//  AluInput: ALU Input Selector
//----------------------------------------------------------------------
module  AluInput (
    input       [15:0]  ir,         //  Instruction word
    input       [15:0]  rf_rdata_a, //  Register file Port A data
    input       [7:0]   rf_rdata_b, //  Register file Port B data
    input               sr_cf,      //  Carry flag in status register
    input       [15:0]  pc,         //  Program counter
    input       [15:0]  ir_2nd,     //  Instruction 2nd word
    output  reg [15:0]  alu_ai,     //  Operand A
    output  reg [15:0]  alu_bi,     //  Operand B
    output  reg         alu_ci,     //  Carry input
    output  reg         sel_adc_b,  //  Operation ADC(8-bit) enable
    output  reg         sel_sbc_b,  //  Operation SBC(8-bit) enable
    output  reg         sel_adc_w,  //  Operation ADC(16-bit) enable
    output  reg         sel_sbc_w,  //  Operation SBC(16-bit) enable
    output  reg         sel_and,    //  Operation AND enable
    output  reg         sel_or,     //  Operation OR enable
    output  reg         sel_eor,    //  Operation EOR enable
    output  reg         sel_asr,    //  Operation ASR enable
    output  reg         sel_lsr,    //  Operation LSR enable
    output  reg         sel_ror,    //  Operation ROR enable
    output  reg         sel_swap,   //  Operation SWAP enable
    output  reg         sel_mul,    //  Operation MUL enable
    output  reg         sel_muls,   //  Operation MULS enable
    output  reg         sel_mulsu,  //  Operation MULSU enable
    output  reg         sel_fmul,   //  Operation FMUL enable
    output  reg         sel_fmuls,  //  Operation FMULS enable
    output  reg         sel_fmulsu  //  Operation FMULSU enable
);

//----------------------------------------------------------------------
//  Operands and Carry Input Selection
//----------------------------------------------------------------------
parameter   DC = 1'bx;  //  Don't care value

`include "OpDefine.v"
always @* begin
    casex (ir)
    //--------------------------------------------------
    //  Arithmetic and Logic Instructions
    //--------------------------------------------------
    C_ADD    ,  //  000011rdddddrrrr    ADD  Rd,Rr
    C_SUB    :  //  000110rdddddrrrr    SUB  Rd,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = 1'b0;
                end
    C_ADC    ,  //  000111rdddddrrrr    ADC  Rd,Rr
    C_SBC    :  //  000010rdddddrrrr    SBC  Rd,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = sr_cf;
                end
    C_SUBI   :  //  0101KKKKddddKKKK    SUBI Rd,K
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, ir[11:8], ir[3:0]};
                    alu_ci = 1'b0;
                end
    C_SBCI   :  //  0100KKKKddddKKKK    SBCI Rd,K
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, ir[11:8], ir[3:0]};
                    alu_ci = sr_cf;
                end
    C_ADIW   ,  //  10010110KKddKKKK    ADIW Rd,K
    C_SBIW   :  //  10010111KKddKKKK    SBIW Rd,K
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {10'h000, ir[7:6], ir[3:0]};
                    alu_ci = 1'b0;
                end
    C_AND    ,  //  001000rdddddrrrr    AND  Rd,Rr
    C_OR     ,  //  001010rdddddrrrr    OR   Rd,Rr
    C_EOR    :  //  001001rdddddrrrr    EOR  Rd,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = DC;
                end
    C_ANDI   ,  //  0111KKKKddddKKKK    ANDI Rd,K
    C_ORI    :  //  0110KKKKddddKKKK    ORI  Rd,K
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, ir[11:8], ir[3:0]};
                    alu_ci = DC;
                end
    C_COM    :  //  1001010ddddd0000    COM  Rd
                begin
                    alu_ai = 16'h0000;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = 1'b1;
                end
    C_NEG    :  //  1001010ddddd0001    NEG  Rd
                begin
                    alu_ai = 16'h0000;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = 1'b0;
                end
    C_INC    ,  //  1001010ddddd0011    INC  Rd
    C_DEC    :  //  1001010ddddd1010    DEC  Rd
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = 16'h0000;
                    alu_ci = 1'b1;
                end
    C_MUL    ,  //  100111rdddddrrrr    MUL  Rd,Rr
    C_MULS   ,  //  00000010ddddrrrr    MULS Rd,Rr
    C_MULSU  ,  //  000000110ddd0rrr    MULSU  Rd,Rr
    C_FMUL   ,  //  000000110ddd1rrr    FMUL   Rd,Rr
    C_FMULS  ,  //  000000111ddd0rrr    FMULS  Rd,Rr
    C_FMULSU :  //  000000111ddd1rrr    FMULSU Rd,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = DC;
                end
    //--------------------------------------------------
    //  Branch Instructions
    //--------------------------------------------------
    C_JMP    ,  //  1001010kkkkk110k    JMP  k
    C_CALL   :  //  1001010kkkkk111k    CALL k
                begin
                    alu_ai = ir_2nd;
                    alu_bi = 16'h0000;
                    alu_ci = 1'b0;
                end
    C_RJMP   ,  //  1100kkkkkkkkkkkk    RJMP k
    C_RCALL  :  //  1101kkkkkkkkkkkk    RCALL k
                begin
                    alu_ai = pc;
                    alu_bi = {{4{ir[11]}}, ir[11:0]};
                    alu_ci = 1'b0;
                end
    C_IJMP   ,  //  1001010000001001    IJMP
    C_ICALL  :  //  1001010100001001    ICALL
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = 16'h0000;
                    alu_ci = 1'b0;
                end
    C_BRBS   ,  //  111100kkkkkkksss    BRBS s,k
    C_BRBC   :  //  111101kkkkkkksss    BRBC s,k
                begin
                    alu_ai = pc;
                    alu_bi = {{9{ir[9]}}, ir[9:3]};
                    alu_ci = 1'b0;
                end
    C_CP     ,  //  000101rdddddrrrr    CP   Rd,Rr
    C_CPSE   :  //  000100rdddddrrrr    CPSE Rd,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = 1'b0;
                end
    C_CPC    :  //  000001rdddddrrrr    CPC  Rd,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = sr_cf;
                end
    C_CPI    :  //  0011KKKKddddKKKK    CPI  Rd,K
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {8'h00, ir[11:8], ir[3:0]};
                    alu_ci = 1'b0;
                end
    C_RET    ,  //  1001010100001000    RET
    C_RETI   ,  //  1001010100011000    RETI
    C_SBRC   ,  //  1111110rrrrr0bbb    SBRC Rr,b
    C_SBRS   ,  //  1111111rrrrr0bbb    SBRS Rr,b
    C_SBIC   ,  //  10011001AAAAAbbb    SBIC A,b
    C_SBIS   :  //  10011011AAAAAbbb    SBIS A,b
                begin
                    alu_ai = {16{DC}};
                    alu_bi = {16{DC}};
                    alu_ci = DC;
                end
    //--------------------------------------------------
    //  Data Transfer Instructions
    //--------------------------------------------------
    C_MOV    :  //  001011rdddddrrrr    MOV  Rd,Rr
                begin
                    alu_ai = 16'h0000;
                    alu_bi = {8'h00, rf_rdata_b};
                    alu_ci = DC;
                end
    C_MOVW   :  //  00000001ddddrrrr    MOVW Rd,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = 16'h0000;
                    alu_ci = 1'b0;
                end
    C_LDI    :  //  1110KKKKddddKKKK    LDI  Rd,K
                begin
                    alu_ai = 16'h0000;
                    alu_bi = {8'h00, ir[11:8], ir[3:0]};
                    alu_ci = DC;
                end
    C_LDS    ,  //  1001000ddddd0000    LDS  Rd,k
    C_STS    :  //  1001001rrrrr0000    STS  k,Rr
                begin
                    alu_ai = ir_2nd;
                    alu_bi = 16'h0000;
                    alu_ci = 1'b0;
                end
    C_LDX    ,  //  1001000ddddd1100    LD   Rd,X
    C_STX    :  //  1001001rrrrr1100    ST   X,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = 16'h0000;
                    alu_ci = 1'b0;
                end
    C_LDXI   ,  //  1001000ddddd1101    LD   Rd,X+
    C_LDXD   ,  //  1001000ddddd1110    LD   Rd,-X
    C_LDYI   ,  //  1001000ddddd1001    LD   Rd,Y+
    C_LDYD   ,  //  1001000ddddd1010    LD   Rd,-Y
    C_LDZI   ,  //  1001000ddddd0001    LD   Rd,Z+
    C_LDZD   ,  //  1001000ddddd0010    LD   Rd,-Z
    C_STXI   ,  //  1001001rrrrr1101    ST   X+,Rr
    C_STXD   ,  //  1001001rrrrr1110    ST   -X,Rr
    C_STYI   ,  //  1001001rrrrr1001    ST   Y+,Rr
    C_STYD   ,  //  1001001rrrrr1010    ST   -Y,Rr
    C_STZI   ,  //  1001001rrrrr0001    ST   Z+,Rr
    C_STZD   ,  //  1001001rrrrr0010    ST   -Z,Rr
    C_LPMZI  :  //  1001000ddddd0101    LPM  Rd,Z+
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = 16'h0000;
                    alu_ci = 1'b1;
                end
    C_LDDY   ,  //  10q0qq0ddddd1qqq    LDD  Rd,Y+q
    C_LDDZ   ,  //  10q0qq0ddddd0qqq    LDD  Rd,Z+q
    C_STDY   ,  //  10q0qq1rrrrr1qqq    STD  Y+q,Rr
    C_STDZ   :  //  10q0qq1rrrrr0qqq    STD  Z+q,Rr
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {10'h000, ir[13], ir[11:10], ir[2:0]};
                    alu_ci = 1'b0;
                end
    C_LPM    ,  //  1001010111001000    LPM
    C_LPMZ   ,  //  1001000ddddd0100    LPM  Rd,Z
    C_SPM    ,  //  1001010111101000    SPM
    C_IN     ,  //  10110AAdddddAAAA    IN   Rd,A
    C_OUT    ,  //  10111AArrrrrAAAA    OUT  A,Rr
    C_PUSH   ,  //  1001001rrrrr1111    PUSH Rr
    C_POP    :  //  1001000ddddd1111    POP  Rd
                begin
                    alu_ai = {16{DC}};
                    alu_bi = {16{DC}};
                    alu_ci = DC;
                end
    //--------------------------------------------------
    //  Bit and Bit-test Instructions
    //--------------------------------------------------
    C_ASR    ,  //  1001010ddddd0101    ASR  Rd
    C_LSR    ,  //  1001010ddddd0110    LSR  Rd
    C_SWAP   :  //  1001010ddddd0010    SWAP Rd
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {16{DC}};
                    alu_ci = DC;
                end
    C_ROR    :  //  1001010ddddd0111    ROR  Rd
                begin
                    alu_ai = rf_rdata_a;
                    alu_bi = {16{DC}};
                    alu_ci = sr_cf;
                end
    C_SBI    ,  //  10011010AAAAAbbb    SBI  A,b
    C_CBI    ,  //  10011000AAAAAbbb    CBI  A,b
    C_BST    ,  //  1111101ddddd0bbb    BST  Rd,b
    C_BLD    ,  //  1111100ddddd0bbb    BLD  Rd,b
    C_BSET   ,  //  100101000sss1000    BSET s
    C_BCLR   :  //  100101001sss1000    BCLR s
                begin
                    alu_ai = {16{DC}};
                    alu_bi = {16{DC}};
                    alu_ci = DC;
                end
    //--------------------------------------------------
    //  MCU Control Instructions
    //--------------------------------------------------
    C_NOP    :  //  0000000000000000    NOP
                begin
                    alu_ai = {16{DC}};
                    alu_bi = {16{DC}};
                    alu_ci = DC;
                end
    default  :
                begin
                    alu_ai = {16{DC}};
                    alu_bi = {16{DC}};
                    alu_ci = DC;
                end
    endcase
end

//----------------------------------------------------------------------
//  Operation Enable Selection
//----------------------------------------------------------------------
always @* begin
    sel_adc_b = 1'b0;   //  Operation ADC(8-bit) enable
    sel_sbc_b = 1'b0;   //  Operation SBC(8-bit) enable
    sel_adc_w = 1'b0;   //  Operation ADC(16-bit) enable
    sel_sbc_w = 1'b0;   //  Operation SBC(16-bit) enable
    sel_and   = 1'b0;   //  Operation AND enable
    sel_or    = 1'b0;   //  Operation OR enable
    sel_eor   = 1'b0;   //  Operation EOR enable
    sel_asr   = 1'b0;   //  Operation ASR enable
    sel_lsr   = 1'b0;   //  Operation LSR enable
    sel_ror   = 1'b0;   //  Operation ROR enable
    sel_swap  = 1'b0;   //  Operation SWAP enable
    sel_mul    = 1'b0;  //  Operation MUL enable
    sel_muls   = 1'b0;  //  Operation MULS enable
    sel_mulsu  = 1'b0;  //  Operation MULSU enable
    sel_fmul   = 1'b0;  //  Operation FMUL enable
    sel_fmuls  = 1'b0;  //  Operation FMULS enable
    sel_fmulsu = 1'b0;  //  Operation FMULSU enable
    casex (ir)
    //--------------------------------------------------
    //  Arithmetic and Logic Instructions
    //--------------------------------------------------
    C_ADD    ,  //  ADD  Rd,Rr
    C_ADC    ,  //  ADC  Rd,Rr
    C_INC    :  //  INC  Rd
                sel_adc_b = 1'b1;
    C_SUB    ,  //  SUB  Rd,Rr
    C_SUBI   ,  //  SUBI Rd,K
    C_SBC    ,  //  SBC  Rd,Rr
    C_SBCI   ,  //  SBCI Rd,K
    C_COM    ,  //  COM  Rd
    C_NEG    ,  //  NEG  Rd
    C_DEC    :  //  DEC  Rd
                sel_sbc_b = 1'b1;
    C_ADIW   :  //  ADIW Rd,K
                sel_adc_w = 1'b1;
    C_SBIW   :  //  SBIW Rd,K
                sel_sbc_w = 1'b1;
    C_AND    ,  //  AND  Rd,Rr
    C_ANDI   :  //  ANDI Rd,K
                sel_and  = 1'b1;
    C_OR     ,  //  OR   Rd,Rr
    C_ORI    :  //  ORI  Rd,K
                sel_or   = 1'b1;
    C_EOR    :  //  EOR  Rd,Rr
                sel_eor  = 1'b1;
    C_MUL    :  //  MUL  Rd,Rr
                sel_mul  = 1'b1;
    C_MULS   :  //  MULS Rd,Rr
                sel_muls = 1'b1;
    C_MULSU  :  //  MULSU  Rd,Rr
                sel_mulsu  = 1'b1;
    C_FMUL   :  //  FMUL   Rd,Rr
                sel_fmul   = 1'b1;
    C_FMULS  :  //  FMULS  Rd,Rr
                sel_fmuls  = 1'b1;
    C_FMULSU :  //  FMULSU Rd,Rr
                sel_fmulsu = 1'b1;
    //--------------------------------------------------
    //  Branch Instructions
    //--------------------------------------------------
    C_JMP    ,  //  JMP  k
    C_RJMP   ,  //  RJMP k
    C_IJMP   ,  //  IJMP
    C_CALL   ,  //  CALL k
    C_RCALL  ,  //  RCALL k
    C_ICALL  ,  //  ICALL
    C_BRBS   ,  //  BRBS s,k
    C_BRBC   :  //  BRBC s,k
                sel_adc_w = 1'b1;
    C_CP     ,  //  CP   Rd,Rr
    C_CPC    ,  //  CPC  Rd,Rr
    C_CPI    ,  //  CPI  Rd,K
    C_CPSE   :  //  CPSE Rd,Rr
                sel_sbc_b = 1'b1;
    C_RET    ,  //  RET
    C_RETI   ,  //  RETI
    C_SBRC   ,  //  SBRC Rr,b
    C_SBRS   ,  //  SBRS Rr,b
    C_SBIC   ,  //  SBIC A,b
    C_SBIS   :  //  SBIS A,b
                ;
    //--------------------------------------------------
    //  Data Transfer Instructions
    //--------------------------------------------------
    C_MOV    ,  //  MOV  Rd,Rr
    C_LDI    :  //  LDI  Rd,K
                sel_or   = 1'b1;
    C_MOVW   ,  //  MOVW Rd,Rr
    C_LDS    ,  //  LDS  Rd,k
    C_LDX    ,  //  LD   Rd,X
    C_LDXI   ,  //  LD   Rd,X+
    C_LDYI   ,  //  LD   Rd,Y+
    C_LDDY   ,  //  LDD  Rd,Y+q
    C_LDZI   ,  //  LD   Rd,Z+
    C_LDDZ   ,  //  LDD  Rd,Z+q
    C_STS    ,  //  STS  k,Rr
    C_STX    ,  //  ST   X,Rr
    C_STXI   ,  //  ST   X+,Rr
    C_STYI   ,  //  ST   Y+,Rr
    C_STDY   ,  //  STD  Y+q,Rr
    C_STZI   ,  //  ST   Z+,Rr
    C_STDZ   ,  //  STD  Z+q,Rr
    C_LPMZI  ,  //  LPM  Rd,Z+
    C_POP    :  //  POP  Rd
                sel_adc_w = 1'b1;
    C_LDXD   ,  //  LD   Rd,-X
    C_LDYD   ,  //  LD   Rd,-Y
    C_LDZD   ,  //  LD   Rd,-Z
    C_STXD   ,  //  ST   -X,Rr
    C_STYD   ,  //  ST   -Y,Rr
    C_STZD   ,  //  ST   -Z,Rr
    C_PUSH   :  //  PUSH Rr
                sel_sbc_w = 1'b1;
    C_LPM    ,  //  LPM
    C_LPMZ   ,  //  LPM  Rd,Z
    C_SPM    ,  //  SPM
    C_IN     ,  //  IN   Rd,A
    C_OUT    :  //  OUT  A,Rr
                ;
    //--------------------------------------------------
    //  Bit and Bit-test Instructions
    //--------------------------------------------------
    C_ASR    :  //  ASR  Rd
                sel_asr  = 1'b1;
    C_LSR    :  //  LSR  Rd
                sel_lsr  = 1'b1;
    C_ROR    :  //  ROR  Rd
                sel_ror  = 1'b1;
    C_SWAP   :  //  SWAP Rd
                sel_swap = 1'b1;
    C_SBI    ,  //  SBI  A,b
    C_CBI    ,  //  CBI  A,b
    C_BST    ,  //  BST  Rd,b
    C_BLD    ,  //  BLD  Rd,b
    C_BSET   ,  //  BSET s
    C_BCLR   :  //  BCLR s
                ;
    //--------------------------------------------------
    //  MCU Control Instructions
    //--------------------------------------------------
    C_NOP    :  //  NOP
                ;
    default  :
                ;
    endcase
end

endmodule

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
    output  reg         sel_eor     //  Operation EOR enable
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
    C_MUL    ,  //  MUL  Rd,Rr
    C_MULS   ,  //  MULS Rd,Rr
    C_MULSU  ,  //  MULSU  Rd,Rr
    C_FMUL   ,  //  FMUL   Rd,Rr
    C_FMULS  ,  //  FMULS  Rd,Rr
    C_FMULSU :  //  FMULSU Rd,Rr
                ;
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
    C_MOVW   :  //  MOVW Rd,Rr
                sel_adc_w = 1'b1;
    default  :
                ;
    endcase
end

endmodule

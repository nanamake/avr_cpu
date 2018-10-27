//----------------------------------------------------------------------
//  PtrCalc: Memory Pointer Calculation
//----------------------------------------------------------------------
module  PtrCalc (
    input       [15:0]  ir,         //  Instruction word
    input       [15:0]  ir_2nd,     //  Instruction 2nd word
    input       [15:0]  sp,         //  Stack pointer
    input       [15:0]  rf_rdata_a, //  Register file Port A data
    output  reg [15:0]  ptr_ai,     //  Pointer pre-calculation value
    output      [15:0]  ptr_ro      //  Pointer calculation result
);

reg [15:0]  ptr_bi;

assign  ptr_ro = ptr_ai + ptr_bi;

`include "OpDefine.v"
always @* begin
    casex (ir)
    //--------------------------------------------------
    //  Branch Instructions
    //--------------------------------------------------
    C_CALL   ,  //  1001010kkkkk111k    CALL k
    C_RCALL  ,  //  1101kkkkkkkkkkkk    RCALL k
    C_ICALL  :  //  1001010100001001    ICALL
                begin
                    ptr_ai = sp;
                    ptr_bi = 16'hffff;
                end
    C_RET    ,  //  1001010100001000    RET
    C_RETI   :  //  1001010100011000    RETI
                begin
                    ptr_ai = sp;
                    ptr_bi = 16'h0001;
                end
    //--------------------------------------------------
    //  Data Transfer Instructions
    //--------------------------------------------------
    C_LDS    ,  //  1001000ddddd0000    LDS  Rd,k
    C_STS    :  //  1001001rrrrr0000    STS  k,Rr
                begin
                    ptr_ai = 16'h0000;
                    ptr_bi = ir_2nd;
                end
    C_LDX    ,  //  1001000ddddd1100    LD   Rd,X
    C_STX    :  //  1001001rrrrr1100    ST   X,Rr
                begin
                    ptr_ai = rf_rdata_a;
                    ptr_bi = 16'h0000;
                end
    C_LDXI   ,  //  1001000ddddd1101    LD   Rd,X+
    C_LDYI   ,  //  1001000ddddd1001    LD   Rd,Y+
    C_LDZI   ,  //  1001000ddddd0001    LD   Rd,Z+
    C_STXI   ,  //  1001001rrrrr1101    ST   X+,Rr
    C_STYI   ,  //  1001001rrrrr1001    ST   Y+,Rr
    C_STZI   ,  //  1001001rrrrr0001    ST   Z+,Rr
    C_LPMZI  :  //  1001000ddddd0101    LPM  Rd,Z+
                begin
                    ptr_ai = rf_rdata_a;
                    ptr_bi = 16'h0001;
                end
    C_LDXD   ,  //  1001000ddddd1110    LD   Rd,-X
    C_LDYD   ,  //  1001000ddddd1010    LD   Rd,-Y
    C_LDZD   ,  //  1001000ddddd0010    LD   Rd,-Z
    C_STXD   ,  //  1001001rrrrr1110    ST   -X,Rr
    C_STYD   ,  //  1001001rrrrr1010    ST   -Y,Rr
    C_STZD   :  //  1001001rrrrr0010    ST   -Z,Rr
                begin
                    ptr_ai = rf_rdata_a;
                    ptr_bi = 16'hffff;
                end
    C_LDDY   ,  //  10q0qq0ddddd1qqq    LDD  Rd,Y+q
    C_LDDZ   ,  //  10q0qq0ddddd0qqq    LDD  Rd,Z+q
    C_STDY   ,  //  10q0qq1rrrrr1qqq    STD  Y+q,Rr
    C_STDZ   :  //  10q0qq1rrrrr0qqq    STD  Z+q,Rr
                begin
                    ptr_ai = rf_rdata_a;
                    ptr_bi = {10'h000, ir[13], ir[11:10], ir[2:0]};
                end
    C_PUSH   :  //  1001001rrrrr1111    PUSH Rr
                begin
                    ptr_ai = sp;
                    ptr_bi = 16'hffff;
                end
    C_POP    :  //  1001000ddddd1111    POP  Rd
                begin
                    ptr_ai = sp;
                    ptr_bi = 16'h0001;
                end
    default  :
                begin
                    ptr_ai = 16'h0000;
                    ptr_bi = 16'h0000;
                end
    endcase
end

endmodule

//----------------------------------------------------------------------
//  OpDecode: Decode Opcodes
//----------------------------------------------------------------------
module  OpDecode (
    input       [15:0]  ir,         //  Instruction word
    output  reg [0:82]  op_decode   //  Decoded opcodes
);
`include "OpDefine.v"
`include "OpNumber.v"
always @* begin
    op_decode = {83{1'b0}};
    casex (ir)
    C_ADD    :  op_decode[B_ADD   ] = 1'b1;
    C_ADC    :  op_decode[B_ADC   ] = 1'b1;
    C_ADIW   :  op_decode[B_ADIW  ] = 1'b1;
    C_SUB    :  op_decode[B_SUB   ] = 1'b1;
    C_SUBI   :  op_decode[B_SUBI  ] = 1'b1;
    C_SBC    :  op_decode[B_SBC   ] = 1'b1;
    C_SBCI   :  op_decode[B_SBCI  ] = 1'b1;
    C_SBIW   :  op_decode[B_SBIW  ] = 1'b1;
    C_AND    :  op_decode[B_AND   ] = 1'b1;
    C_ANDI   :  op_decode[B_ANDI  ] = 1'b1;
    C_OR     :  op_decode[B_OR    ] = 1'b1;
    C_ORI    :  op_decode[B_ORI   ] = 1'b1;
    C_EOR    :  op_decode[B_EOR   ] = 1'b1;
    C_COM    :  op_decode[B_COM   ] = 1'b1;
    C_NEG    :  op_decode[B_NEG   ] = 1'b1;
    C_INC    :  op_decode[B_INC   ] = 1'b1;
    C_DEC    :  op_decode[B_DEC   ] = 1'b1;
    C_MUL    :  op_decode[B_MUL   ] = 1'b1;
    C_MULS   :  op_decode[B_MULS  ] = 1'b1;
    C_MULSU  :  op_decode[B_MULSU ] = 1'b1;
    C_FMUL   :  op_decode[B_FMUL  ] = 1'b1;
    C_FMULS  :  op_decode[B_FMULS ] = 1'b1;
    C_FMULSU :  op_decode[B_FMULSU] = 1'b1;
    C_JMP    :  op_decode[B_JMP   ] = 1'b1;
    C_RJMP   :  op_decode[B_RJMP  ] = 1'b1;
    C_IJMP   :  op_decode[B_IJMP  ] = 1'b1;
    C_CALL   :  op_decode[B_CALL  ] = 1'b1;
    C_RCALL  :  op_decode[B_RCALL ] = 1'b1;
    C_ICALL  :  op_decode[B_ICALL ] = 1'b1;
    C_RET    :  op_decode[B_RET   ] = 1'b1;
    C_RETI   :  op_decode[B_RETI  ] = 1'b1;
    C_CP     :  op_decode[B_CP    ] = 1'b1;
    C_CPC    :  op_decode[B_CPC   ] = 1'b1;
    C_CPI    :  op_decode[B_CPI   ] = 1'b1;
    C_CPSE   :  op_decode[B_CPSE  ] = 1'b1;
    C_SBRC   :  op_decode[B_SBRC  ] = 1'b1;
    C_SBRS   :  op_decode[B_SBRS  ] = 1'b1;
    C_SBIC   :  op_decode[B_SBIC  ] = 1'b1;
    C_SBIS   :  op_decode[B_SBIS  ] = 1'b1;
    C_BRBS   :  op_decode[B_BRBS  ] = 1'b1;
    C_BRBC   :  op_decode[B_BRBC  ] = 1'b1;
    C_MOV    :  op_decode[B_MOV   ] = 1'b1;
    C_MOVW   :  op_decode[B_MOVW  ] = 1'b1;
    C_LDI    :  op_decode[B_LDI   ] = 1'b1;
    C_LDS    :  op_decode[B_LDS   ] = 1'b1;
    C_LDX    :  op_decode[B_LDX   ] = 1'b1;
    C_LDXI   :  op_decode[B_LDXI  ] = 1'b1;
    C_LDXD   :  op_decode[B_LDXD  ] = 1'b1;
    C_LDYI   :  op_decode[B_LDYI  ] = 1'b1;
    C_LDYD   :  op_decode[B_LDYD  ] = 1'b1;
    C_LDDY   :  op_decode[B_LDDY  ] = 1'b1;
    C_LDZI   :  op_decode[B_LDZI  ] = 1'b1;
    C_LDZD   :  op_decode[B_LDZD  ] = 1'b1;
    C_LDDZ   :  op_decode[B_LDDZ  ] = 1'b1;
    C_STS    :  op_decode[B_STS   ] = 1'b1;
    C_STX    :  op_decode[B_STX   ] = 1'b1;
    C_STXI   :  op_decode[B_STXI  ] = 1'b1;
    C_STXD   :  op_decode[B_STXD  ] = 1'b1;
    C_STYI   :  op_decode[B_STYI  ] = 1'b1;
    C_STYD   :  op_decode[B_STYD  ] = 1'b1;
    C_STDY   :  op_decode[B_STDY  ] = 1'b1;
    C_STZI   :  op_decode[B_STZI  ] = 1'b1;
    C_STZD   :  op_decode[B_STZD  ] = 1'b1;
    C_STDZ   :  op_decode[B_STDZ  ] = 1'b1;
    C_LPM    :  op_decode[B_LPM   ] = 1'b1;
    C_LPMZ   :  op_decode[B_LPMZ  ] = 1'b1;
    C_LPMZI  :  op_decode[B_LPMZI ] = 1'b1;
    C_SPM    :  op_decode[B_SPM   ] = 1'b1;
    C_IN     :  op_decode[B_IN    ] = 1'b1;
    C_OUT    :  op_decode[B_OUT   ] = 1'b1;
    C_PUSH   :  op_decode[B_PUSH  ] = 1'b1;
    C_POP    :  op_decode[B_POP   ] = 1'b1;
    C_ASR    :  op_decode[B_ASR   ] = 1'b1;
    C_LSR    :  op_decode[B_LSR   ] = 1'b1;
    C_ROR    :  op_decode[B_ROR   ] = 1'b1;
    C_SWAP   :  op_decode[B_SWAP  ] = 1'b1;
    C_SBI    :  op_decode[B_SBI   ] = 1'b1;
    C_CBI    :  op_decode[B_CBI   ] = 1'b1;
    C_BST    :  op_decode[B_BST   ] = 1'b1;
    C_BLD    :  op_decode[B_BLD   ] = 1'b1;
    C_BSET   :  op_decode[B_BSET  ] = 1'b1;
    C_BCLR   :  op_decode[B_BCLR  ] = 1'b1;
    C_NOP    :  op_decode[B_NOP   ] = 1'b1;
    default  :  ;
    endcase
end
endmodule
//----------------------------------------------------------------------
//  Decoded Nets Renaming
//----------------------------------------------------------------------
//  wire    op_add    = op_decode[B_ADD   ];//  000011rdddddrrrr    ADD  Rd,Rr
//  wire    op_adc    = op_decode[B_ADC   ];//  000111rdddddrrrr    ADC  Rd,Rr
//  wire    op_adiw   = op_decode[B_ADIW  ];//  10010110KKddKKKK    ADIW Rd,K
//  wire    op_sub    = op_decode[B_SUB   ];//  000110rdddddrrrr    SUB  Rd,Rr
//  wire    op_subi   = op_decode[B_SUBI  ];//  0101KKKKddddKKKK    SUBI Rd,K
//  wire    op_sbc    = op_decode[B_SBC   ];//  000010rdddddrrrr    SBC  Rd,Rr
//  wire    op_sbci   = op_decode[B_SBCI  ];//  0100KKKKddddKKKK    SBCI Rd,K
//  wire    op_sbiw   = op_decode[B_SBIW  ];//  10010111KKddKKKK    SBIW Rd,K
//  wire    op_and    = op_decode[B_AND   ];//  001000rdddddrrrr    AND  Rd,Rr
//  wire    op_andi   = op_decode[B_ANDI  ];//  0111KKKKddddKKKK    ANDI Rd,K
//  wire    op_or     = op_decode[B_OR    ];//  001010rdddddrrrr    OR   Rd,Rr
//  wire    op_ori    = op_decode[B_ORI   ];//  0110KKKKddddKKKK    ORI  Rd,K
//  wire    op_eor    = op_decode[B_EOR   ];//  001001rdddddrrrr    EOR  Rd,Rr
//  wire    op_com    = op_decode[B_COM   ];//  1001010ddddd0000    COM  Rd
//  wire    op_neg    = op_decode[B_NEG   ];//  1001010ddddd0001    NEG  Rd
//  wire    op_inc    = op_decode[B_INC   ];//  1001010ddddd0011    INC  Rd
//  wire    op_dec    = op_decode[B_DEC   ];//  1001010ddddd1010    DEC  Rd
//  wire    op_mul    = op_decode[B_MUL   ];//  100111rdddddrrrr    MUL  Rd,Rr
//  wire    op_muls   = op_decode[B_MULS  ];//  00000010ddddrrrr    MULS Rd,Rr
//  wire    op_mulsu  = op_decode[B_MULSU ];//  000000110ddd0rrr    MULSU  Rd,Rr
//  wire    op_fmul   = op_decode[B_FMUL  ];//  000000110ddd1rrr    FMUL   Rd,Rr
//  wire    op_fmuls  = op_decode[B_FMULS ];//  000000111ddd0rrr    FMULS  Rd,Rr
//  wire    op_fmulsu = op_decode[B_FMULSU];//  000000111ddd1rrr    FMULSU Rd,Rr
//  wire    op_jmp    = op_decode[B_JMP   ];//  1001010kkkkk110k    JMP  k
//  wire    op_rjmp   = op_decode[B_RJMP  ];//  1100kkkkkkkkkkkk    RJMP k
//  wire    op_ijmp   = op_decode[B_IJMP  ];//  1001010000001001    IJMP
//  wire    op_call   = op_decode[B_CALL  ];//  1001010kkkkk111k    CALL k
//  wire    op_rcall  = op_decode[B_RCALL ];//  1101kkkkkkkkkkkk    RCALL k
//  wire    op_icall  = op_decode[B_ICALL ];//  1001010100001001    ICALL
//  wire    op_ret    = op_decode[B_RET   ];//  1001010100001000    RET
//  wire    op_reti   = op_decode[B_RETI  ];//  1001010100011000    RETI
//  wire    op_cp     = op_decode[B_CP    ];//  000101rdddddrrrr    CP   Rd,Rr
//  wire    op_cpc    = op_decode[B_CPC   ];//  000001rdddddrrrr    CPC  Rd,Rr
//  wire    op_cpi    = op_decode[B_CPI   ];//  0011KKKKddddKKKK    CPI  Rd,K
//  wire    op_cpse   = op_decode[B_CPSE  ];//  000100rdddddrrrr    CPSE Rd,Rr
//  wire    op_sbrc   = op_decode[B_SBRC  ];//  1111110rrrrr0bbb    SBRC Rr,b
//  wire    op_sbrs   = op_decode[B_SBRS  ];//  1111111rrrrr0bbb    SBRS Rr,b
//  wire    op_sbic   = op_decode[B_SBIC  ];//  10011001AAAAAbbb    SBIC A,b
//  wire    op_sbis   = op_decode[B_SBIS  ];//  10011011AAAAAbbb    SBIS A,b
//  wire    op_brbs   = op_decode[B_BRBS  ];//  111100kkkkkkksss    BRBS s,k
//  wire    op_brbc   = op_decode[B_BRBC  ];//  111101kkkkkkksss    BRBC s,k
//  wire    op_mov    = op_decode[B_MOV   ];//  001011rdddddrrrr    MOV  Rd,Rr
//  wire    op_movw   = op_decode[B_MOVW  ];//  00000001ddddrrrr    MOVW Rd,Rr
//  wire    op_ldi    = op_decode[B_LDI   ];//  1110KKKKddddKKKK    LDI  Rd,K
//  wire    op_lds    = op_decode[B_LDS   ];//  1001000ddddd0000    LDS  Rd,k
//  wire    op_ldx    = op_decode[B_LDX   ];//  1001000ddddd1100    LD   Rd,X
//  wire    op_ldxi   = op_decode[B_LDXI  ];//  1001000ddddd1101    LD   Rd,X+
//  wire    op_ldxd   = op_decode[B_LDXD  ];//  1001000ddddd1110    LD   Rd,-X
//  wire    op_ldyi   = op_decode[B_LDYI  ];//  1001000ddddd1001    LD   Rd,Y+
//  wire    op_ldyd   = op_decode[B_LDYD  ];//  1001000ddddd1010    LD   Rd,-Y
//  wire    op_lddy   = op_decode[B_LDDY  ];//  10q0qq0ddddd1qqq    LDD  Rd,Y+q
//  wire    op_ldzi   = op_decode[B_LDZI  ];//  1001000ddddd0001    LD   Rd,Z+
//  wire    op_ldzd   = op_decode[B_LDZD  ];//  1001000ddddd0010    LD   Rd,-Z
//  wire    op_lddz   = op_decode[B_LDDZ  ];//  10q0qq0ddddd0qqq    LDD  Rd,Z+q
//  wire    op_sts    = op_decode[B_STS   ];//  1001001rrrrr0000    STS  k,Rr
//  wire    op_stx    = op_decode[B_STX   ];//  1001001rrrrr1100    ST   X,Rr
//  wire    op_stxi   = op_decode[B_STXI  ];//  1001001rrrrr1101    ST   X+,Rr
//  wire    op_stxd   = op_decode[B_STXD  ];//  1001001rrrrr1110    ST   -X,Rr
//  wire    op_styi   = op_decode[B_STYI  ];//  1001001rrrrr1001    ST   Y+,Rr
//  wire    op_styd   = op_decode[B_STYD  ];//  1001001rrrrr1010    ST   -Y,Rr
//  wire    op_stdy   = op_decode[B_STDY  ];//  10q0qq1rrrrr1qqq    STD  Y+q,Rr
//  wire    op_stzi   = op_decode[B_STZI  ];//  1001001rrrrr0001    ST   Z+,Rr
//  wire    op_stzd   = op_decode[B_STZD  ];//  1001001rrrrr0010    ST   -Z,Rr
//  wire    op_stdz   = op_decode[B_STDZ  ];//  10q0qq1rrrrr0qqq    STD  Z+q,Rr
//  wire    op_lpm    = op_decode[B_LPM   ];//  1001010111001000    LPM
//  wire    op_lpmz   = op_decode[B_LPMZ  ];//  1001000ddddd0100    LPM  Rd,Z
//  wire    op_lpmzi  = op_decode[B_LPMZI ];//  1001000ddddd0101    LPM  Rd,Z+
//  wire    op_spm    = op_decode[B_SPM   ];//  1001010111101000    SPM
//  wire    op_in     = op_decode[B_IN    ];//  10110AAdddddAAAA    IN   Rd,A
//  wire    op_out    = op_decode[B_OUT   ];//  10111AArrrrrAAAA    OUT  A,Rr
//  wire    op_push   = op_decode[B_PUSH  ];//  1001001rrrrr1111    PUSH Rr
//  wire    op_pop    = op_decode[B_POP   ];//  1001000ddddd1111    POP  Rd
//  wire    op_asr    = op_decode[B_ASR   ];//  1001010ddddd0101    ASR  Rd
//  wire    op_lsr    = op_decode[B_LSR   ];//  1001010ddddd0110    LSR  Rd
//  wire    op_ror    = op_decode[B_ROR   ];//  1001010ddddd0111    ROR  Rd
//  wire    op_swap   = op_decode[B_SWAP  ];//  1001010ddddd0010    SWAP Rd
//  wire    op_sbi    = op_decode[B_SBI   ];//  10011010AAAAAbbb    SBI  A,b
//  wire    op_cbi    = op_decode[B_CBI   ];//  10011000AAAAAbbb    CBI  A,b
//  wire    op_bst    = op_decode[B_BST   ];//  1111101ddddd0bbb    BST  Rd,b
//  wire    op_bld    = op_decode[B_BLD   ];//  1111100ddddd0bbb    BLD  Rd,b
//  wire    op_bset   = op_decode[B_BSET  ];//  100101000sss1000    BSET s
//  wire    op_bclr   = op_decode[B_BCLR  ];//  100101001sss1000    BCLR s
//  wire    op_nop    = op_decode[B_NOP   ];//  0000000000000000    NOP

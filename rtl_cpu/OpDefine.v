//----------------------------------------------------------------------
//  Opcode Definitions
//----------------------------------------------------------------------
localparam  C_NOP    = 16'b 0000000000000000; //  NOP
                         // 00000000xxxxxxx1; //  (reserved)
                         // 00000000xxxxxx1x; //  (reserved)
                         // 00000000xxxxx1xx; //  (reserved)
                         // 00000000xxxx1xxx; //  (reserved)
                         // 00000000xxx1xxxx; //  (reserved)
                         // 00000000xx1xxxxx; //  (reserved)
                         // 00000000x1xxxxxx; //  (reserved)
                         // 000000001xxxxxxx; //  (reserved)
localparam  C_MOVW   = 16'b 00000001xxxxxxxx; //  MOVW Rd,Rr
localparam  C_MULS   = 16'b 00000010xxxxxxxx; //  MULS Rd,Rr
localparam  C_MULSU  = 16'b 000000110xxx0xxx; //  MULSU  Rd,Rr
localparam  C_FMUL   = 16'b 000000110xxx1xxx; //  FMUL   Rd,Rr
localparam  C_FMULS  = 16'b 000000111xxx0xxx; //  FMULS  Rd,Rr
localparam  C_FMULSU = 16'b 000000111xxx1xxx; //  FMULSU Rd,Rr
localparam  C_CPC    = 16'b 000001xxxxxxxxxx; //  CPC  Rd,Rr
localparam  C_SBC    = 16'b 000010xxxxxxxxxx; //  SBC  Rd,Rr
localparam  C_ADD    = 16'b 000011xxxxxxxxxx; //  ADD  Rd,Rr
localparam  C_CPSE   = 16'b 000100xxxxxxxxxx; //  CPSE Rd,Rr
localparam  C_CP     = 16'b 000101xxxxxxxxxx; //  CP   Rd,Rr
localparam  C_SUB    = 16'b 000110xxxxxxxxxx; //  SUB  Rd,Rr
localparam  C_ADC    = 16'b 000111xxxxxxxxxx; //  ADC  Rd,Rr
localparam  C_AND    = 16'b 001000xxxxxxxxxx; //  AND  Rd,Rr
localparam  C_EOR    = 16'b 001001xxxxxxxxxx; //  EOR  Rd,Rr
localparam  C_OR     = 16'b 001010xxxxxxxxxx; //  OR   Rd,Rr
localparam  C_MOV    = 16'b 001011xxxxxxxxxx; //  MOV  Rd,Rr
localparam  C_CPI    = 16'b 0011xxxxxxxxxxxx; //  CPI  Rd,K
localparam  C_SBCI   = 16'b 0100xxxxxxxxxxxx; //  SBCI Rd,K
localparam  C_SUBI   = 16'b 0101xxxxxxxxxxxx; //  SUBI Rd,K
localparam  C_ORI    = 16'b 0110xxxxxxxxxxxx; //  ORI  Rd,K
localparam  C_ANDI   = 16'b 0111xxxxxxxxxxxx; //  ANDI Rd,K
localparam  C_LDDZ   = 16'b 10x0xx0xxxxx0xxx; //  LDD  Rd,Z+q
localparam  C_LDDY   = 16'b 10x0xx0xxxxx1xxx; //  LDD  Rd,Y+q
localparam  C_STDZ   = 16'b 10x0xx1xxxxx0xxx; //  STD  Z+q,Rr
localparam  C_STDY   = 16'b 10x0xx1xxxxx1xxx; //  STD  Y+q,Rr
localparam  C_LDS    = 16'b 1001000xxxxx0000; //  LDS  Rd,k
localparam  C_LDZI   = 16'b 1001000xxxxx0001; //  LD   Rd,Z+
localparam  C_LDZD   = 16'b 1001000xxxxx0010; //  LD   Rd,-Z
                         // 1001000xxxxx0011; //  (reserved)
localparam  C_LPMZ   = 16'b 1001000xxxxx0100; //  LPM  Rd,Z
localparam  C_LPMZI  = 16'b 1001000xxxxx0101; //  LPM  Rd,Z+
                         // 1001000xxxxx0110; //  ELPM Rd,Z  (not supported)
                         // 1001000xxxxx0111; //  ELPM Rd,Z+ (not supported)
                         // 1001000xxxxx1000; //  (reserved)
localparam  C_LDYI   = 16'b 1001000xxxxx1001; //  LD   Rd,Y+
localparam  C_LDYD   = 16'b 1001000xxxxx1010; //  LD   Rd,-Y
                         // 1001000xxxxx1011; //  (reserved)
localparam  C_LDX    = 16'b 1001000xxxxx1100; //  LD   Rd,X
localparam  C_LDXI   = 16'b 1001000xxxxx1101; //  LD   Rd,X+
localparam  C_LDXD   = 16'b 1001000xxxxx1110; //  LD   Rd,-X
localparam  C_POP    = 16'b 1001000xxxxx1111; //  POP  Rd
localparam  C_STS    = 16'b 1001001xxxxx0000; //  STS  k,Rr
localparam  C_STZI   = 16'b 1001001xxxxx0001; //  ST   Z+,Rr
localparam  C_STZD   = 16'b 1001001xxxxx0010; //  ST   -Z,Rr
                         // 1001001xxxxx0011; //  (reserved)
                         // 1001001xxxxx0100; //  XCH  Z,Rd (not supported)
                         // 1001001xxxxx0101; //  LAS  Z,Rd (not supported)
                         // 1001001xxxxx0110; //  LAC  Z,Rd (not supported)
                         // 1001001xxxxx0111; //  LAT  Z,Rd (not supported)
                         // 1001001xxxxx1000; //  (reserved)
localparam  C_STYI   = 16'b 1001001xxxxx1001; //  ST   Y+,Rr
localparam  C_STYD   = 16'b 1001001xxxxx1010; //  ST   -Y,Rr
                         // 1001001xxxxx1011; //  (reserved)
localparam  C_STX    = 16'b 1001001xxxxx1100; //  ST   X,Rr
localparam  C_STXI   = 16'b 1001001xxxxx1101; //  ST   X+,Rr
localparam  C_STXD   = 16'b 1001001xxxxx1110; //  ST   -X,Rr
localparam  C_PUSH   = 16'b 1001001xxxxx1111; //  PUSH Rr
localparam  C_COM    = 16'b 1001010xxxxx0000; //  COM  Rd
localparam  C_NEG    = 16'b 1001010xxxxx0001; //  NEG  Rd
localparam  C_SWAP   = 16'b 1001010xxxxx0010; //  SWAP Rd
localparam  C_INC    = 16'b 1001010xxxxx0011; //  INC  Rd
                         // 1001010xxxxx0100; //  (reserved)
localparam  C_ASR    = 16'b 1001010xxxxx0101; //  ASR  Rd
localparam  C_LSR    = 16'b 1001010xxxxx0110; //  LSR  Rd
localparam  C_ROR    = 16'b 1001010xxxxx0111; //  ROR  Rd
localparam  C_BSET   = 16'b 100101000xxx1000; //  BSET s
localparam  C_BCLR   = 16'b 100101001xxx1000; //  BCLR s
localparam  C_RET    = 16'b 1001010100001000; //  RET
localparam  C_RETI   = 16'b 1001010100011000; //  RETI
                         // 100101010x1x1000; //  (reserved)
                         // 1001010101xx1000; //  (reserved)
                         // 1001010110001000; //  SLEEP (not supported)
                         // 1001010110011000; //  BREAK (not supported)
                         // 1001010110101000; //  WDR   (not supported)
                         // 1001010110111000; //  (reserved)
localparam  C_LPM    = 16'b 1001010111001000; //  LPM
                         // 1001010111011000; //  ELPM   (not supported)
localparam  C_SPM    = 16'b 1001010111101000; //  SPM
                         // 1001010111111000; //  SPM Z+ (not supported)
localparam  C_IJMP   = 16'b 1001010000001001; //  IJMP
                         // 1001010000011001; //  EIJMP  (not supported)
localparam  C_ICALL  = 16'b 1001010100001001; //  ICALL
                         // 1001010100011001; //  EICALL (not supported)
                         // 1001010xxx1x1001; //  (reserved)
                         // 1001010xx1xx1001; //  (reserved)
                         // 1001010x1xxx1001; //  (reserved)
localparam  C_DEC    = 16'b 1001010xxxxx1010; //  DEC  Rd
                         // 10010100xxxx1011; //  DES (not supported)
                         // 10010101xxxx1011; //  (reserved)
localparam  C_JMP    = 16'b 1001010xxxxx110x; //  JMP  k
localparam  C_CALL   = 16'b 1001010xxxxx111x; //  CALL k
localparam  C_ADIW   = 16'b 10010110xxxxxxxx; //  ADIW Rd,K
localparam  C_SBIW   = 16'b 10010111xxxxxxxx; //  SBIW Rd,K
localparam  C_CBI    = 16'b 10011000xxxxxxxx; //  CBI  A,b
localparam  C_SBIC   = 16'b 10011001xxxxxxxx; //  SBIC A,b
localparam  C_SBI    = 16'b 10011010xxxxxxxx; //  SBI  A,b
localparam  C_SBIS   = 16'b 10011011xxxxxxxx; //  SBIS A,b
localparam  C_MUL    = 16'b 100111xxxxxxxxxx; //  MUL  Rd,Rr
localparam  C_IN     = 16'b 10110xxxxxxxxxxx; //  IN   Rd,A
localparam  C_OUT    = 16'b 10111xxxxxxxxxxx; //  OUT  A,Rr
localparam  C_RJMP   = 16'b 1100xxxxxxxxxxxx; //  RJMP k
localparam  C_RCALL  = 16'b 1101xxxxxxxxxxxx; //  RCALL k
localparam  C_LDI    = 16'b 1110xxxxxxxxxxxx; //  LDI  Rd,K
localparam  C_BRBS   = 16'b 111100xxxxxxxxxx; //  BRBS s,k
localparam  C_BRBC   = 16'b 111101xxxxxxxxxx; //  BRBC s,k
localparam  C_BLD    = 16'b 1111100xxxxx0xxx; //  BLD  Rd,b
localparam  C_BST    = 16'b 1111101xxxxx0xxx; //  BST  Rd,b
localparam  C_SBRC   = 16'b 1111110xxxxx0xxx; //  SBRC Rr,b
localparam  C_SBRS   = 16'b 1111111xxxxx0xxx; //  SBRS Rr,b
                         // 11111xxxxxxx1xxx; //  (reserved)
//----------------------------------------------------------------------
//  AVR Opcode List
//----------------------------------------------------------------------
//  0000000000000000    NOP
//  00000000xxxxxxx1    (reserved)
//  00000000xxxxxx1x    (reserved)
//  00000000xxxxx1xx    (reserved)
//  00000000xxxx1xxx    (reserved)
//  00000000xxx1xxxx    (reserved)
//  00000000xx1xxxxx    (reserved)
//  00000000x1xxxxxx    (reserved)
//  000000001xxxxxxx    (reserved)
//  00000001ddddrrrr    MOVW Rd,Rr
//  00000010ddddrrrr    MULS Rd,Rr
//  000000110ddd0rrr    MULSU  Rd,Rr
//  000000110ddd1rrr    FMUL   Rd,Rr
//  000000111ddd0rrr    FMULS  Rd,Rr
//  000000111ddd1rrr    FMULSU Rd,Rr
//  000001rdddddrrrr    CPC  Rd,Rr
//  000010rdddddrrrr    SBC  Rd,Rr
//  000011rdddddrrrr    ADD  Rd,Rr
//  000100rdddddrrrr    CPSE Rd,Rr
//  000101rdddddrrrr    CP   Rd,Rr
//  000110rdddddrrrr    SUB  Rd,Rr
//  000111rdddddrrrr    ADC  Rd,Rr
//  001000rdddddrrrr    AND  Rd,Rr
//  001001rdddddrrrr    EOR  Rd,Rr
//  001010rdddddrrrr    OR   Rd,Rr
//  001011rdddddrrrr    MOV  Rd,Rr
//  0011KKKKddddKKKK    CPI  Rd,K
//  0100KKKKddddKKKK    SBCI Rd,K
//  0101KKKKddddKKKK    SUBI Rd,K
//  0110KKKKddddKKKK    ORI  Rd,K
//  0111KKKKddddKKKK    ANDI Rd,K
//  10q0qq0ddddd0qqq    LDD  Rd,Z+q
//  10q0qq0ddddd1qqq    LDD  Rd,Y+q
//  10q0qq1rrrrr0qqq    STD  Z+q,Rr
//  10q0qq1rrrrr1qqq    STD  Y+q,Rr
//  1001000ddddd0000    kkkkkkkkkkkkkkkk    LDS  Rd,k
//  1001000ddddd0001    LD   Rd,Z+
//  1001000ddddd0010    LD   Rd,-Z
//  1001000xxxxx0011    (reserved)
//  1001000ddddd0100    LPM  Rd,Z
//  1001000ddddd0101    LPM  Rd,Z+
//  1001000ddddd0110    ELPM Rd,Z
//  1001000ddddd0111    ELPM Rd,Z+
//  1001000xxxxx1000    (reserved)
//  1001000ddddd1001    LD   Rd,Y+
//  1001000ddddd1010    LD   Rd,-Y
//  1001000xxxxx1011    (reserved)
//  1001000ddddd1100    LD   Rd,X
//  1001000ddddd1101    LD   Rd,X+
//  1001000ddddd1110    LD   Rd,-X
//  1001000ddddd1111    POP  Rd
//  1001001rrrrr0000    kkkkkkkkkkkkkkkk    STS  k,Rr
//  1001001rrrrr0001    ST   Z+,Rr
//  1001001rrrrr0010    ST   -Z,Rr
//  1001001xxxxx0011    (reserved)
//  1001001ddddd0100    XCH  Z,Rd
//  1001001ddddd0101    LAS  Z,Rd
//  1001001ddddd0110    LAC  Z,Rd
//  1001001ddddd0111    LAT  Z,Rd
//  1001001xxxxx1000    (reserved)
//  1001001rrrrr1001    ST   Y+,Rr
//  1001001rrrrr1010    ST   -Y,Rr
//  1001001xxxxx1011    (reserved)
//  1001001rrrrr1100    ST   X,Rr
//  1001001rrrrr1101    ST   X+,Rr
//  1001001rrrrr1110    ST   -X,Rr
//  1001001rrrrr1111    PUSH Rr
//  1001010ddddd0000    COM  Rd
//  1001010ddddd0001    NEG  Rd
//  1001010ddddd0010    SWAP Rd
//  1001010ddddd0011    INC  Rd
//  1001010xxxxx0100    (reserved)
//  1001010ddddd0101    ASR  Rd
//  1001010ddddd0110    LSR  Rd
//  1001010ddddd0111    ROR  Rd
//  100101000sss1000    BSET s
//  100101001sss1000    BCLR s
//  1001010100001000    RET
//  1001010100011000    RETI
//  100101010x1x1000    (reserved)
//  1001010101xx1000    (reserved)
//  1001010110001000    SLEEP
//  1001010110011000    BREAK
//  1001010110101000    WDR
//  1001010110111000    (reserved)
//  1001010111001000    LPM
//  1001010111011000    ELPM
//  1001010111101000    SPM
//  1001010111111000    SPM Z+
//  1001010000001001    IJMP
//  1001010000011001    EIJMP
//  1001010100001001    ICALL
//  1001010100011001    EICALL
//  1001010xxx1x1001    (reserved)
//  1001010xx1xx1001    (reserved)
//  1001010x1xxx1001    (reserved)
//  1001010ddddd1010    DEC  Rd
//  10010100KKKK1011    DES
//  10010101xxxx1011    (reserved)
//  1001010kkkkk110k    kkkkkkkkkkkkkkkk    JMP k
//  1001010kkkkk111k    kkkkkkkkkkkkkkkk    CALL k
//  10010110KKddKKKK    ADIW Rd,K
//  10010111KKddKKKK    SBIW Rd,K
//  10011000AAAAAbbb    CBI  A,b
//  10011001AAAAAbbb    SBIC A,b
//  10011010AAAAAbbb    SBI  A,b
//  10011011AAAAAbbb    SBIS A,b
//  100111rdddddrrrr    MUL  Rd,Rr
//  10110AAdddddAAAA    IN   Rd,A
//  10111AArrrrrAAAA    OUT  A,Rr
//  1100kkkkkkkkkkkk    RJMP k
//  1101kkkkkkkkkkkk    RCALL k
//  1110KKKKddddKKKK    LDI  Rd,K
//  111100kkkkkkksss    BRBS s,k
//  111101kkkkkkksss    BRBC s,k
//  1111100ddddd0bbb    BLD  Rd,b
//  1111101ddddd0bbb    BST  Rd,b
//  1111110rrrrr0bbb    SBRC Rr,b
//  1111111rrrrr0bbb    SBRS Rr,b
//  11111xxxxxxx1xxx    (reserved)
//----------------------------------------------------------------------
//  Opcode Aliases
//----------------------------------------------------------------------
//  000011dddddddddd    LSL  Rd   (ADD  Rd,Rd)
//  000111dddddddddd    ROL  Rd   (ADC  Rd,Rd)
//  001000dddddddddd    TST  Rd   (AND  Rd,Rd)
//  001001dddddddddd    CLR  Rd   (EOR  Rd,Rd)
//  0110KKKKddddKKKK    SBR  Rd,K (ORI  Rd,K)
//  0111KKKKddddKKKK    CBR  Rd,K (ANDI Rd,K)
//  1001010000001000    SEC  (BSET 0)
//  1001010000011000    SEZ  (BSET 1)
//  1001010000101000    SEN  (BSET 2)
//  1001010000111000    SEV  (BSET 3)
//  1001010001001000    SES  (BSET 4)
//  1001010001011000    SEH  (BSET 5)
//  1001010001101000    SET  (BSET 6)
//  1001010001111000    SEI  (BSET 7)
//  1001010010001000    CLC  (BCLR 0)
//  1001010010011000    CLZ  (BCLR 1)
//  1001010010101000    CLN  (BCLR 2)
//  1001010010111000    CLV  (BCLR 3)
//  1001010011001000    CLS  (BCLR 4)
//  1001010011011000    CLH  (BCLR 5)
//  1001010011101000    CLT  (BCLR 6)
//  1001010011111000    CLI  (BCLR 7)
//  1000000ddddd0000    LD   Rd,Z (LDD  Rd,Z+0)
//  1000000ddddd1000    LD   Rd,Y (LDD  Rd,Y+0)
//  1000001rrrrr0000    ST   Z,Rr (STD  Z+0,Rr)
//  1000001rrrrr1000    ST   Y,Rr (STD  Y+0,Rr)
//  11101111dddd1111    SER  Rd   (LDI  Rd,$FF)
//  111100kkkkkkk000    BRCS k (BRBS 0,k)
//  111100kkkkkkk000    BRLO k (BRBS 0,k)
//  111100kkkkkkk001    BREQ k (BRBS 1,k)
//  111100kkkkkkk010    BRMI k (BRBS 2,k)
//  111100kkkkkkk011    BRVS k (BRBS 3,k)
//  111100kkkkkkk100    BRLT k (BRBS 4,k)
//  111100kkkkkkk101    BRHS k (BRBS 5,k)
//  111100kkkkkkk110    BRTS k (BRBS 6,k)
//  111100kkkkkkk111    BRIE k (BRBS 7,k)
//  111101kkkkkkk000    BRCC k (BRBC 0,k)
//  111101kkkkkkk000    BRSH k (BRBC 0,k)
//  111101kkkkkkk001    BRNE k (BRBC 1,k)
//  111101kkkkkkk010    BRPL k (BRBC 2,k)
//  111101kkkkkkk011    BRVC k (BRBC 3,k)
//  111101kkkkkkk100    BRGE k (BRBC 4,k)
//  111101kkkkkkk101    BRHC k (BRBC 5,k)
//  111101kkkkkkk110    BRTC k (BRBC 6,k)
//  111101kkkkkkk111    BRID k (BRBC 7,k)

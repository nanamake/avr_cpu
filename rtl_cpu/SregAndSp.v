//----------------------------------------------------------------------
//  SregAndSp: Status Register and Stack Pointer
//----------------------------------------------------------------------
module  SregAndSp (
    input               clock,      //  Master clock
    input               reset,      //  Active high asynchronous reset
    input       [15:0]  ir,         //  Instruction word
    input               alu_cf,     //  ALU carry flag
    input               alu_zf,     //  ALU zero flag
    input               alu_nf,     //  ALU negative flag
    input               alu_vf,     //  ALU overflow flag
    input               alu_sf,     //  ALU sign flag
    input               alu_hf,     //  ALU half carry flag
    input               mul_cf,     //  Multiplication carry flag
    input               mul_zf,     //  Multiplication zero flag
    input       [15:0]  ptr_ro,     //  Pointer calculation result
    input       [7:0]   bsc_ro,     //  Bit set/clear result
    input               bst_tf,     //  BST instruction transfer bit
    input               mm_sp_l_we, //  Stack pointer low byte write enable
    input               mm_sp_h_we, //  Stack pointer high byte write enable
    input               mm_sreg_we, //  Status register write enable
    input       [7:0]   mm_io_wdata,//  Memory mapped I/O write data
    input               irq_det,    //  Interrupt detected (accepted)
    input               irq_ret,    //  Interrupt returned
    input               tim_sr_en,  //  Timing of status register update
    input               tim_sp_en,  //  Timing of stack pointer update
    output  reg [15:0]  sp,         //  Stack pointer
    output      [7:0]   sreg,       //  Status register
    output  reg         sr_cf,      //  Status register carry flag
    output  reg         sr_zf,      //  Status register zero flag
    output  reg         sr_tf,      //  Status register transfer bit
    output  reg         sr_if       //  Status register interrupt flag
);

parameter   SP_RESET = 16'h4ff;     //  Stack Pointer Reset Value

//----------------------------------------------------------------------
//  Internal Nets
//----------------------------------------------------------------------
wire[15:0]  sp_new;
wire[15:0]  sp_new_mm;
wire        sp_new_en;
reg         sr_nf;
reg         sr_vf;
reg         sr_sf;
reg         sr_hf;
wire        cf_new;
wire        zf_new;
wire        nf_new;
wire        vf_new;
wire        sf_new;
wire        hf_new;
wire        tf_new;
wire        if_new;
wire        cf_new_en;
wire        zf_new_en;
wire        nf_new_en;
wire        vf_new_en;
wire        sf_new_en;
wire        hf_new_en;
wire        tf_new_en;
wire        if_new_en;
reg [7:0]   en_mask;

//----------------------------------------------------------------------
//  Stack Pointer
//----------------------------------------------------------------------
always @(posedge clock or posedge reset) begin
    if (reset) begin
        sp <= SP_RESET;
    end else begin
        sp <= sp_new_en ? sp_new : sp;
    end
end

assign  sp_new = (mm_sp_l_we | mm_sp_h_we) ? sp_new_mm : ptr_ro;

assign  sp_new_mm = (mm_sp_l_we ? {sp[15:8], mm_io_wdata} : 16'h0000)
                  | (mm_sp_h_we ? {mm_io_wdata, sp[7:0]}  : 16'h0000);

assign  sp_new_en = mm_sp_l_we | mm_sp_h_we | tim_sp_en;

//----------------------------------------------------------------------
//  Status Reigister
//----------------------------------------------------------------------
always @(posedge clock or posedge reset) begin
    if (reset) begin
        sr_cf <= 1'b0;
        sr_zf <= 1'b0;
        sr_nf <= 1'b0;
        sr_vf <= 1'b0;
        sr_sf <= 1'b0;
        sr_hf <= 1'b0;
        sr_tf <= 1'b0;
        sr_if <= 1'b0;
    end else begin
        sr_cf <= cf_new_en ? cf_new : sr_cf;
        sr_zf <= zf_new_en ? zf_new : sr_zf;
        sr_nf <= nf_new_en ? nf_new : sr_nf;
        sr_vf <= vf_new_en ? vf_new : sr_vf;
        sr_sf <= sf_new_en ? sf_new : sr_sf;
        sr_hf <= hf_new_en ? hf_new : sr_hf;
        sr_tf <= tf_new_en ? tf_new : sr_tf;
        sr_if <= if_new_en ? if_new : sr_if;
    end
end
assign  sreg[0] = sr_cf;
assign  sreg[1] = sr_zf;
assign  sreg[2] = sr_nf;
assign  sreg[3] = sr_vf;
assign  sreg[4] = sr_sf;
assign  sreg[5] = sr_hf;
assign  sreg[6] = sr_tf;
assign  sreg[7] = sr_if;

assign  cf_new = mm_sreg_we ? mm_io_wdata[0] : (bsc_ro[0] | alu_cf | mul_cf);
assign  zf_new = mm_sreg_we ? mm_io_wdata[1] : (bsc_ro[1] | alu_zf | mul_zf);
assign  nf_new = mm_sreg_we ? mm_io_wdata[2] : (bsc_ro[2] | alu_nf);
assign  vf_new = mm_sreg_we ? mm_io_wdata[3] : (bsc_ro[3] | alu_vf);
assign  sf_new = mm_sreg_we ? mm_io_wdata[4] : (bsc_ro[4] | alu_sf);
assign  hf_new = mm_sreg_we ? mm_io_wdata[5] : (bsc_ro[5] | alu_hf);
assign  tf_new = mm_sreg_we ? mm_io_wdata[6] : (bsc_ro[6] | bst_tf);
assign  if_new = irq_det ? 1'b0
               : mm_sreg_we ? mm_io_wdata[7] : (bsc_ro[7] | irq_ret);

assign  cf_new_en = mm_sreg_we | (tim_sr_en & en_mask[0]);
assign  zf_new_en = mm_sreg_we | (tim_sr_en & en_mask[1]);
assign  nf_new_en = mm_sreg_we | (tim_sr_en & en_mask[2]);
assign  vf_new_en = mm_sreg_we | (tim_sr_en & en_mask[3]);
assign  sf_new_en = mm_sreg_we | (tim_sr_en & en_mask[4]);
assign  hf_new_en = mm_sreg_we | (tim_sr_en & en_mask[5]);
assign  tf_new_en = mm_sreg_we | (tim_sr_en & en_mask[6]);
assign  if_new_en = mm_sreg_we | (tim_sr_en & en_mask[7]) | irq_det;

`include "OpDefine.v"
always @* begin
    casex (ir)
    //                       ITHS_VNZC
    C_ADD    : en_mask = 8'b 0011_1111; //  ADD  Rd,Rr
    C_ADC    : en_mask = 8'b 0011_1111; //  ADC  Rd,Rr
    C_ADIW   : en_mask = 8'b 0001_1111; //  ADIW Rd,K
    C_SUB    : en_mask = 8'b 0011_1111; //  SUB  Rd,Rr
    C_SUBI   : en_mask = 8'b 0011_1111; //  SUBI Rd,K
    C_SBC    : en_mask = 8'b 0011_1111; //  SBC  Rd,Rr
    C_SBCI   : en_mask = 8'b 0011_1111; //  SBCI Rd,K
    C_SBIW   : en_mask = 8'b 0001_1111; //  SBIW Rd,K
    C_AND    : en_mask = 8'b 0001_1110; //  AND  Rd,Rr
    C_ANDI   : en_mask = 8'b 0001_1110; //  ANDI Rd,K
    C_OR     : en_mask = 8'b 0001_1110; //  OR   Rd,Rr
    C_ORI    : en_mask = 8'b 0001_1110; //  ORI  Rd,K
    C_EOR    : en_mask = 8'b 0001_1110; //  EOR  Rd,Rr
    C_COM    : en_mask = 8'b 0001_1111; //  COM  Rd
    C_NEG    : en_mask = 8'b 0011_1111; //  NEG  Rd
    C_INC    : en_mask = 8'b 0001_1110; //  INC  Rd
    C_DEC    : en_mask = 8'b 0001_1110; //  DEC  Rd
    C_MUL    : en_mask = 8'b 0000_0011; //  MUL  Rd,Rr
    C_MULS   : en_mask = 8'b 0000_0011; //  MULS Rd,Rr
    C_MULSU  : en_mask = 8'b 0000_0011; //  MULSU  Rd,Rr
    C_FMUL   : en_mask = 8'b 0000_0011; //  FMUL   Rd,Rr
    C_FMULS  : en_mask = 8'b 0000_0011; //  FMULS  Rd,Rr
    C_FMULSU : en_mask = 8'b 0000_0011; //  FMULSU Rd,Rr
    //                       ITHS_VNZC
    C_JMP    : en_mask = 8'b 0000_0000; //  JMP  k
    C_RJMP   : en_mask = 8'b 0000_0000; //  RJMP k
    C_IJMP   : en_mask = 8'b 0000_0000; //  IJMP
    C_CALL   : en_mask = 8'b 0000_0000; //  CALL k
    C_RCALL  : en_mask = 8'b 0000_0000; //  RCALL k
    C_ICALL  : en_mask = 8'b 0000_0000; //  ICALL
    C_RET    : en_mask = 8'b 0000_0000; //  RET
    C_RETI   : en_mask = 8'b 1000_0000; //  RETI
    C_CP     : en_mask = 8'b 0011_1111; //  CP   Rd,Rr
    C_CPC    : en_mask = 8'b 0011_1111; //  CPC  Rd,Rr
    C_CPI    : en_mask = 8'b 0011_1111; //  CPI  Rd,K
    C_CPSE   : en_mask = 8'b 0000_0000; //  CPSE Rd,Rr
    C_SBRC   : en_mask = 8'b 0000_0000; //  SBRC Rr,b
    C_SBRS   : en_mask = 8'b 0000_0000; //  SBRS Rr,b
    C_SBIC   : en_mask = 8'b 0000_0000; //  SBIC A,b
    C_SBIS   : en_mask = 8'b 0000_0000; //  SBIS A,b
    C_BRBS   : en_mask = 8'b 0000_0000; //  BRBS s,k
    C_BRBC   : en_mask = 8'b 0000_0000; //  BRBC s,k
    //                       ITHS_VNZC
    C_MOV    : en_mask = 8'b 0000_0000; //  MOV  Rd,Rr
    C_MOVW   : en_mask = 8'b 0000_0000; //  MOVW Rd,Rr
    C_LDI    : en_mask = 8'b 0000_0000; //  LDI  Rd,K
    C_LDS    : en_mask = 8'b 0000_0000; //  LDS  Rd,k
    C_LDX    : en_mask = 8'b 0000_0000; //  LD   Rd,X
    C_LDXI   : en_mask = 8'b 0000_0000; //  LD   Rd,X+
    C_LDXD   : en_mask = 8'b 0000_0000; //  LD   Rd,-X
    C_LDYI   : en_mask = 8'b 0000_0000; //  LD   Rd,Y+
    C_LDYD   : en_mask = 8'b 0000_0000; //  LD   Rd,-Y
    C_LDDY   : en_mask = 8'b 0000_0000; //  LDD  Rd,Y+q
    C_LDZI   : en_mask = 8'b 0000_0000; //  LD   Rd,Z+
    C_LDZD   : en_mask = 8'b 0000_0000; //  LD   Rd,-Z
    C_LDDZ   : en_mask = 8'b 0000_0000; //  LDD  Rd,Z+q
    C_STS    : en_mask = 8'b 0000_0000; //  STS  k,Rr
    C_STX    : en_mask = 8'b 0000_0000; //  ST   X,Rr
    C_STXI   : en_mask = 8'b 0000_0000; //  ST   X+,Rr
    C_STXD   : en_mask = 8'b 0000_0000; //  ST   -X,Rr
    C_STYI   : en_mask = 8'b 0000_0000; //  ST   Y+,Rr
    C_STYD   : en_mask = 8'b 0000_0000; //  ST   -Y,Rr
    C_STDY   : en_mask = 8'b 0000_0000; //  STD  Y+q,Rr
    C_STZI   : en_mask = 8'b 0000_0000; //  ST   Z+,Rr
    C_STZD   : en_mask = 8'b 0000_0000; //  ST   -Z,Rr
    C_STDZ   : en_mask = 8'b 0000_0000; //  STD  Z+q,Rr
    C_LPM    : en_mask = 8'b 0000_0000; //  LPM
    C_LPMZ   : en_mask = 8'b 0000_0000; //  LPM  Rd,Z
    C_LPMZI  : en_mask = 8'b 0000_0000; //  LPM  Rd,Z+
    C_SPM    : en_mask = 8'b 0000_0000; //  SPM
    C_IN     : en_mask = 8'b 0000_0000; //  IN   Rd,A
    C_OUT    : en_mask = 8'b 0000_0000; //  OUT  A,Rr
    C_PUSH   : en_mask = 8'b 0000_0000; //  PUSH Rr
    C_POP    : en_mask = 8'b 0000_0000; //  POP  Rd
    //                       ITHS_VNZC
    C_ASR    : en_mask = 8'b 0001_1111; //  ASR  Rd
    C_LSR    : en_mask = 8'b 0001_1111; //  LSR  Rd
    C_ROR    : en_mask = 8'b 0001_1111; //  ROR  Rd
    C_SWAP   : en_mask = 8'b 0000_0000; //  SWAP Rd
    C_SBI    : en_mask = 8'b 0000_0000; //  SBI  A,b
    C_CBI    : en_mask = 8'b 0000_0000; //  CBI  A,b
    C_BST    : en_mask = 8'b 0100_0000; //  BST  Rd,b
    C_BLD    : en_mask = 8'b 0000_0000; //  BLD  Rd,b
    C_BSET   : en_mask = 8'b 1111_1111; //  BSET s
    C_BCLR   : en_mask = 8'b 1111_1111; //  BCLR s
    //                       ITHS_VNZC
    C_NOP    : en_mask = 8'b 0000_0000; //  NOP
    default  : en_mask = 8'b 0000_0000;
    endcase
end

endmodule

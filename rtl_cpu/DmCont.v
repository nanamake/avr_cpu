//----------------------------------------------------------------------
//  DmCont: Data Memory Space Read/Write Control
//----------------------------------------------------------------------
module  DmCont (
    input               clock,          //  Master clock
    input               reset,          //  Active high asynchronous reset
    input       [7:0]   dm_rdata,       //  Data SRAM read data
    input       [7:0]   io_rdata,       //  I/O register read data
    input       [7:0]   rf_rdata,       //  Register file read data
    input       [7:0]   sreg,           //  Status register
    input       [15:0]  sp,             //  Stack pointer
    input       [15:0]  sp_pre,         //  Stack pointer pre-incremented value
    input       [15:0]  pc,             //  Program counter
    input       [15:0]  ir,             //  Instruction register
    input       [1:0]   cycle,          //  Cycle counter
    input       [15:0]  alu_ai,         //  ALU operand A
    input       [15:0]  alu_ro,         //  ALU result
    input       [7:0]   bsc_ro,         //  Bit set/clear result
    input       [0:82]  op_decode,      //  Decoded opcodes
    input               tim_dm_re,      //  Timing of data memory space read
    input               tim_dm_we,      //  Timing of data memory space write
    output  reg [15:0]  dm_addr,        //  Data SRAM address
    output  reg         dm_re,          //  Data SRAM read enable
    output  reg         dm_we,          //  Data SRAM write enable
    output  reg [7:0]   dm_wdata,       //  Data SRAM write data
    output  reg [7:0]   io_addr,        //  I/O register address
    output  reg         io_re,          //  I/O register read enable
    output  reg         io_we,          //  I/O register write enable
    output  reg [7:0]   io_wdata,       //  I/O register write data
    output              mm_sp_l_we,     //  Stack pointer low byte write enable
    output              mm_sp_h_we,     //  Stack pointer high byte write enable
    output              mm_sreg_we,     //  Status register write enable
    output      [7:0]   mm_io_wdata,    //  Memory mapped I/O write data
    output      [7:0]   mm_io_rdata,    //  Memory mapped I/O read data
    output      [7:0]   mm_rdata,       //  Data memory space read data
    output  reg         mm_rdata_en     //  Data memory space read data enable
);

//----------------------------------------------------------------------
//  Internal Nets
//----------------------------------------------------------------------
wire[15:0]  mm_addr;
wire        mm_pre_op;
wire        mm_post_op;
wire        sp_dec_op;
wire        sp_inc_op;
wire        mm_op;
wire[15:0]  ac_dm_addr;
wire        ac_dm_en;
wire[7:0]   ac_io_addr;
wire        ac_io_en;
wire        io_5bit_op;
wire        io_6bit_op;
wire[7:0]   mx_io_addr;
wire        mx_io_en;
wire        em_io_en;
wire        em_sp_l_en;
wire        em_sp_h_en;
wire        em_sreg_en;
wire        tm_dm_re;
wire        tm_dm_we;
wire        tm_io_re;
wire        tm_io_we;
wire        tm_sp_l_re;
wire        tm_sp_l_we;
wire        tm_sp_h_re;
wire        tm_sp_h_we;
wire        tm_sreg_re;
wire        tm_sreg_we;
wire[7:0]   mm_wdata;
wire        mm_wd_pc_h;
wire        mm_wd_pc_l;
wire        mm_wd_rf;
wire        mm_wd_bsc;
reg         mm_sp_l_re;
reg         mm_sp_h_re;
reg         mm_sreg_re;

//  Decoded Opcode Renaming
`include "OpNumber.v"
wire    op_call   = op_decode[B_CALL  ];//  1001010kkkkk111k    CALL k
wire    op_rcall  = op_decode[B_RCALL ];//  1101kkkkkkkkkkkk    RCALL k
wire    op_icall  = op_decode[B_ICALL ];//  1001010100001001    ICALL
wire    op_ret    = op_decode[B_RET   ];//  1001010100001000    RET
wire    op_reti   = op_decode[B_RETI  ];//  1001010100011000    RETI
wire    op_lds    = op_decode[B_LDS   ];//  1001000ddddd0000    LDS  Rd,k
wire    op_ldx    = op_decode[B_LDX   ];//  1001000ddddd1100    LD   Rd,X
wire    op_ldxi   = op_decode[B_LDXI  ];//  1001000ddddd1101    LD   Rd,X+
wire    op_ldxd   = op_decode[B_LDXD  ];//  1001000ddddd1110    LD   Rd,-X
wire    op_ldyi   = op_decode[B_LDYI  ];//  1001000ddddd1001    LD   Rd,Y+
wire    op_ldyd   = op_decode[B_LDYD  ];//  1001000ddddd1010    LD   Rd,-Y
wire    op_lddy   = op_decode[B_LDDY  ];//  10q0qq0ddddd1qqq    LDD  Rd,Y+q
wire    op_ldzi   = op_decode[B_LDZI  ];//  1001000ddddd0001    LD   Rd,Z+
wire    op_ldzd   = op_decode[B_LDZD  ];//  1001000ddddd0010    LD   Rd,-Z
wire    op_lddz   = op_decode[B_LDDZ  ];//  10q0qq0ddddd0qqq    LDD  Rd,Z+q
wire    op_sts    = op_decode[B_STS   ];//  1001001rrrrr0000    STS  k,Rr
wire    op_stx    = op_decode[B_STX   ];//  1001001rrrrr1100    ST   X,Rr
wire    op_stxi   = op_decode[B_STXI  ];//  1001001rrrrr1101    ST   X+,Rr
wire    op_stxd   = op_decode[B_STXD  ];//  1001001rrrrr1110    ST   -X,Rr
wire    op_styi   = op_decode[B_STYI  ];//  1001001rrrrr1001    ST   Y+,Rr
wire    op_styd   = op_decode[B_STYD  ];//  1001001rrrrr1010    ST   -Y,Rr
wire    op_stdy   = op_decode[B_STDY  ];//  10q0qq1rrrrr1qqq    STD  Y+q,Rr
wire    op_stzi   = op_decode[B_STZI  ];//  1001001rrrrr0001    ST   Z+,Rr
wire    op_stzd   = op_decode[B_STZD  ];//  1001001rrrrr0010    ST   -Z,Rr
wire    op_stdz   = op_decode[B_STDZ  ];//  10q0qq1rrrrr0qqq    STD  Z+q,Rr
wire    op_push   = op_decode[B_PUSH  ];//  1001001rrrrr1111    PUSH Rr
wire    op_pop    = op_decode[B_POP   ];//  1001000ddddd1111    POP  Rd
wire    op_in     = op_decode[B_IN    ];//  10110AAdddddAAAA    IN   Rd,A
wire    op_out    = op_decode[B_OUT   ];//  10111AArrrrrAAAA    OUT  A,Rr
wire    op_sbic   = op_decode[B_SBIC  ];//  10011001AAAAAbbb    SBIC A,b
wire    op_sbis   = op_decode[B_SBIS  ];//  10011011AAAAAbbb    SBIS A,b
wire    op_sbi    = op_decode[B_SBI   ];//  10011010AAAAAbbb    SBI  A,b
wire    op_cbi    = op_decode[B_CBI   ];//  10011000AAAAAbbb    CBI  A,b

//----------------------------------------------------------------------
//  Convert Logical Address to Physical Address
//----------------------------------------------------------------------
DmAdConv AC (
    .mm_addr    (mm_addr    ),  //  (i) Memory mapped address
    .mm_en      (mm_op      ),  //  (i) Memory mapping enable
    .dm_addr    (ac_dm_addr ),  //  (o) Data SRAM address
    .dm_en      (ac_dm_en   ),  //  (o) Data SRAM enable
    .io_addr    (ac_io_addr ),  //  (o) I/O register address
    .io_en      (ac_io_en   )   //  (o) I/O register enable
);

assign  mm_addr = (mm_pre_op  ? alu_ro : 16'h0000)
                | (mm_post_op ? alu_ai : 16'h0000)
                | (sp_dec_op  ? sp     : 16'h0000)
                | (sp_inc_op  ? sp_pre : 16'h0000);

assign  mm_pre_op   = op_lds    //  LDS  Rd,k
                    | op_ldx    //  LD   Rd,X
                    | op_ldxd   //  LD   Rd,-X
                    | op_ldyd   //  LD   Rd,-Y
                    | op_ldzd   //  LD   Rd,-Z
                    | op_lddy   //  LDD  Rd,Y+q
                    | op_lddz   //  LDD  Rd,Z+q
                    | op_sts    //  STS  k,Rr
                    | op_stx    //  ST   X,Rr
                    | op_stxd   //  ST   -X,Rr
                    | op_styd   //  ST   -Y,Rr
                    | op_stzd   //  ST   -Z,Rr
                    | op_stdy   //  STD  Y+q,Rr
                    | op_stdz;  //  STD  Z+q,Rr

assign  mm_post_op  = op_ldxi   //  LD   Rd,X+
                    | op_ldyi   //  LD   Rd,Y+
                    | op_ldzi   //  LD   Rd,Z+
                    | op_stxi   //  ST   X+,Rr
                    | op_styi   //  ST   Y+,Rr
                    | op_stzi;  //  ST   Z+,Rr

assign  sp_dec_op   = op_call   //  CALL k
                    | op_rcall  //  RCALL k
                    | op_icall  //  ICALL
                    | op_push;  //  PUSH Rr

assign  sp_inc_op   = op_ret    //  RET
                    | op_reti   //  RETI
                    | op_pop;   //  POP  Rd

assign  mm_op = mm_pre_op | mm_post_op | sp_dec_op | sp_inc_op;

//----------------------------------------------------------------------
//  Multiplex Memory Mapped I/O and I/O Direct
//----------------------------------------------------------------------
assign  io_5bit_op  = op_sbic   //  10011001AAAAAbbb    SBIC A,b
                    | op_sbis   //  10011011AAAAAbbb    SBIS A,b
                    | op_sbi    //  10011010AAAAAbbb    SBI  A,b
                    | op_cbi;   //  10011000AAAAAbbb    CBI  A,b

assign  io_6bit_op  = op_in     //  10110AAdddddAAAA    IN   Rd,A
                    | op_out;   //  10111AArrrrrAAAA    OUT  A,Rr

assign  mx_io_addr = (mm_op      ? ac_io_addr                : 8'h00)
                   | (io_5bit_op ? {3'h0, ir[7:3]}           : 8'h00)
                   | (io_6bit_op ? {2'h0, ir[10:9], ir[3:0]} : 8'h00);

assign  mx_io_en = ac_io_en | io_5bit_op | io_6bit_op;

//  Mask I/O Enable with Internal Register Enable
DmEnMask EM (
    .io_addr    (mx_io_addr ),  //  (i) I/O register address
    .io_en_i    (mx_io_en   ),  //  (i) I/O register enable
    .io_en_o    (em_io_en   ),  //  (o) Masked I/O register enable
    .sp_l_en    (em_sp_l_en ),  //  (o) Stack pointer low byte enable
    .sp_h_en    (em_sp_h_en ),  //  (o) Stack pointer high byte enable
    .sreg_en    (em_sreg_en )   //  (o) Status register enable
);

//  Memory Read/Write Timings
assign  tm_dm_re = ac_dm_en & tim_dm_re;
assign  tm_dm_we = ac_dm_en & tim_dm_we;
assign  tm_io_re = em_io_en & tim_dm_re;
assign  tm_io_we = em_io_en & tim_dm_we;
assign  tm_sp_l_re = em_sp_l_en & tim_dm_re;
assign  tm_sp_l_we = em_sp_l_en & tim_dm_we;
assign  tm_sp_h_re = em_sp_h_en & tim_dm_re;
assign  tm_sp_h_we = em_sp_h_en & tim_dm_we;
assign  tm_sreg_re = em_sreg_en & tim_dm_re;
assign  tm_sreg_we = em_sreg_en & tim_dm_we;

//----------------------------------------------------------------------
//  CPU External Outputs
//----------------------------------------------------------------------
//  Output to Data SRAM
always @(posedge clock or posedge reset) begin
    if (reset) begin
        dm_addr <= 16'h0000;
        dm_re <= 1'b0;
        dm_we <= 1'b0;
        dm_wdata <= 8'h00;
    end else begin
        dm_addr <= (tm_dm_re | tm_dm_we) ? ac_dm_addr : dm_addr;
        dm_re <= tm_dm_re;
        dm_we <= tm_dm_we;
        dm_wdata <= tm_dm_we ? mm_wdata : dm_wdata;
    end
end

//  Output to I/O Register
always @(posedge clock or posedge reset) begin
    if (reset) begin
        io_addr <= 8'h00;
        io_re <= 1'b0;
        io_we <= 1'b0;
        io_wdata <= 8'h00;
    end else begin
        io_addr <= (tm_io_re | tm_io_we) ? mx_io_addr : io_addr;
        io_re <= tm_io_re;
        io_we <= tm_io_we;
        io_wdata <= tm_io_we ? mm_wdata : io_wdata;
    end
end

assign  mm_wdata = (mm_wd_pc_h ? pc[15:8] : 8'h00)
                 | (mm_wd_pc_l ? pc[7:0]  : 8'h00)
                 | (mm_wd_rf   ? rf_rdata : 8'h00)
                 | (mm_wd_bsc  ? bsc_ro   : 8'h00);

assign  mm_wd_pc_h  = (op_call & (cycle == 2'd1))   //  CALL k
                    | (op_rcall & (cycle == 2'd0))  //  RCALL k
                    | (op_icall & (cycle == 2'd0)); //  ICALL

assign  mm_wd_pc_l  = (op_call & (cycle == 2'd2))   //  CALL k
                    | (op_rcall & (cycle == 2'd1))  //  RCALL k
                    | (op_icall & (cycle == 2'd1)); //  ICALL

assign  mm_wd_rf    = op_sts    //  STS  k,Rr
                    | op_stx    //  ST   X,Rr
                    | op_stxi   //  ST   X+,Rr
                    | op_stxd   //  ST   -X,Rr
                    | op_styi   //  ST   Y+,Rr
                    | op_styd   //  ST   -Y,Rr
                    | op_stdy   //  STD  Y+q,Rr
                    | op_stzi   //  ST   Z+,Rr
                    | op_stzd   //  ST   -Z,Rr
                    | op_stdz   //  STD  Z+q,Rr
                    | op_push   //  PUSH Rr
                    | op_out;   //  OUT  A,Rr

assign  mm_wd_bsc   = op_sbi    //  SBI  A,b
                    | op_cbi;   //  CBI  A,b

//----------------------------------------------------------------------
//  CPU Internal Outputs
//----------------------------------------------------------------------
assign  mm_sp_l_we = tm_sp_l_we;
assign  mm_sp_h_we = tm_sp_h_we;
assign  mm_sreg_we = tm_sreg_we;
assign  mm_io_wdata = mm_wdata;

//  Read data multiplex
always @(posedge clock) begin
    mm_sp_l_re <= tm_sp_l_re;
    mm_sp_h_re <= tm_sp_h_re;
    mm_sreg_re <= tm_sreg_re;
end

assign  mm_io_rdata = (io_re      ? io_rdata : 8'h00)
                    | (mm_sp_l_re ? sp[7:0]  : 8'h00)
                    | (mm_sp_h_re ? sp[15:8] : 8'h00)
                    | (mm_sreg_re ? sreg     : 8'h00);

assign  mm_rdata = mm_io_rdata
                 | (dm_re ? dm_rdata : 8'h00);

always @(posedge clock) begin
    mm_rdata_en <= tim_dm_re;
end

endmodule

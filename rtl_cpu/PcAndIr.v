//----------------------------------------------------------------------
//  PcAndIr: Program Counter and Instruction Register
//----------------------------------------------------------------------
module  PcAndIr (
    input               clock,          //  Master clock
    input               reset,          //  Active high asynchronous reset
    input       [15:0]  pm_rdata,       //  Program SRAM read data
    input       [7:0]   dm_rdata,       //  Data SRAM read data
    input       [7:0]   io_rdata,       //  I/O register read data
    input       [7:0]   rf_rdata,       //  Register file read data
    input       [7:0]   sreg,           //  Status register
    input       [15:0]  alu_ro,         //  ALU result
    input               alu_zf,         //  ALU zero flag
    input               irq,            //  Interrupt request
    input       [15:0]  irq_addr,       //  Interrupt vector address
    input               sr_if,          //  Interrupt flag in status register
    input       [0:82]  op_decode,      //  Decoded opcodes
    input               tim_cyc_end,    //  Timing of cycle termination
    input               tim_pc_en,      //  Timing of program counter update
    output  reg [15:0]  pc,             //  Program counter
    output      [15:0]  pc_new,         //  Program counter next value
    output              pc_new_en,      //  Program counter update enable
    output  reg [15:0]  ir,             //  Instruction register
    output  reg [15:0]  ir_2nd,         //  Instruction 2nd word register
    output  reg [1:0]   cycle,          //  Cycle counter
    output              skip_en,        //  Skip enable (operation inhibit)
    output              irq_det,        //  Interrupt detected (accepted)
    output              irq_ret         //  Interrupt returned
);

//----------------------------------------------------------------------
//  Internal Nets
//----------------------------------------------------------------------
reg         as_reset;
reg         sy_reset;
wire[15:0]  pc_inc;
wire[15:0]  pc_jmp_mx;
wire        pc_jmp_en;
wire        pc_mx_alu;
wire        pc_mx_ret_l;
wire        pc_mx_ret_h;
wire        brn_cyc_end;
wire        ir_en;
wire        ir_2nd_en;
wire        cyc_end;
wire        skp_det;
reg         skp_1st;
reg         skp_2nd;
wire        skp_2nd_det;
wire        skp_cyc_end;
reg         irq_det_1d;
reg         irq_det_2d;

//  Decoded Opcode Renaming
`include "OpNumber.v"
wire    op_jmp    = op_decode[B_JMP   ];//  1001010kkkkk110k    JMP  k
wire    op_rjmp   = op_decode[B_RJMP  ];//  1100kkkkkkkkkkkk    RJMP k
wire    op_ijmp   = op_decode[B_IJMP  ];//  1001010000001001    IJMP
wire    op_call   = op_decode[B_CALL  ];//  1001010kkkkk111k    CALL k
wire    op_rcall  = op_decode[B_RCALL ];//  1101kkkkkkkkkkkk    RCALL k
wire    op_icall  = op_decode[B_ICALL ];//  1001010100001001    ICALL
wire    op_ret    = op_decode[B_RET   ];//  1001010100001000    RET
wire    op_reti   = op_decode[B_RETI  ];//  1001010100011000    RETI
wire    op_cpse   = op_decode[B_CPSE  ];//  000100rdddddrrrr    CPSE Rd,Rr
wire    op_sbrc   = op_decode[B_SBRC  ];//  1111110rrrrr0bbb    SBRC Rr,b
wire    op_sbrs   = op_decode[B_SBRS  ];//  1111111rrrrr0bbb    SBRS Rr,b
wire    op_sbic   = op_decode[B_SBIC  ];//  10011001AAAAAbbb    SBIC A,b
wire    op_sbis   = op_decode[B_SBIS  ];//  10011011AAAAAbbb    SBIS A,b
wire    op_brbs   = op_decode[B_BRBS  ];//  111100kkkkkkksss    BRBS s,k
wire    op_brbc   = op_decode[B_BRBC  ];//  111101kkkkkkksss    BRBC s,k
wire    op_lds    = op_decode[B_LDS   ];//  1001000ddddd0000    LDS  Rd,k
wire    op_sts    = op_decode[B_STS   ];//  1001001rrrrr0000    STS  k,Rr

//----------------------------------------------------------------------
//  Program Counter
//----------------------------------------------------------------------
//  Synchronize start timing of PC and IR
always @(posedge clock) begin
    as_reset <= reset;
    sy_reset <= as_reset;
end

always @(posedge clock or posedge reset) begin
    if (reset) begin
        pc <= 16'h0000;
    end else begin
        pc <= pc_new_en ? pc_new : pc;
    end
end

assign  pc_new_en = ~sy_reset & (tim_pc_en | cyc_end | skip_en) & ~irq_det;

assign  pc_new = irq_det_2d ? irq_addr
               : (~skip_en & pc_jmp_en) ? pc_jmp_mx : pc_inc;

assign  pc_inc = pc + 1'b1;

assign  pc_jmp_mx = (pc_mx_alu   ? alu_ro               : 16'h0000)
                  | (pc_mx_ret_l ? {pc[15:8], dm_rdata} : 16'h0000)
                  | (pc_mx_ret_h ? {dm_rdata, pc[7:0]}  : 16'h0000);

assign  pc_jmp_en = pc_mx_alu | pc_mx_ret_l | pc_mx_ret_h;

assign  pc_mx_alu = (op_jmp  & (cycle == 2'd1))
                  | (op_rjmp & (cycle == 2'd0))
                  | (op_ijmp & (cycle == 2'd0))
                  | (op_call  & (cycle == 2'd2))
                  | (op_rcall & (cycle == 2'd1))
                  | (op_icall & (cycle == 2'd1))
                  | (op_brbs & (cycle == 2'd0) &  sreg[ir[2:0]])
                  | (op_brbc & (cycle == 2'd0) & ~sreg[ir[2:0]]);

assign  pc_mx_ret_l = (op_ret  & (cycle == 2'd1))
                    | (op_reti & (cycle == 2'd1));
assign  pc_mx_ret_h = (op_ret  & (cycle == 2'd2))
                    | (op_reti & (cycle == 2'd2));

//  Branch Control (false condition timing)
assign  brn_cyc_end = (op_brbs & ~sreg[ir[2:0]])
                    | (op_brbc &  sreg[ir[2:0]]);

//----------------------------------------------------------------------
//  Instruction Register
//----------------------------------------------------------------------
always @(posedge clock or posedge reset) begin
    if (reset) begin
        ir <= 16'h0000;
        ir_2nd <= 16'h0000;
    end else begin
        //  When interrupt detected, set RCALL
        ir <= irq_det ? 16'hd000 : ir_en ? pm_rdata : ir;
        ir_2nd <= ir_2nd_en ? pm_rdata : ir_2nd;
    end
end

assign  ir_en = ~sy_reset & cyc_end;

assign  ir_2nd_en = (op_jmp  & (cycle == 2'd0))
                  | (op_call & (cycle == 2'd0))
                  | (op_lds  & (cycle == 2'd0))
                  | (op_sts  & (cycle == 2'd0));

//  Cycle Counter
always @(posedge clock or posedge reset) begin
    if (reset) begin
        cycle <= 2'd0;
    end else begin
        cycle <= cyc_end ? 2'd0 : (cycle + 1'b1);
    end
end

assign  cyc_end = tim_cyc_end | brn_cyc_end | skp_cyc_end;

//----------------------------------------------------------------------
//  Skip
//----------------------------------------------------------------------
assign  skp_det = ~skip_en
                & ( (op_cpse & alu_zf)
                  | (op_sbrc & ~rf_rdata[ir[2:0]])
                  | (op_sbrs &  rf_rdata[ir[2:0]])
                  | (op_sbic & (cycle == 2'd1) & ~io_rdata[ir[2:0]])
                  | (op_sbis & (cycle == 2'd1) &  io_rdata[ir[2:0]]) );

always @(posedge clock) begin
    skp_1st <= skp_det;
    skp_2nd <= skp_2nd_det;
end

assign  skp_2nd_det = (skp_1st & op_jmp )
                    | (skp_1st & op_call)
                    | (skp_1st & op_lds )
                    | (skp_1st & op_sts );

assign  skp_cyc_end = (skp_1st & ~skp_2nd_det) | skp_2nd;

assign  skip_en = skp_1st | skp_2nd;

//----------------------------------------------------------------------
//  Interrupt
//----------------------------------------------------------------------
assign  irq_det = (irq & sr_if) & (cyc_end & ~skp_det);
assign  irq_ret = op_reti & (cycle == 2'd2);

always @(posedge clock) begin
    irq_det_1d <= irq_det;
    irq_det_2d <= irq_det_1d;
end

endmodule

//----------------------------------------------------------------------
//  Multiply: Multiplication Unit for AVR Compatible CPU
//----------------------------------------------------------------------
module  Multiply (
    input           clock,      //  Master clock
    input   [7:0]   ai,         //  Operand A
    input   [7:0]   bi,         //  Operand B
    input   [0:82]  op_decode,  //  Decoded opcodes
    output  [15:0]  ro,         //  Result output
    output          cf,         //  Carry flag
    output          zf          //  Zero flag
);

parameter   IREG = 1;   //  Use multiplier input register
parameter   OREG = 0;   //  Use multiplier output register

//  Decoded Opcode Renaming
`include "OpNumber.v"
wire    op_mul    = op_decode[B_MUL   ];//  100111rdddddrrrr    MUL  Rd,Rr
wire    op_muls   = op_decode[B_MULS  ];//  00000010ddddrrrr    MULS Rd,Rr
wire    op_mulsu  = op_decode[B_MULSU ];//  000000110ddd0rrr    MULSU  Rd,Rr
wire    op_fmul   = op_decode[B_FMUL  ];//  000000110ddd1rrr    FMUL   Rd,Rr
wire    op_fmuls  = op_decode[B_FMULS ];//  000000111ddd0rrr    FMULS  Rd,Rr
wire    op_fmulsu = op_decode[B_FMULSU];//  000000111ddd1rrr    FMULSU Rd,Rr

//  Internal nets
wire signed [8:0]   mu_ai_comb;
wire signed [8:0]   mu_bi_comb;
reg  signed [8:0]   mu_ai_ff;
reg  signed [8:0]   mu_bi_ff;
wire signed [8:0]   mu_ai;
wire signed [8:0]   mu_bi;
wire signed [16:0]  mu_po_comb;
reg  signed [16:0]  mu_po_ff;
wire signed [16:0]  mu_po;
wire                mul_en;
wire                fmul_en;

//  Extend operands
assign  mu_ai_comb = (op_muls
                     |op_mulsu
                     |op_fmuls
                     |op_fmulsu) ? {ai[7], ai} : {1'b0, ai};

assign  mu_bi_comb = (op_muls
                     |op_fmuls) ? {bi[7], bi} : {1'b0, bi};

always @(posedge clock) begin
    mu_ai_ff <= mu_ai_comb;
    mu_bi_ff <= mu_bi_comb;
end

assign  mu_ai = IREG ? mu_ai_ff : mu_ai_comb;
assign  mu_bi = IREG ? mu_bi_ff : mu_bi_comb;

//  Signed multiplication
assign  mu_po_comb = mu_ai * mu_bi;

always @(posedge clock) begin
    mu_po_ff <= mu_po_comb;
end

assign  mu_po = OREG ? mu_po_ff : mu_po_comb;

//  Outputs
assign  mul_en  = op_mul
                | op_muls
                | op_mulsu;
assign  fmul_en = op_fmul
                | op_fmuls
                | op_fmulsu;

assign  ro = (mul_en ? mu_po : 16'h0000)
           | (fmul_en ? (mu_po << 1) : 16'h0000);

assign  cf = (mul_en | fmul_en) ? mu_po[15] : 1'b0;
assign  zf = (mul_en | fmul_en) ? (ro == 16'h0000) : 1'b0;

endmodule

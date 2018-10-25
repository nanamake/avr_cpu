//----------------------------------------------------------------------
//  ALU: ALU for AVR Compatible CPU
//----------------------------------------------------------------------
module  ALU (
    input   [15:0]  ai,         //  Operand A
    input   [15:0]  bi,         //  Operand B
    input           ci,         //  Carry input
    input           op_adc_b,   //  Operation ADC(8-bit) enable
    input           op_sbc_b,   //  Operation SBC(8-bit) enable
    input           op_adc_w,   //  Operation ADC(16-bit) enable
    input           op_sbc_w,   //  Operation SBC(16-bit) enable
    input           op_and,     //  Operation AND enable
    input           op_or,      //  Operation OR enable
    input           op_eor,     //  Operation EOR enable
    input           op_asr,     //  Operation ASR enable
    input           op_lsr,     //  Operation LSR enable
    input           op_ror,     //  Operation ROR enable
    input           op_swap,    //  Operation SWAP enable
    output  [15:0]  ro,         //  Result output
    output          cf,         //  Carry flag
    output          zf,         //  Zero flag
    output          nf,         //  Negative flag
    output          vf,         //  Overflow flag
    output          sf,         //  Sign flag
    output          hf          //  Half carry flag
);

//  Internal nets
wire[15:0]  sw_bi;
wire        sw_ci;
wire[15:0]  so;
wire        co;
wire        adc_b_hf;
wire        adc_b_cf;
wire        adc_b_vf;
wire        adc_w_vf;
wire[7:0]   ai_l;
wire[7:0]   bi_l;
wire[7:0]   and_ro;
wire[7:0]   or_ro;
wire[7:0]   eor_ro;
wire[7:0]   asr_ro;
wire[7:0]   lsr_ro;
wire[7:0]   ror_ro;
wire        asr_cf;
wire        lsr_cf;
wire        ror_cf;
wire        asr_vf;
wire        lsr_vf;
wire        ror_vf;
wire[7:0]   swap_ro;
wire        op_adc_sbc;
wire        byte_op;
wire        word_op;

//  ADC/SBC switch
assign  sw_bi = (op_sbc_b | op_sbc_w) ? ~bi : bi;
assign  sw_ci = (op_sbc_b | op_sbc_w) ? ~ci : ci;

//  16-bit addition
assign  {co, so} = ai + sw_bi + sw_ci;

assign  adc_b_hf = (ai[3] & sw_bi[3]) | (ai[3] & ~so[3]) | (sw_bi[3] & ~so[3]);
assign  adc_b_cf = (ai[7] & sw_bi[7]) | (ai[7] & ~so[7]) | (sw_bi[7] & ~so[7]);
assign  adc_b_vf = (~ai[ 7] & ~sw_bi[ 7] & so[ 7]) | (ai[ 7] & sw_bi[ 7] & ~so[ 7]);
assign  adc_w_vf = (~ai[15] & ~sw_bi[15] & so[15]) | (ai[15] & sw_bi[15] & ~so[15]);

//  AND/OR/EOR
assign  ai_l = ai[7:0];
assign  bi_l = bi[7:0];

assign  and_ro = ai_l & bi_l;
assign  or_ro  = ai_l | bi_l;
assign  eor_ro = ai_l ^ bi_l;

//  ASR/LSR/ROR
assign  {asr_ro, asr_cf} = {ai_l[7], ai_l};
assign  {lsr_ro, lsr_cf} = {1'b0, ai_l};
assign  {ror_ro, ror_cf} = {ci, ai_l};

assign  asr_vf = asr_ro[7] ^ asr_cf;
assign  lsr_vf = lsr_ro[7] ^ lsr_cf;
assign  ror_vf = ror_ro[7] ^ ror_cf;

//  SWAP
assign  swap_ro = {ai_l[3:0], ai_l[7:4]};

//  Result output (and-or multiplexer)
assign  op_adc_sbc = op_adc_b | op_sbc_b
                   | op_adc_w | op_sbc_w;

assign  ro = (op_adc_sbc ? so : 16'h0000)
           | (op_and  ? {8'h00, and_ro } : 16'h0000)
           | (op_or   ? {8'h00, or_ro  } : 16'h0000)
           | (op_eor  ? {8'h00, eor_ro } : 16'h0000)
           | (op_asr  ? {8'h00, asr_ro } : 16'h0000)
           | (op_lsr  ? {8'h00, lsr_ro } : 16'h0000)
           | (op_ror  ? {8'h00, ror_ro } : 16'h0000)
           | (op_swap ? {8'h00, swap_ro} : 16'h0000);

//  Flag outputs
assign  byte_op = op_adc_b
                | op_sbc_b
                | op_and
                | op_or
                | op_eor
                | op_asr
                | op_lsr
                | op_ror
                | op_swap;

assign  word_op = op_adc_w
                | op_sbc_w;

assign  cf = (op_adc_b & adc_b_cf)
           | (op_sbc_b & ~adc_b_cf)
           | (op_adc_w & co)
           | (op_sbc_w & ~co)
           | (op_asr & asr_cf)
           | (op_lsr & lsr_cf)
           | (op_ror & ror_cf);

assign  zf = (byte_op & (ro[7:0] == 8'h00))
           | (word_op & (ro == 16'h0000));

assign  nf = (byte_op & ro[7])
           | (word_op & ro[15]);

assign  vf = ((op_adc_b | op_sbc_b) & adc_b_vf)
           | ((op_adc_w | op_sbc_w) & adc_w_vf)
           | (op_asr & asr_vf)
           | (op_lsr & lsr_vf)
           | (op_ror & ror_vf);

assign  sf = nf ^ vf;

assign  hf = (op_adc_b & adc_b_hf)
           | (op_sbc_b & ~adc_b_hf);

endmodule

//----------------------------------------------------------------------
//  CPU: AVR Instruction Compatible CPU
//----------------------------------------------------------------------
module  CPU (
    input           clock,      //  Master clock
    input           reset,      //  Active high asynchronous reset
    input   [15:0]  pm_rdata,   //  Program SRAM read data
    output  [15:0]  pm_addr,    //  Program SRAM address
    output          pm_re,      //  Program SRAM read enable
    output          pm_we,      //  Program SRAM write enable
    output  [15:0]  pm_wdata,   //  Program SRAM write data
    input   [7:0]   dm_rdata,   //  Data SRAM read data
    output  [15:0]  dm_addr,    //  Data SRAM address
    output          dm_re,      //  Data SRAM read enable
    output          dm_we,      //  Data SRAM write enable
    output  [7:0]   dm_wdata,   //  Data SRAM write data
    input   [7:0]   io_rdata,   //  I/O register read data
    output  [7:0]   io_addr,    //  I/O register address
    output          io_re,      //  I/O register read enable
    output          io_we,      //  I/O register write enable
    output  [7:0]   io_wdata,   //  I/O register write data
    input           irq,        //  Interrupt request
    input   [15:0]  irq_addr    //  Interrupt vector address
);

//----------------------------------------------------------------------
//  Internal Nets
//----------------------------------------------------------------------
wire[15:0]  pc;
wire[15:0]  pc_new;
wire        pc_new_en;
wire[15:0]  ir;
wire[15:0]  ir_2nd;
wire[1:0]   cycle;
wire        skip_en;
wire        irq_det;
wire        irq_ret;
wire[0:82]  op_decode;
wire        tim_cyc_end;
wire        tim_pc_en;
wire        tim_pm_re;
wire        tim_dm_re;
wire        tim_dm_we;
wire        tim_rf_we;
wire        tim_sr_en;
wire        tim_sp_en;
wire[15:0]  alu_ai;
wire[15:0]  alu_bi;
wire        alu_ci;
wire        sel_adc_b;
wire        sel_sbc_b;
wire        sel_adc_w;
wire        sel_sbc_w;
wire        sel_and;
wire        sel_or;
wire        sel_eor;
wire        sel_asr;
wire        sel_lsr;
wire        sel_ror;
wire        sel_swap;
wire        sel_mul;
wire        sel_muls;
wire        sel_mulsu;
wire        sel_fmul;
wire        sel_fmuls;
wire        sel_fmulsu;
wire[15:0]  alu_ro;
wire        alu_cf;
wire        alu_zf;
wire        alu_nf;
wire        alu_vf;
wire        alu_sf;
wire        alu_hf;
wire[15:0]  mul_ro;
wire        mul_cf;
wire        mul_zf;
wire[7:0]   bsc_ro;
wire        bst_tf;
wire        mm_sp_l_we;
wire        mm_sp_h_we;
wire        mm_sreg_we;
wire[7:0]   mm_io_wdata;
wire[7:0]   mm_io_rdata;
wire[7:0]   mm_rdata;
wire        mm_rdata_en;
wire[7:0]   lpm_data;
wire        lpm_data_en;
wire[4:0]   rf_waddr;
wire[15:0]  rf_wdata;
wire        rf_we_byte;
wire        rf_we_word;
wire        rf_re_word;
wire[4:0]   rf_raddr_a;
wire[4:0]   rf_raddr_b;
wire[15:0]  rf_rdata_a;
wire[7:0]   rf_rdata_b;
wire[15:0]  sp;
wire[15:0]  sp_pre;
wire[7:0]   sreg;
wire        sr_cf;
wire        sr_tf;
wire        sr_if;

//----------------------------------------------------------------------
//  Program Counter and Instruction Decoder
//----------------------------------------------------------------------
PcAndIr PAI (
    .clock      (clock      ),  //  (i) Master clock
    .reset      (reset      ),  //  (i) Active high asynchronous reset
    .pm_rdata   (pm_rdata   ),  //  (i) Program SRAM read data
    .dm_rdata   (dm_rdata   ),  //  (i) Data SRAM read data
    .io_rdata   (mm_io_rdata),  //  (i) I/O register read data
    .rf_rdata   (rf_rdata_b ),  //  (i) Register file read data
    .sreg       (sreg       ),  //  (i) Status register
    .alu_ro     (alu_ro     ),  //  (i) ALU result
    .alu_zf     (alu_zf     ),  //  (i) ALU zero flag
    .irq        (irq        ),  //  (i) Interrupt request
    .irq_addr   (irq_addr   ),  //  (i) Interrupt vector address
    .sr_if      (sr_if      ),  //  (i) Interrupt flag in status register
    .op_decode  (op_decode  ),  //  (i) Decoded opcodes
    .tim_cyc_end(tim_cyc_end),  //  (i) Timing of cycle termination
    .tim_pc_en  (tim_pc_en  ),  //  (i) Timing of program counter update
    .pc         (pc         ),  //  (o) Program counter
    .pc_new     (pc_new     ),  //  (o) Program counter next value
    .pc_new_en  (pc_new_en  ),  //  (o) Program counter update enable
    .ir         (ir         ),  //  (o) Instruction register
    .ir_2nd     (ir_2nd     ),  //  (o) Instruction 2nd word register
    .cycle      (cycle      ),  //  (o) Cycle counter
    .skip_en    (skip_en    ),  //  (o) Skip enable (operation inhibit)
    .irq_det    (irq_det    ),  //  (o) Interrupt detected (accepted)
    .irq_ret    (irq_ret    )   //  (o) Interrupt returned
);

OpDecode DEC (
    .ir         (ir         ),  //  (i) Instruction word
    .op_decode  (op_decode  )   //  (o) Decoded opcodes
);

TimDecode TIM (
    .ir         (ir         ),  //  (i) Instruction word
    .cycle      (cycle      ),  //  (i) Cycle count
    .skip_en    (skip_en    ),  //  (i) Skip enable (operation inhibit)
    .tim_cyc_end(tim_cyc_end),  //  (o) Timing of cycle termination
    .tim_pc_en  (tim_pc_en  ),  //  (o) Timing of program counter update
    .tim_pm_re  (tim_pm_re  ),  //  (o) Timing of program memory read
    .tim_dm_re  (tim_dm_re  ),  //  (o) Timing of data memory space read
    .tim_dm_we  (tim_dm_we  ),  //  (o) Timing of data memory space write
    .tim_rf_we  (tim_rf_we  ),  //  (o) Timing of register file write
    .tim_sr_en  (tim_sr_en  ),  //  (o) Timing of status register update
    .tim_sp_en  (tim_sp_en  )   //  (o) Timing of stack pointer update
);

//----------------------------------------------------------------------
//  ALU
//----------------------------------------------------------------------
AluInput AIN (
    .ir         (ir         ),  //  (i) Instruction word
    .rf_rdata_a (rf_rdata_a ),  //  (i) Register file Port A data
    .rf_rdata_b (rf_rdata_b ),  //  (i) Register file Port B data
    .sr_cf      (sr_cf      ),  //  (i) Carry flag in status register
    .pc         (pc         ),  //  (i) Program counter
    .ir_2nd     (ir_2nd     ),  //  (i) Instruction 2nd word
    .alu_ai     (alu_ai     ),  //  (o) Operand A
    .alu_bi     (alu_bi     ),  //  (o) Operand B
    .alu_ci     (alu_ci     ),  //  (o) Carry input
    .sel_adc_b  (sel_adc_b  ),  //  (o) Operation ADC(8-bit) enable
    .sel_sbc_b  (sel_sbc_b  ),  //  (o) Operation SBC(8-bit) enable
    .sel_adc_w  (sel_adc_w  ),  //  (o) Operation ADC(16-bit) enable
    .sel_sbc_w  (sel_sbc_w  ),  //  (o) Operation SBC(16-bit) enable
    .sel_and    (sel_and    ),  //  (o) Operation AND enable
    .sel_or     (sel_or     ),  //  (o) Operation OR enable
    .sel_eor    (sel_eor    ),  //  (o) Operation EOR enable
    .sel_asr    (sel_asr    ),  //  (o) Operation ASR enable
    .sel_lsr    (sel_lsr    ),  //  (o) Operation LSR enable
    .sel_ror    (sel_ror    ),  //  (o) Operation ROR enable
    .sel_swap   (sel_swap   ),  //  (o) Operation SWAP enable
    .sel_mul    (sel_mul    ),  //  (o) Operation MUL enable
    .sel_muls   (sel_muls   ),  //  (o) Operation MULS enable
    .sel_mulsu  (sel_mulsu  ),  //  (o) Operation MULSU enable
    .sel_fmul   (sel_fmul   ),  //  (o) Operation FMUL enable
    .sel_fmuls  (sel_fmuls  ),  //  (o) Operation FMULS enable
    .sel_fmulsu (sel_fmulsu )   //  (o) Operation FMULSU enable
);

ALU ALU (
    .ai         (alu_ai     ),  //  (i) Operand A
    .bi         (alu_bi     ),  //  (i) Operand B
    .ci         (alu_ci     ),  //  (i) Carry input
    .op_adc_b   (sel_adc_b  ),  //  (i) Operation ADC(8-bit) enable
    .op_sbc_b   (sel_sbc_b  ),  //  (i) Operation SBC(8-bit) enable
    .op_adc_w   (sel_adc_w  ),  //  (i) Operation ADC(16-bit) enable
    .op_sbc_w   (sel_sbc_w  ),  //  (i) Operation SBC(16-bit) enable
    .op_and     (sel_and    ),  //  (i) Operation AND enable
    .op_or      (sel_or     ),  //  (i) Operation OR enable
    .op_eor     (sel_eor    ),  //  (i) Operation EOR enable
    .op_asr     (sel_asr    ),  //  (i) Operation ASR enable
    .op_lsr     (sel_lsr    ),  //  (i) Operation LSR enable
    .op_ror     (sel_ror    ),  //  (i) Operation ROR enable
    .op_swap    (sel_swap   ),  //  (i) Operation SWAP enable
    .ro         (alu_ro     ),  //  (o) Result output
    .cf         (alu_cf     ),  //  (o) Carry flag
    .zf         (alu_zf     ),  //  (o) Zero flag
    .nf         (alu_nf     ),  //  (o) Negative flag
    .vf         (alu_vf     ),  //  (o) Overflow flag
    .sf         (alu_sf     ),  //  (o) Sign flag
    .hf         (alu_hf     )   //  (o) Half carry flag
);

Multiply MUL (
    .clock      (clock      ),  //  (i) Master clock
    .ai         (alu_ai[7:0]),  //  (i) Operand A
    .bi         (alu_bi[7:0]),  //  (i) Operand B
    .op_mul     (sel_mul    ),  //  (i) Operation MUL enable
    .op_muls    (sel_muls   ),  //  (i) Operation MULS enable
    .op_mulsu   (sel_mulsu  ),  //  (i) Operation MULSU enable
    .op_fmul    (sel_fmul   ),  //  (i) Operation FMUL enable
    .op_fmuls   (sel_fmuls  ),  //  (i) Operation FMULS enable
    .op_fmulsu  (sel_fmulsu ),  //  (i) Operation FMULSU enable
    .ro         (mul_ro     ),  //  (o) Result output
    .cf         (mul_cf     ),  //  (o) Carry flag
    .zf         (mul_zf     )   //  (o) Zero flag
);

BitSetClr BSC (
    .ir         (ir         ),  //  (i) Instruction word
    .io_rdata   (mm_io_rdata),  //  (i) I/O register read data
    .rf_rdata   (rf_rdata_b ),  //  (i) Register file read data
    .sreg       (sreg       ),  //  (i) Status register
    .sr_tf      (sr_tf      ),  //  (i) Transfer bit in status register
    .bsc_ro     (bsc_ro     ),  //  (o) Operation result
    .bst_tf     (bst_tf     )   //  (o) BST instruction transfer bit
);

//----------------------------------------------------------------------
//  Memory Read/Write
//----------------------------------------------------------------------
PmCont PMC (
    .clock      (clock      ),  //  (i) Master clock
    .reset      (reset      ),  //  (i) Active high asynchronous reset
    .pm_rdata   (pm_rdata   ),  //  (i) Program SRAM read data
    .pc         (pc         ),  //  (i) Program counter
    .pc_new     (pc_new     ),  //  (i) Program counter next value
    .pc_new_en  (pc_new_en  ),  //  (i) Program counter update enable
    .cycle      (cycle      ),  //  (i) Cycle counter
    .skip_en    (skip_en    ),  //  (i) Skip enable (operation inhibit)
    .irq_det    (irq_det    ),  //  (i) Interrupt detected (accepted)
    .rf_rdata   (rf_rdata_a ),  //  (i) Register file read data
    .op_decode  (op_decode  ),  //  (i) Decoded opcodes
    .tim_pm_re  (tim_pm_re  ),  //  (i) Timing of program memory read
    .pm_addr    (pm_addr    ),  //  (o) Program SRAM address
    .pm_re      (pm_re      ),  //  (o) Program SRAM read enable
    .pm_we      (pm_we      ),  //  (o) Program SRAM write enable
    .pm_wdata   (pm_wdata   ),  //  (o) Program SRAM write data
    .lpm_data   (lpm_data   ),  //  (o) LPM instruction load data
    .lpm_data_en(lpm_data_en)   //  (o) LPM instruction load data enable
);

DmCont DMC (
    .clock      (clock      ),  //  (i) Master clock
    .reset      (reset      ),  //  (i) Active high asynchronous reset
    .dm_rdata   (dm_rdata   ),  //  (i) Data SRAM read data
    .io_rdata   (io_rdata   ),  //  (i) I/O register read data
    .rf_rdata   (rf_rdata_b ),  //  (i) Register file read data
    .sreg       (sreg       ),  //  (i) Status register
    .sp         (sp         ),  //  (i) Stack pointer
    .sp_pre     (sp_pre     ),  //  (i) Stack pointer pre-incremented value
    .pc         (pc         ),  //  (i) Program counter
    .ir         (ir         ),  //  (i) Instruction register
    .cycle      (cycle      ),  //  (i) Cycle counter
    .alu_ai     (alu_ai     ),  //  (i) ALU operand A
    .alu_ro     (alu_ro     ),  //  (i) ALU result
    .bsc_ro     (bsc_ro     ),  //  (i) Bit set/clear result
    .op_decode  (op_decode  ),  //  (i) Decoded opcodes
    .tim_dm_re  (tim_dm_re  ),  //  (i) Timing of data memory space read
    .tim_dm_we  (tim_dm_we  ),  //  (i) Timing of data memory space write
    .dm_addr    (dm_addr    ),  //  (o) Data SRAM address
    .dm_re      (dm_re      ),  //  (o) Data SRAM read enable
    .dm_we      (dm_we      ),  //  (o) Data SRAM write enable
    .dm_wdata   (dm_wdata   ),  //  (o) Data SRAM write data
    .io_addr    (io_addr    ),  //  (o) I/O register address
    .io_re      (io_re      ),  //  (o) I/O register read enable
    .io_we      (io_we      ),  //  (o) I/O register write enable
    .io_wdata   (io_wdata   ),  //  (o) I/O register write data
    .mm_sp_l_we (mm_sp_l_we ),  //  (o) Stack pointer low byte write enable
    .mm_sp_h_we (mm_sp_h_we ),  //  (o) Stack pointer high byte write enable
    .mm_sreg_we (mm_sreg_we ),  //  (o) Status register write enable
    .mm_io_wdata(mm_io_wdata),  //  (o) Memory mapped I/O write data
    .mm_io_rdata(mm_io_rdata),  //  (o) Memory mapped I/O read data
    .mm_rdata   (mm_rdata   ),  //  (o) Data memory space read data
    .mm_rdata_en(mm_rdata_en)   //  (o) Data memory space read data enable
);

//----------------------------------------------------------------------
//  Register File, Status Register and Stack Pointer
//----------------------------------------------------------------------
RfRead RFR (
    .ir         (ir         ),  //  (i) Instruction word
    .cycle      (cycle      ),  //  (i) Cycle count
    .re_word    (rf_re_word ),  //  (o) Port A word read enable
    .raddr_a    (rf_raddr_a ),  //  (o) Port A read address
    .raddr_b    (rf_raddr_b )   //  (o) Port B read address
);

RfWrite RFW (
    .ir         (ir         ),  //  (i) Instruction word
    .cycle      (cycle      ),  //  (i) Cycle count
    .alu_ro     (alu_ro     ),  //  (i) ALU result
    .mul_ro     (mul_ro     ),  //  (i) Multiplication result
    .bsc_ro     (bsc_ro     ),  //  (i) Bit set/clear result
    .mm_rdata   (mm_rdata   ),  //  (i) Data memory space read data
    .mm_rdata_en(mm_rdata_en),  //  (i) Data memory space read data enable
    .lpm_data   (lpm_data   ),  //  (i) LPM instruction load data
    .lpm_data_en(lpm_data_en),  //  (i) LPM instruction load data enable
    .tim_rf_we  (tim_rf_we  ),  //  (i) Timing of register file write
    .waddr      (rf_waddr   ),  //  (o) Register file write address
    .wdata      (rf_wdata   ),  //  (o) Register file write data
    .we_byte    (rf_we_byte ),  //  (o) Register file byte write enable
    .we_word    (rf_we_word )   //  (o) Register file word write enable
);

RegFile RF (
    .clock      (clock      ),  //  (i) Master clock
    .waddr      (rf_waddr   ),  //  (i) Write address
    .wdata      (rf_wdata   ),  //  (i) Write data
    .we_byte    (rf_we_byte ),  //  (i) Byte write enable
    .we_word    (rf_we_word ),  //  (i) Word write enable
    .re_word    (rf_re_word ),  //  (i) Port A word read enable
    .raddr_a    (rf_raddr_a ),  //  (i) Port A read address
    .raddr_b    (rf_raddr_b ),  //  (i) Port B read address
    .rdata_a    (rf_rdata_a ),  //  (o) Port A read data
    .rdata_b    (rf_rdata_b )   //  (o) Port B read data
);

SregAndSp SAS (
    .clock      (clock      ),  //  (i) Master clock
    .reset      (reset      ),  //  (i) Active high asynchronous reset
    .ir         (ir         ),  //  (i) Instruction word
    .alu_cf     (alu_cf     ),  //  (i) ALU carry flag
    .alu_zf     (alu_zf     ),  //  (i) ALU zero flag
    .alu_nf     (alu_nf     ),  //  (i) ALU negative flag
    .alu_vf     (alu_vf     ),  //  (i) ALU overflow flag
    .alu_sf     (alu_sf     ),  //  (i) ALU sign flag
    .alu_hf     (alu_hf     ),  //  (i) ALU half carry flag
    .mul_cf     (mul_cf     ),  //  (i) Multiplication carry flag
    .mul_zf     (mul_zf     ),  //  (i) Multiplication zero flag
    .bsc_ro     (bsc_ro     ),  //  (i) Bit set/clear result
    .bst_tf     (bst_tf     ),  //  (i) BST instruction transfer bit
    .mm_sp_l_we (mm_sp_l_we ),  //  (i) Stack pointer low byte write enable
    .mm_sp_h_we (mm_sp_h_we ),  //  (i) Stack pointer high byte write enable
    .mm_sreg_we (mm_sreg_we ),  //  (i) Status register write enable
    .mm_io_wdata(mm_io_wdata),  //  (i) Memory mapped I/O write data
    .irq_det    (irq_det    ),  //  (i) Interrupt detected (accepted)
    .irq_ret    (irq_ret    ),  //  (i) Interrupt returned
    .op_decode  (op_decode  ),  //  (i) Decoded opcodes
    .tim_sr_en  (tim_sr_en  ),  //  (i) Timing of status register update
    .tim_sp_en  (tim_sp_en  ),  //  (i) Timing of stack pointer update
    .sp         (sp         ),  //  (o) Stack pointer
    .sp_pre     (sp_pre     ),  //  (o) Stack pointer pre-incremented value
    .sreg       (sreg       ),  //  (o) Status register
    .sr_cf      (sr_cf      ),  //  (o) Status register carry flag
    .sr_tf      (sr_tf      ),  //  (o) Status register transfer bit
    .sr_if      (sr_if      )   //  (o) Status register interrupt flag
);

endmodule

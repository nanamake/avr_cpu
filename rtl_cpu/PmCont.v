//----------------------------------------------------------------------
//  PmCont: Program Memory Read/Write Control
//----------------------------------------------------------------------
module  PmCont (
    input               clock,      //  Master clock
    input               reset,      //  Active high asynchronous reset
    input       [15:0]  pm_rdata,   //  Program SRAM read data
    input       [15:0]  pc,         //  Program counter
    input       [15:0]  pc_new,     //  Program counter next value
    input               pc_new_en,  //  Program counter update enable
    input       [1:0]   cycle,      //  Cycle counter
    input               skip_en,    //  Skip enable (operation inhibit)
    input               irq_det,    //  Interrupt detected (accepted)
    input       [15:0]  rf_rdata,   //  Register file read data
    input       [0:82]  op_decode,  //  Decoded opcodes
    input               tim_pm_re,  //  Timing of program memory read
    output  reg [15:0]  pm_addr,    //  Program SRAM address
    output  reg         pm_re,      //  Program SRAM read enable
    output  reg         pm_we,      //  Program SRAM write enable
    output  reg [15:0]  pm_wdata,   //  Program SRAM write data
    output      [7:0]   lpm_data,   //  LPM instruction load data
    output              lpm_data_en //  LPM instruction load data enable
);

//----------------------------------------------------------------------
//  Internal Nets
//----------------------------------------------------------------------
wire[15:0]  pm_addr_new;
wire[15:0]  pm_addr_xpm;
wire        pm_re_lpm;
wire        pm_wd_spm;
wire        pm_wa_spm;
wire        pm_pc_xpm;
wire        pm_re_new;
wire        pm_wd_new;
reg         lpm_re_l;
reg         lpm_re_h;

//  Decoded Opcode Renaming
`include "OpNumber.v"
wire    op_lpm    = op_decode[B_LPM   ];//  1001010111001000    LPM
wire    op_lpmz   = op_decode[B_LPMZ  ];//  1001000ddddd0100    LPM  Rd,Z
wire    op_lpmzi  = op_decode[B_LPMZI ];//  1001000ddddd0101    LPM  Rd,Z+
wire    op_spm    = op_decode[B_SPM   ];//  1001010111101000    SPM

//----------------------------------------------------------------------
//  CPU External Outputs
//----------------------------------------------------------------------
always @(posedge clock or posedge reset) begin
    if (reset) begin
        pm_addr <= 16'h0000;
        pm_re <= 1'b0;
        pm_we <= 1'b0;
        pm_wdata <= 16'h0000;
    end else begin
        pm_addr <= (pm_re_new | pm_wa_spm) ? pm_addr_new : pm_addr;
        pm_re <= pm_re_new;
        pm_we <= pm_wa_spm;
        pm_wdata <= pm_wd_new ? rf_rdata : pm_wdata;
    end
end

assign  pm_addr_new = pc_new_en ? pc_new : pm_addr_xpm;

assign  pm_addr_xpm = (pm_re_lpm ? {1'b0, rf_rdata[15:1]} : 16'h0000)
                    | (pm_wa_spm ? rf_rdata               : 16'h0000)
                    | (pm_pc_xpm ? pc                     : 16'h0000);

assign  pm_re_lpm   = (op_lpm   & (cycle == 2'd0))
                    | (op_lpmz  & (cycle == 2'd0))
                    | (op_lpmzi & (cycle == 2'd0));

assign  pm_wd_spm   = (op_spm & (cycle == 2'd0));
assign  pm_wa_spm   = (op_spm & (cycle == 2'd1));

assign  pm_pc_xpm   = (op_lpm   & (cycle == 2'd1))
                    | (op_lpmz  & (cycle == 2'd1))
                    | (op_lpmzi & (cycle == 2'd1))
                    | (op_spm   & (cycle == 2'd2));

assign  pm_re_new = (tim_pm_re | skip_en) & ~irq_det;
assign  pm_wd_new = pm_wd_spm & ~skip_en;

//----------------------------------------------------------------------
//  CPU Internal Outputs
//----------------------------------------------------------------------
always @(posedge clock) begin
    lpm_re_l <= pm_re_lpm & ~rf_rdata[0] & ~skip_en;
    lpm_re_h <= pm_re_lpm &  rf_rdata[0] & ~skip_en;
end

assign  lpm_data = (lpm_re_l ? pm_rdata[7:0]  : 8'h00)
                 | (lpm_re_h ? pm_rdata[15:8] : 8'h00);

assign  lpm_data_en = lpm_re_l | lpm_re_h;

endmodule

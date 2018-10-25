//----------------------------------------------------------------------
//  MCU: MCU Dummy for CPU Core
//----------------------------------------------------------------------
module  MCU (
    input           clock,      //  Master clock
    input           reset,      //  Active high asynchronous reset
    input           irq,        //  Interrupt request
    input   [15:0]  irq_addr,   //  Interrupt vector address
    output  [7:0]   ext_out     //  External output dummy
);

//  Internal nets
wire[15:0]  pm_rdata;
wire[15:0]  pm_addr;
wire        pm_re;
wire        pm_we;
wire[15:0]  pm_wdata;
wire[7:0]   dm_rdata;
wire[15:0]  dm_addr;
wire        dm_re;
wire        dm_we;
wire[7:0]   dm_wdata;
wire[7:0]   io_rdata;
wire[7:0]   io_addr;
wire        io_re;
wire        io_we;
wire[7:0]   io_wdata;
reg         i_irq;
reg [15:0]  i_irq_addr;

CPU CPU (
    .clock      (clock      ),  //  (i) Master clock
    .reset      (reset      ),  //  (i) Active high asynchronous reset
    .pm_rdata   (pm_rdata   ),  //  (i) Program SRAM read data
    .pm_addr    (pm_addr    ),  //  (o) Program SRAM address
    .pm_re      (pm_re      ),  //  (o) Program SRAM read enable
    .pm_we      (pm_we      ),  //  (o) Program SRAM write enable
    .pm_wdata   (pm_wdata   ),  //  (o) Program SRAM write data
    .dm_rdata   (dm_rdata   ),  //  (i) Data SRAM read data
    .dm_addr    (dm_addr    ),  //  (o) Data SRAM address
    .dm_re      (dm_re      ),  //  (o) Data SRAM read enable
    .dm_we      (dm_we      ),  //  (o) Data SRAM write enable
    .dm_wdata   (dm_wdata   ),  //  (o) Data SRAM write data
    .io_rdata   (io_rdata   ),  //  (i) I/O register read data
    .io_addr    (io_addr    ),  //  (o) I/O register address
    .io_re      (io_re      ),  //  (o) I/O register read enable
    .io_we      (io_we      ),  //  (o) I/O register write enable
    .io_wdata   (io_wdata   ),  //  (o) I/O register write data
    .irq        (i_irq      ),  //  (i) Interrupt request
    .irq_addr   (i_irq_addr )   //  (i) Interrupt vector address
);

//  Program SRAM
RAM #(.AW(14),.DW(16)) PM (
    .clock      (~clock     ),  //  (i)
    .addr       (pm_addr[13:0]),//  (i)
    .we         (pm_we      ),  //  (i)
    .wdata      (pm_wdata   ),  //  (i)
    .rdata      (pm_rdata   )   //  (o)
);

//  Data SRAM
RAM #(.AW(11),.DW(8)) DM (
    .clock      (~clock     ),  //  (i)
    .addr       (dm_addr[10:0]),//  (i)
    .we         (dm_we      ),  //  (i)
    .wdata      (dm_wdata   ),  //  (i)
    .rdata      (dm_rdata   )   //  (o)
);

//  I/O register dummy
IoReg IOR (
    .clock      (clock      ),  //  (i)
    .reset      (reset      ),  //  (i)
    .addr       (io_addr    ),  //  (i)
    .we         (io_we      ),  //  (i)
    .wdata      (io_wdata   ),  //  (i)
    .rdata      (io_rdata   ),  //  (o)
    .ext_out    (ext_out    )   //  (o)
);

//  Interrupt dummy
always @(posedge clock or posedge reset) begin
    if (reset) begin
        i_irq <= 1'b0;
        i_irq_addr <= 16'h0000;
    end else begin
        i_irq <= irq;
        i_irq_addr <= irq_addr;
    end
end

endmodule

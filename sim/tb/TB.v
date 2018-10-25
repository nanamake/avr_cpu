//----------------------------------------------------------------------
//  TB: Testbench for AVR Compatible CPU
//----------------------------------------------------------------------
`timescale 1ns/1ns
module TB;

`ifdef VERIFY
    localparam  VERIFY = 1;
`else
    localparam  VERIFY = 0;
`endif

//  CPU Inputs and Outputs
reg         clock;
reg         reset;
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
reg         irq;
reg [15:0]  irq_addr;

//----------------------------------------------------------------------
//  DUT Instances
//----------------------------------------------------------------------
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
    .irq        (irq        ),  //  (i) Interrupt request
    .irq_addr   (irq_addr   )   //  (i) Interrupt vector address
);

//  Program SRAM
wire    i_pm_we = pm_we & (pm_addr[15:10] == 6'h00);

RAM #(.AW(10),.DW(16)) PM (
    .clock      (~clock     ),  //  (i)
    .addr       (pm_addr[9:0]), //  (i)
    .we         (i_pm_we    ),  //  (i)
    .wdata      (pm_wdata   ),  //  (i)
    .rdata      (pm_rdata   )   //  (o)
);

//  Data SRAM
wire    i_dm_we = dm_we & (dm_addr[15:10] == 6'h00);

RAM #(.AW(10),.DW(8)) DM (
    .clock      (~clock     ),  //  (i)
    .addr       (dm_addr[9:0]), //  (i)
    .we         (i_dm_we    ),  //  (i)
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
    .ext_out    (           )   //  (o)
);

//----------------------------------------------------------------------
//  Processing for DUT Inputs
//----------------------------------------------------------------------
always begin
    clock = 0; #10;
    clock = 1; #10;
end

initial begin
    reset = 0; #20;
    reset = 1; #100;
    reset = 0;
end

initial begin
    irq = 0;
    irq_addr = 0;
end

//  Load program code to memory
initial begin
    $readmemh("PM.dat", PM.mem);
end

//----------------------------------------------------------------------
//  Processing for DUT Outputs
//----------------------------------------------------------------------
// Finish simulation
reg     sim_end;
initial begin
    sim_end = 0;
    forever @(negedge clock) begin
        if ((dm_addr == 16'hfeff) & dm_we & (dm_wdata == 8'hff)) begin
            sim_end = 1;
        end
    end
end
initial begin
    wait (sim_end);
    #100;
    save_data_memory;
    if (VERIFY) verify_data_memory;
    $finish;
end

//  Save data memory contents
task save_data_memory;
    integer     fp;
    reg [15:0]  i;
begin
    fp = $fopen("DM.dat", "w");
    for (i = 0; i < 2**10; i = i + 1) begin
        if (i % 16 ==  0)   $fwrite(fp, "@%h", i);
        if (i %  4 ==  0)   $fwrite(fp, " ");
                            $fwrite(fp, " %h", DM.mem[i]);
        if (i % 16 == 15)   $fwrite(fp, "\n");
    end
    $fclose(fp);
end
endtask

//  Verify data memory contents
task verify_data_memory;
    reg [15:0]  i;
    reg         ng;
begin
    $readmemh("DM_exp.dat", DM_exp.mem);
    ng = 0;
    for (i = 0; i < 2**10; i = i + 1) begin
        if (DM.mem[i] !== DM_exp.mem[i]) begin
            ng = 1;
            $display("NG: @%h act=%h exp=%h", i, DM.mem[i], DM_exp.mem[i]);
        end
    end
    if (ng) $display("[FAILED] RAM contents not matched.");
    else    $display("[PASSED] All RAM contents matched.");
end
endtask

//  Data SRAM expected contents
RAM #(.AW(10),.DW(8)) DM_exp (
    .clock  (1'b0   ),  //  (i)
    .addr   (10'h000),  //  (i)
    .we     (1'b0   ),  //  (i)
    .wdata  (8'h00  ),  //  (i)
    .rdata  (       )   //  (o)
);

//----------------------------------------------------------------------
//  Testbench Control
//----------------------------------------------------------------------
`include "stim.v"

endmodule

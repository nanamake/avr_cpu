//----------------------------------------------------------------------
//  Testbench Stimuli for Interrupt/RETI
//----------------------------------------------------------------------
localparam  VECT1 = 16'h0002;
localparam  VECT2 = 16'h0004;
localparam  HAND1 = 16'h0110;
localparam  HAND2 = 16'h0220;

initial begin: STIM
    //  Interrupt request #1
    wait (dm_we & (dm_addr == 16'h0000));
    irq <= 1;
    irq_addr <= VECT1;
    wait (pm_addr == HAND1);
    irq <= 0;

    //  Interrupt request #2
    wait (dm_we & (dm_addr == 16'h0001));
    @(posedge clock);
    irq <= 1;
    irq_addr <= VECT2;
    wait (pm_addr == HAND2);
    irq <= 0;

    //  Continuous interrupt request
    wait (dm_we & (dm_addr == 16'h0010));
    repeat(2) @(posedge clock);
    irq <= 1;
    irq_addr <= VECT1;
    wait (pm_addr == HAND1);
    irq_addr <= VECT2;
    wait (pm_addr == HAND2);
    irq <= 0;
end
initial begin
    repeat(1000) #20;
    $display("[FAILED] Simulation timed out.");
    save_data_memory;
    $finish;
end

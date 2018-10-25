//----------------------------------------------------------------------
//  Testbench Stimuli for Skip Enable
//----------------------------------------------------------------------
localparam  VECT1 = 16'h0002;
localparam  HAND1 = 16'h0110;

initial begin: STIM
    //  Interrupt request #1
    wait (dm_we & (dm_addr == 16'h0000));
    @(posedge clock);
    irq <= 1;
    irq_addr <= VECT1;
    wait (pm_addr == HAND1);
    irq <= 0;
end
initial begin
    repeat(1000) #20;
    $display("[FAILED] Simulation timed out.");
    save_data_memory;
    $finish;
end

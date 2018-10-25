//----------------------------------------------------------------------
//  Testbench Default Stimuli
//----------------------------------------------------------------------
defparam CPU.AIN.DC = 1'bx;
defparam CPU.RFR.DC = 1'bx;
defparam CPU.RFW.DC = 1'bx;

initial begin: STIM
end
initial begin
    repeat(1000) #20;
    $display("[FAILED] Simulation timed out.");
    save_data_memory;
    $finish;
end

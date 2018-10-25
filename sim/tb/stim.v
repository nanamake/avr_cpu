//----------------------------------------------------------------------
//  Testbench Default Stimuli
//----------------------------------------------------------------------
initial begin: STIM
end
initial begin
    repeat(1000) #20;
    $display("[FAILED] Simulation timed out.");
    save_data_memory;
    $finish;
end

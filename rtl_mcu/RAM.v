//----------------------------------------------------------------------
//  RAM: Single-Port Synchronous RAM
//----------------------------------------------------------------------
module RAM #(
    parameter   AW = 10,    //  Address width
    parameter   DW = 8      //  Data width
)(
    input                   clock,
    input       [AW-1:0]    addr,
    input                   we,
    input       [DW-1:0]    wdata,
    output  reg [DW-1:0]    rdata
);

reg [DW-1:0]    mem[0:2**AW-1];

always @(posedge clock) begin
    if (we) begin
        mem[addr] <= wdata;
    end
    rdata <= mem[addr];
end

endmodule

//----------------------------------------------------------------------
//  DmAdConv: Convert Logical Address to Physical Address
//----------------------------------------------------------------------
module  DmAdConv (
    input   [15:0]  mm_addr,    //  Memory mapped address
    input           mm_en,      //  Memory mapping enable
    output  [15:0]  dm_addr,    //  Data SRAM address
    output          dm_en,      //  Data SRAM enable
    output  [7:0]   io_addr,    //  I/O register address
    output          io_en       //  I/O register enable
);

wire    dm_bo;
wire    io_bo;

assign  {dm_bo, dm_addr} = mm_addr - 16'h100;
assign  dm_en = mm_en & ~dm_bo;

assign  {io_bo, io_addr} = mm_addr[7:0] - 8'h20;
assign  io_en = mm_en & dm_bo & ~io_bo;

endmodule

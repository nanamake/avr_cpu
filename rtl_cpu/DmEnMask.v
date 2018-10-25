//----------------------------------------------------------------------
//  DmEnMask: Mask I/O Enable with Internal Register Enable
//----------------------------------------------------------------------
module  DmEnMask (
    input   [7:0]   io_addr,    //  I/O register address
    input           io_en_i,    //  I/O register enable
    output          io_en_o,    //  Masked I/O register enable
    output          sp_l_en,    //  Stack pointer low byte enable
    output          sp_h_en,    //  Stack pointer high byte enable
    output          sreg_en     //  Status register enable
);

assign  sp_l_en = io_en_i & (io_addr[7:0] == 8'h3d);
assign  sp_h_en = io_en_i & (io_addr[7:0] == 8'h3e);
assign  sreg_en = io_en_i & (io_addr[7:0] == 8'h3f);

assign  io_en_o = io_en_i & ~sp_l_en & ~sp_h_en & ~sreg_en;

endmodule

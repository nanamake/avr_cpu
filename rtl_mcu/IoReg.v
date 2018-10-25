//----------------------------------------------------------------------
//  IoReg: I/O Register Dummy
//----------------------------------------------------------------------
module  IoReg (
    input               clock,      //  Master clock
    input               reset,      //  Active high asynchronous reset
    input       [7:0]   addr,       //  I/O register address
    input               we,         //  I/O register write enable
    input       [7:0]   wdata,      //  I/O register write data
    output      [7:0]   rdata,      //  I/O register read data
    output      [7:0]   ext_out     //  External output dummy
);

//  Internal nets
wire        dec_00;
wire        dec_01;
wire        dec_02;
wire        dec_1f;
wire        dec_3c;
wire        dec_7e;
wire        dec_7f;
wire        dec_80;
wire        dec_81;
reg [7:0]   reg_00;
reg [7:0]   reg_01;
reg [7:0]   reg_02;
reg [7:0]   reg_1f;
reg [7:0]   reg_3c;
reg [7:0]   reg_7e;
reg [7:0]   reg_7f;
reg [7:0]   reg_80;
reg [7:0]   reg_81;

//  Register dummy
assign  dec_00 = (addr == 8'h00);
assign  dec_01 = (addr == 8'h01);
assign  dec_02 = (addr == 8'h02);
assign  dec_1f = (addr == 8'h1f);
assign  dec_3c = (addr == 8'h3c);
assign  dec_7e = (addr == 8'h7e);
assign  dec_7f = (addr == 8'h7f);
assign  dec_80 = (addr == 8'h80);
assign  dec_81 = (addr == 8'h81);

always @(posedge clock or posedge reset) begin
    if (reset) begin
        reg_00 <= 8'h00;
        reg_01 <= 8'h00;
        reg_02 <= 8'h00;
        reg_1f <= 8'h00;
        reg_3c <= 8'h00;
        reg_7e <= 8'h00;
        reg_7f <= 8'h00;
        reg_80 <= 8'h00;
        reg_81 <= 8'h00;
    end else begin
        reg_00 <= (we & dec_00) ? wdata : reg_00;
        reg_01 <= (we & dec_01) ? wdata : reg_01;
        reg_02 <= (we & dec_02) ? wdata : reg_02;
        reg_1f <= (we & dec_1f) ? wdata : reg_1f;
        reg_3c <= (we & dec_3c) ? wdata : reg_3c;
        reg_7e <= (we & dec_7e) ? wdata : reg_7e;
        reg_7f <= (we & dec_7f) ? wdata : reg_7f;
        reg_80 <= (we & dec_80) ? wdata : reg_80;
        reg_81 <= (we & dec_81) ? wdata : reg_81;
    end
end

assign  rdata = (dec_00 ? reg_00 : 8'h00)
              | (dec_01 ? reg_01 : 8'h00)
              | (dec_02 ? reg_02 : 8'h00)
              | (dec_1f ? reg_1f : 8'h00)
              | (dec_3c ? reg_3c : 8'h00)
              | (dec_7e ? reg_7e : 8'h00)
              | (dec_7f ? reg_7f : 8'h00)
              | (dec_80 ? reg_80 : 8'h00)
              | (dec_81 ? reg_81 : 8'h00);

//  External output dummy
assign  ext_out = reg_00;

endmodule

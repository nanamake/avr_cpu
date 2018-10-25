//----------------------------------------------------------------------
//  RegFile: Register File for AVR Compatible CPU
//----------------------------------------------------------------------
module  RegFile (
    input           clock,      //  Master clock
    input   [4:0]   waddr,      //  Write address
    input   [15:0]  wdata,      //  Write data
    input           we_byte,    //  Byte write enable
    input           we_word,    //  Word write enable
    input           re_word,    //  Port A word read enable
    input   [4:0]   raddr_a,    //  Port A read address
    input   [4:0]   raddr_b,    //  Port B read address
    output  [15:0]  rdata_a,    //  Port A read data
    output  [7:0]   rdata_b     //  Port B read data
);

//  Internal nets
reg [7:0]   regf[0:31];
wire        we_l;
wire        we_h;
wire[4:0]   waddr_l;
wire[4:0]   waddr_h;
wire[4:0]   raddr_a_l;
wire[4:0]   raddr_a_h;
wire[7:0]   rdata_a_l;
wire[7:0]   rdata_a_h;

//  Register write
assign  we_l = we_word | (we_byte & (waddr[0] == 1'b0));
assign  we_h = we_word | (we_byte & (waddr[0] == 1'b1));

assign  waddr_l = {waddr[4:1], 1'b0};
assign  waddr_h = {waddr[4:1], 1'b1};

always @(posedge clock) begin
    if (we_l) begin
        regf[waddr_l] <= wdata[7:0];
    end
    if (we_h) begin
        regf[waddr_h] <= we_word ? wdata[15:8] : wdata[7:0];
    end
end

//  Port A read
assign  raddr_a_l = {raddr_a[4:1], 1'b0};
assign  raddr_a_h = {raddr_a[4:1], 1'b1};

assign  rdata_a_l = regf[raddr_a_l];
assign  rdata_a_h = regf[raddr_a_h];

assign  rdata_a = re_word              ? {rdata_a_h, rdata_a_l}
                : (raddr_a[0] == 1'b0) ? {8'h00, rdata_a_l}
                :                        {8'h00, rdata_a_h};

//  Port B read
assign  rdata_b = regf[raddr_b];

endmodule

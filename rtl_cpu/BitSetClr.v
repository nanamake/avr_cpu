//----------------------------------------------------------------------
//  BitSetClr: Bit Set/Clear and Bit Load/Store Operation
//----------------------------------------------------------------------
module  BitSetClr (
    input       [15:0]  ir,         //  Instruction word
    input       [7:0]   io_rdata,   //  I/O register read data
    input       [7:0]   rf_rdata,   //  Register file read data
    input       [7:0]   sreg,       //  Status register
    input               sr_tf,      //  Transfer bit in status register
    output  reg [7:0]   bsc_ro,     //  Operation result
    output  reg         bst_tf      //  BST instruction transfer bit
);

`include "OpDefine.v"
always @* begin
    bsc_ro = 8'h00;
    bst_tf = 1'b0;
    casex (ir)
    //--------------------------------------------------
    //  Bit and Bit-test Instructions
    //--------------------------------------------------
    C_SBI    :  //  10011010AAAAAbbb    SBI  A,b
                begin
                    bsc_ro = io_rdata;
                    bsc_ro[ir[2:0]] = 1'b1;
                end
    C_CBI    :  //  10011000AAAAAbbb    CBI  A,b
                begin
                    bsc_ro = io_rdata;
                    bsc_ro[ir[2:0]] = 1'b0;
                end
    C_BST    :  //  1111101ddddd0bbb    BST  Rd,b
                begin
                    bst_tf = rf_rdata[ir[2:0]];
                end
    C_BLD    :  //  1111100ddddd0bbb    BLD  Rd,b
                begin
                    bsc_ro = rf_rdata;
                    bsc_ro[ir[2:0]] = sr_tf;
                end
    C_BSET   :  //  100101000sss1000    BSET s
                begin
                    bsc_ro = sreg;
                    bsc_ro[ir[6:4]] = 1'b1;
                end
    C_BCLR   :  //  100101001sss1000    BCLR s
                begin
                    bsc_ro = sreg;
                    bsc_ro[ir[6:4]] = 1'b0;
                end
    default  :
                begin
                    bsc_ro = 8'h00;
                    bst_tf = 1'b0;
                end
    endcase
end

endmodule

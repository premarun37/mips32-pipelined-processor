module regdst_mux (
    input  [4:0] rt,
    input  [4:0] rd,
    input        regdst,
    output [4:0] writereg
);

    assign writereg = regdst ? rd : rt;

endmodule

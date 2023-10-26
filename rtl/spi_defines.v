`define SPI_DIVIDER_LEN_8
// `define SPI_DIVIDER_LEN_16
// `define SPI_DIVIDER_LEN_24
// `define SPI_DIVIDER_LEN_32

`ifdef SPI_DIVIDER_LEN_8
    `define SPI_DIVIDER_LEN         4
`endif
`ifdef SPI_DIVIDER_LEN_16
    `define SPI_DIVIDER_LEN         16
`endif
`ifdef SPI_DIVIDER_LEN_24
    `define SPI_DIVIDER_LEN         24
`endif
`ifdef SPI_DIVIDER_LEN_32
    `define SPI_DIVIDER_LEN         32
`endif


//max no of bits that can be sent or recieved at one is defined by SPI_MAX_CHAR

// `define SPI_MAX_CHAR_128
// `define SPI_MAX_CHAR_64
// `define SPI_MAX_CHAR_32
// `define SPI_MAX_CHAR_24
// `define SPI_MAX_CHAR_16
`define SPI_MAX_CHAR_8

`ifdef SPI_MAX_CHAR_128
    `define SPI_MAX_CHAR            128
    `define SPI_CHAR_LEN_BITS       7
`endif
`ifdef SPI_MAX_CHAR_64
    `define SPI_MAX_CHAR            64
    `define SPI_CHAR_LEN_BITS       6
`endif
`ifdef SPI_MAX_CHAR_32
    `define SPI_MAX_CHAR            32
    `define SPI_CHAR_LEN_BITS       5
`endif
`ifdef SPI_MAX_CHAR_24
    `define SPI_MAX_CHAR            24
    `define SPI_CHAR_LEN_BITS       5
`endif
`ifdef SPI_MAX_CHAR_16
    `define SPI_MAX_CHAR            16
    `define SPI_CHAR_LEN_BITS       4
`endif
`ifdef SPI_MAX_CHAR_8
    `define SPI_MAX_CHAR            8
    `define SPI_CHAR_LEN_BITS       3
`endif


//no of slave select signals using SPI_SS_NB

`define SPI_SS_NB_8
// `define SPI_SS_NB_16
// `define SPI_SS_NB_24
// `define SPI_SS_NB_32

`ifdef SPI_SS_NB_8
    `define SPI_SS_NB               8
`endif
`ifdef SPI_SS_NB_12
    `define SPI_SS_NB               16
`endif
`ifdef SPI_SS_NB_24
    `define SPI_SS_NB               24
`endif
`ifdef SPI_SS_NB_32
    `define SPI_SS_NB               32
`endif


//bits of wishbone address used for partial decoding SPI registers

`define SPI_RX_0        5'b00000
`define SPI_RX_1        5'b00100
`define SPI_RX_2        5'b01000
`define SPI_RX_3        5'b01100
`define SPI_TX_0        5'b00000
`define SPI_TX_1        5'b00100
`define SPI_TX_2        5'b01000
`define SPI_TX_3        5'b01100
`define SPI_CTRL        5'b10000
`define SPI_DIVIDE      5'b10100
`define SPI_SS          5'b11000

//control register

`define SPI_CTRL_BIT_NB     14

`define SPI_CTRL_ASS        13
`define SPI_CTRL_IE         12
`define SPI_CTRL_LSB        11
`define SPI_CTRL_TX_NEGEDGE 10
`define SPI_CTRL_RX_NEGEDGE 9
`define SPI_CTRL_GO         8
`define SPI_CTRL_RES_1      7
`define SPI_CTRL_CHAR_LEN   6:0

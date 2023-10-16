`include "spi_defines.v"

module spi_top(
    wb_clk_in,
    wb_rst_in,
    wb_adr_in,
    wb_dat_o,
    wb_sel_in,
    wb_we_in,
    wb_stb_in,
    wb_cyc_in,
    wb_ack_out,
    wb_int_o,
    wb_dat_in,
    ss_pad_o,
    sclk_out,
    mosi,
    miso);
    
    input wb_clk_in, wb_rst_in, wb_we_in, wb_stb_in, wb_cyc_in, miso;

    input [4:0] wb_adr_in;
    input [31:0] wb_dat_in;
    input [3:0] wb_sel_in;

    output reg [31:0] wb_dat_o;
    output wb_ack_out, wb_int_o, sclk_out, mosi;
    reg wb_ack_out, wb_int_o;

    output [`SPI_SS_NB - 1 : 0] ss_pad_o;

    wire rx_negedge, tx_negedge, go, ie, ass, lsb, cpol_0, cpol_1, last, tip,
         spi_divider_sel, spi_ctrl_sel, spi_ss_sel;
    
    wire [3:0] spi_tx_sel;
    wire [`SPI_CHAR_LEN_BITS - 1 : 0] char_len;
    wire [`SPI_MAX_CHAR - 1: 0] rx;

    reg [`SPI_DIVIDER_LEN - 1 : 0] divider;
    reg [31:0] wb_temp_dat;
    reg [`SPI_CTRL_BIT_NB - 1 : 0] ctrl;
    reg [`SPI_SS_NB -1 : 0] ss;

    spi_clgen SC (wb_clk_in,
                  wb_rst_in,
                  go,
                  tip,
                  last,
                  divider,
                  sclk_out,
                  cpol_0,
                  cpol_1);

    spi_shift_reg SR (rx_negedge,
                      tx_negedge,
                      wb_sel_in,
                      (spi_tx_sel[3:0] & {4{wb_we_in}})
                      char_len,
                      wb_dat_in,
                      wb_clk_in,
                      wb_rst_in,
                      go,
                      miso,
                      lsb,
                      sclk_out,
                      cpol_0,
                      cpol_1,
                      rx,
                      last,
                      mosi,
                      tip);

    assign spi_divider_sel = wb_cyc_in & wb_stb_in & (wb_adr_in == (5'b10100));
    assign spi_ctrl_sel = wb_cyc_in & wb_stb_in & (wb_adr_in == (5'b10000));
    assign spi_ss_sel = wb_cyc_in & wb_stb_in & (wb_adr_in == (5'b11000));
    assign spi_tx_sel[0] = wb_cyc_in & wb_stb_in & (wb_adr_in == (5'b00000));
    assign spi_tx_sel[1] = wb_cyc_in & wb_stb_in & (wb_adr_in == (5'b00100));
    assign spi_tx_sel[2] = wb_cyc_in & wb_stb_in & (wb_adr_in == (5'b01000));
    assign spi_tx_sel[3] = wb_cyc_in & wb_stb_in & (wb_adr_in == (5'b01100));

    always @(*) begin
        case (wb_adr_in)
            `ifdef SPI_MAX_CHAR_128
                `SPI_RX_0 : wb_temp_dat = rx[31:0];
                `SPI_RX_1 : wb_temp_dat = rx[63:32];
                `SPI_RX_2 : wb_temp_dat = rx[95:64];
                `SPI_RX_3 : wb_temp_dat = rx[127:96];

            `else
                `ifdef SPI_MAX_CHAR_64
                    `SPI_RX_0 : wb_temp_dat = rx[31:0];
                    `SPI_RX_1 : wb_temp_dat = rx[63:32];
                    `SPI_RX_2 : wb_temp_dat = 32'b0;
                    `SPI_RX_3 : wb_temp_dat = 32'b0;
                `else  
                    `SPI_RX_0 : wb_temp_dat = rx[`SPI_MAX_CHAR - 1 :0];
                    `SPI_RX_1 : wb_temp_dat = 32'b0;
                    `SPI_RX_2 : wb_temp_dat = 32'b0;
                    `SPI_RX_3 : wb_temp_dat = 32'b0;
                `endif 
            `endif
            `SPI_CTRL : wb_temp_dat = ctrl;
            `SPI_DIVIDE : wb_temp_dat = divider;
            `SPI_SS : wb_temp_dat = ss;
            default : wb_temp_dat = 32'dx;
        endcase
    end

    always @(posedge wb_clk_in or posedge wb_rst_in) begin
        if (wb_rst_in) begin
            wb_dat_o <= 32'd0;
        end
        else begin
                wb_dat_in <= wb_temp_dat;
        end
    end

    always @(posedge wb_clk_in or posedge wb_rst_in) begin
        if(wb_rst_in) begin
            wb_ack_out <= 0;
        end
        else begin
            wb_ack_out <= wb_cyc_in & wb_stb_in & ~wb_ack_out;
        end
    end

    always @(posedge wb_clk_in or posedge wb_rst_in) begin
        if (wb_rst_in) begin
            wb_int_o <= 1'b0;
        end
        else if (ie && tip && last && cpol_0) begin
            wb_int_o <= 1'b1;
        end
        else if (wb_ack_out) begin
            wb_int_o <= 1'b0;
        end
    end


    assign ss_pad_o = ~((ss & {`SPI_SS_NB{tip & ass}}) | (ss & {`SPI_SS_NB{!ass}}));

    always @(posedge wb_clk_in or posedge wb_rst_in) begin
        if (wb_rst_in) begin
            divider <= 0;
        end
        else if (spi_divider_sel && wb_we_in && !tip) begin
            `ifdef SPI_DIVIDER_LEN_8
                if (wb_sel_in[0]) begin
                    divider <= wb_dat_in[`SPI_DIVIDER_LEN - 1 : 0];
                end
            `endif
            `ifdef SPI_DIVIDER_LEN_16
                if (wb_sel_in[0]) begin
                    divider[7:0] <= wb_dat_in[7:0];
                end
                if (wb_sel_in[1]) begin
                    divider[15:8] <= wb_dat_in[`SPI_DIVIDER_LEN - 1 : 8];
                end
            `endif
            `ifdef SPI_DIVIDER_LEN_24
                if (wb_sel_in[0]) begin
                    divider[7:0] <= wb_dat_in[7:0];
                end
                if (wb_sel_in[1]) begin
                    divider[15:8] <= wb_dat_in[15: 8];
                end
                if (wb_sel_in[2]) begin
                    divider[23:16] <= wb_dat_in[`SPI_DIVIDER_LEN - 1 : 16];
                end
            `endif
            `ifdef SPI_DIVIDER_LEN_32
                if (wb_sel_in[0]) begin
                    divider[7:0] <= wb_dat_in[7:0];
                end
                if (wb_sel_in[1]) begin
                    divider[15:8] <= wb_dat_in[15: 8];
                end
                if (wb_sel_in[2]) begin
                    divider[23:16] <= wb_dat_in[23: 16];
                end
                if (wb_sel_in[3]) begin
                    divider[31:24] <= wb_dat_in[`SPI_DIVIDER_LEN - 1 : 24];
                end
            `endif
        end
    end

    always @(posedge wb_clk_in or posedge wb_rst_in) begin
        if (wb_rst_in) begin
            ctrl <= 0;
        end
        else begin
            if (spi_ctrl_sel && wb_we_in && !tip) begin
                if (wb_sel_in[0]) begin
                    ctrl[7:0] <= wb_dat_in[7:0] | {7'd0, ctrl[0]};
                end
                if (wb_sel_in[1]) begin
                    ctrl[`SPI_CTRL_BIT_NB - 1 :0] <= wb_dat_in[`SPI_CTRL_BIT_NB -1 : 0];
                end
            end
            else if (tip && last && cpol_0) begin
                    ctrl[`SPI_CTRL_GO] <= 1'b0;
            end
        end
    end

    assign rx_negedge = ctrl[`SPI_CTRL_RX_NEGEDGE];
    assign tx_negedge = ctrl[`SPI_CTRL_TX_NEGEDGE];
    assign lsb = ctrl[`SPI_CTRL_LSB];
    assign ie = ctrl[`SPI_CTRL_IE];
    assign ass = ctrl[`SPI_CTRL_ASS];
    assign go = ctrl[`SPI_CTRL_GO];
    assign char_len = ctrl[`SPI_CTRL_CHAR_LEN];

    always @(posedge wb_clk_in or posedge wb_rst_in) begin
        if (wb_rst_in) begin
            ss <= 0;
        end
        else begin
            if (spi_ss_sel && wb_we_in && !tip) begin
                `ifdef SPI_SS_NB_8
                    if (wb_sel_in[0]) begin
                        ss <= wb_dat_in[`SPI_SS_NB - 1 :0];
                    end
                `endif
                `ifdef SPI_SS_NB_16
                    if (wb_sel_in[0]) begin
                        ss <= wb_dat_in[7:0];
                    end
                    if (wb_sel_in[1]) begin
                        ss <= wb_dat_in[`SPI_SS_NB - 1:0]
                    end
                `endif
                `ifdef SPI_SS_NB_24
                    if (wb_sel_in[0]) begin
                        ss <= wb_dat_in[7:0];
                    end
                    if (wb_sel_in[1]) begin
                        ss <= wb_dat_in[15:8]
                    end
                    if (wb_sel_in[2]) begin
                        ss <= wb_dat_in[`SPI_SS_NB - 1:16]
                    end
                `endif
                `ifdef SPI_SS_NB_32
                    if (wb_sel_in[0]) begin
                        ss <= wb_dat_in[7:0];
                    end
                    if (wb_sel_in[1]) begin
                        ss <= wb_dat_in[15:8]
                    end
                    if (wb_sel_in[2]) begin
                        ss <= wb_dat_in[23:16]
                    end
                    if (wb_sel_in[3]) begin
                        ss <= wb_dat_in[`SPI_SS_NB - 1:24]
                    end
                `endif

            end
        end
    end
endmodule
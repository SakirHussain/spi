`include "D:\\college\\Maven Silicon\\SPI\\rtl\\spi_defines.v"

module tb();
    
    reg wb_clk, wb_reset;

    wire wb_we_in, wb_stb_in, wb_cyc_in, miso;

    wire  [4:0] wb_adr_in;
    wire [31:0] wb_dat_in;
    wire [3:0] wb_sel_in;
    wire wb_err_in;

    wire [31:0] wb_dat_o;

    wire wb_ack_out, wb_int_o, sclk_out, mosi;

    wire [`SPI_SS_NB -1 : 0] ss_pad_o;
    parameter T = 20;

    wishbone_master MASTER(wb_clk,
                           wb_reset,
                           wb_ack_out,
                           wb_err_in,
                           wb_dat_o,
                           wb_adr_in,
                           wb_cyc_in,
                           wb_stb_in,
                           wb_we_in,
                           wb_dat_in,
                           wb_sel_in);
    
    spi_top SPI_CORE(wb_clk,
                     wb_reset,
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

    spi_slave SLAVE (sclk_out,
                     mosi,
                     ss_pad_o,
                     miso);

    initial begin
        wb_clk = 1'b0;
        forever begin
            #(T/2) wb_clk = ~wb_clk;
        end
    end

    task rst();
        begin
            wb_reset = 1'b1;
            #15;
            wb_reset = 1'b0;
        end
    endtask

    initial begin
        rst;
        MASTER.initialize;
        
        MASTER.single_write(5'h10, 32'h0000_3c04, 4'b1111);
        MASTER.single_write(5'h14, 32'h0000_0004, 4'b1111);
        MASTER.single_write(5'h18, 32'h0000_0001, 4'b1111);
        MASTER.single_write(5'h00, 32'h0000_236f, 4'b1111);
        MASTER.single_write(5'h10, 32'h0000_3d04, 4'b1111);

        repeat(100)
        @(negedge wb_clk);

        $finish;
        #10000 $finish;
    end

    initial begin
        SLAVE.rx_slave = 1;
        SLAVE.tx_slave = 0; 
    end

endmodule
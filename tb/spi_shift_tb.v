`timescale 1ns/1ps

module tb_spi_shift;
    reg wb_clk;
    reg wb_reset;
    reg rx_negedge;
    reg tx_negedge;
    reg [3:0] byte_sel;
    reg [3:0] latch;
    reg [2:0] len;
    reg [7:0] p_in;
    reg go;
    reg miso;
    reg lsb;
    reg sclk;
    reg cpol_0;
    reg cpol_1;
    reg [7:0] p_out;
    reg last;
    reg mosi;
    reg tip;

    // Instantiate the SPI module
    spi_shift u_spi_shift (
        .rx_negedge(rx_negedge),
        .tx_negedge(tx_negedge),
        .byte_sel(byte_sel),
        .latch(latch),
        .len(len),
        .p_in(p_in),
        .wb_clk(wb_clk),
        .wb_reset(wb_reset),
        .go(go),
        .miso(miso),
        .lsb(lsb),
        .sclk(sclk),
        .cpol_0(cpol_0),
        .cpol_1(cpol_1),
        .p_out(p_out),
        .last(last),
        .mosi(mosi),
        .tip(tip)
    );

    // Clock generation for wb_clk (5ms interval)
    always begin
        #5 wb_clk = ~wb_clk; 
    end

    // Clock generation for sclk (toggle every 3 cycles of wb_clk)
    reg [1:0] sclk_counter;
    always @(posedge wb_clk) begin
        sclk_counter <= sclk_counter + 1;
        if (sclk_counter == 3'b11) begin
            sclk <= ~sclk;
            sclk_counter <= 3'b00;
        end
    end

    // Initialize signals with specified values
    initial begin
        wb_clk = 0;
        wb_reset = 0;
        rx_negedge = 1;
        tx_negedge = 0;
        len = 4'b0100; // Binary value 4
        lsb = 1;
        p_in = 8'b10101101;
        byte_sel = 4'b0000;
        latch = 4'b0000;
        cpol_0 = 0;
        cpol_1 = 0;
        go = 0;

        // Reset and release reset after a short delay
        wb_reset = 1;
        #10;
        wb_reset = 0;
    end

    // Stimulus generation
    initial begin
        // Apply the go signal to initiate data transmission
        go = 1;
        // Simulate for a period of time
        #100;
        // End simulation
        $finish;
    end

endmodule

`include "D:\\college\\Maven Silicon\\SPI\\rtl\\spi_defines.v"

module tb_spi_shift;
    reg wb_clk;
    reg wb_reset;
    reg rx_negedge;
    reg tx_negedge;
    reg [3:0] byte_sel;
    reg [3:0] latch;
    reg [`SPI_CHAR_LEN_BITS - 1 :0] len;
    reg [`SPI_MAX_CHAR - 1 :0] p_in;
    reg go;
    reg miso;
    reg lsb;
    reg sclk;
    reg cpol_0;
    reg cpol_1;
    wire [`SPI_MAX_CHAR - 1 : 0] p_out;
    wire last;
    wire mosi;
    wire tip;

    parameter T  = 10;
    parameter [`SPI_DIVIDER_LEN - 1 : 0] divider_value = 4'b0010;

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
    initial begin
        wb_clk = 1'b0;
        forever begin
            #(T/2) wb_clk = ~wb_clk;
        end
    end


    initial begin
        sclk = 1'b0;
        forever begin
            repeat(divider_value + 1)
            @(posedge wb_clk);
            sclk = ~sclk;
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
        cpol_1 = 1'b0;
        forever begin
            repeat(divider_value*2 + 1)
                @(posedge wb_clk);
            
            cpol_1 = 1'b1;

            @(posedge wb_clk)
            cpol_1  = 1'b0;

            repeat(divider_value *2 + 1)
                @(posedge wb_clk);

            cpol_1 = 1'b1;

            @(posedge wb_clk)
            cpol_1 = 1'b0;
        end
    end

    initial begin
        cpol_0 = 1'b0;
            repeat(divider_value)
                @(posedge wb_clk);
            
            cpol_0 = 1'b1;

            @(posedge wb_clk)
            cpol_0  = 1'b0;
            forever begin
                repeat(divider_value *2 + 1)
                    @(posedge wb_clk);

                cpol_0 = 1'b1;

                @(posedge wb_clk)            
                cpol_0 = 1'b0;
            end           
    end

    task t1();
        begin
            @(negedge wb_clk)
            rx_negedge = 1'b1;
            tx_negedge = 1'b0;
        end
    endtask

    task t2();
        begin
            @(negedge wb_clk)
            rx_negedge = 1'b0;
            tx_negedge = 1'b1;
        end
    endtask

    task initialize();
        begin
            len = 3'b000;
            lsb = 1'b0;
            p_in = 32'h0000;
            byte_sel = 4'b0000;
            latch = 4'b0000;
            go = 1'b0;
            miso = 1'b0;
            cpol_1 = 1'b0;
            cpol_0 = 1'b0;
        end
    endtask


    // Initialize signals with specified values
    initial begin
        initialize;
        rst;
        @(negedge wb_clk)
        len = 32'h0004;
        lsb = 1'b1;
        p_in =32'haa55;
        latch = 4'b0001;
        byte_sel = 4'b00001;
        t1;

        #10;
        go = 1'b1;
        #40;
        miso = 1'b1;
        #20;
        miso = 1'b0;
        #20;
        miso = 1'b1;
        #20;
        miso = 1'b0;
        #20;
        miso = 1'b1;
        #20;
        miso = 1'b0;
        #30;
        #1000 $finish;
    end

endmodule

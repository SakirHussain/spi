module spi_shift(
    rx_negedge,
    tx_negedge,
    byte_sel,
    latch,
    len,
    p_in,
    wb_clk,
    wb_reset,
    go,
    miso,
    lsb,
    sclk,
    cpol_0,
    cpol_1,
    p_out,
    last,
    mosi,
    tip );
    
    input rx_negedge, tx_negedge, wb_clk, wb_reset, go, miso,lsb, sclk, cpol_0, cpol_1;
    input [3:0] byte_sel, latch;
    input [6:0] len;

    input [31:0]p_in;
    output [31:0] p_out;
    output reg tip, mosi;
    output last;

    reg [31:0] char_count;
    reg [31:0] master_data;
    reg [31:0] tx_bit_pos;
    reg [31:0] rx_bit_pos;
    wire rx_clk;
    wire tx_clk;

    always @(posedge wb_clk or posedge wb_reset) begin
        if (wb_reset) begin
            char_count <= 32'h0000;
        end
        else begin
            if (tip) begin
                if (cpol_0) begin
                    char_count <= char_count - 32'h0001;
                end
            end
            else begin
                char_count = 32'b0000
            end
        end
    end

    assign last = ~(|char_count);

    always @(posedge wb_clk or posedge wb_reset) begin
        if (wb_reset) begin
            mosi <= 1'b0;
        end
        else begin
            if (tx_clk) begin
                mosi <= master_data[tx_bit_pos[31:0]];
            end
        end
    end

    assign tx_clk = ((tx_negedge) ? cpol_1 : cpol_0) && !last;
    assign rx_clk = ((rx_negedge) ? cpol_1 : cpol_0) && (!last || sclk);

    assign tx_bit_pos = lsb ? {!(|len), len} - char_count : char_count - {{32'h0000}} ;
    assign rx_bit_pos = lsb ? {!(|len), len} - (rx_negedge ? char_count + {{32'h0000}} : char_count) :
                        (rx_negedge ? char_count : char_count - {{32'h0000}});
    
    assign p_out = master_data;

    always @(posedge wb_clk or posedge wb_reset) begin
        if (wb_reset) begin
            master_data <= 32'h0000;
        end
        else if (latch[0] && !tip) begin
            if (byte_sel[0]) begin
                master_data[7:0] <= p_in[7:0];
            end
            if (byte_sel[1]) begin
                master_data[15:8] <= p_in[15:8];
            end
            if (byte_sel[2]) begin
                master_data[23:16] <= p_in[23:16];
            end
            if (byte_sel[3]) begin
                master_data[31:24] <= p_in[31:24];
            end
        end
        else if (latch[1] && !tip) begin
            if (byte_sel[0]) begin
                master_data[7:0] <= p_in[7:0];
            end
            if (byte_sel[1]) begin
                master_data[15:8] <= p_in[15:8];
            end
            if (byte_sel[2]) begin
                master_data[23:16] <= p_in[23:16];
            end
            if (byte_sel[3]) begin
                master_data[31:24] <= p_in[31:24];
            end
        end
        else if (latch[2] && !tip ) begin
            if (byte_sel[0]) begin
                master_data[7:0] <= p_in[7:0];
            end
            if (byte_sel[1]) begin
                master_data[15:8] <= p_in[15:8];
            end
            if (byte_sel[2]) begin
                master_data[23:16] <= p_in[23:16];
            end
            if (byte_sel[3]) begin
                master_data[31:24] <= p_in[31:24];
            end
        end
        else if (latch[3] && !tip) begin
            if (byte_sel[0]) begin
                master_data[7:0] <= p_in[7:0];
            end
            if (byte_sel[1]) begin
                master_data[15:8] <= p_in[15:8];
            end
            if (byte_sel[2]) begin
                master_data[23:16] <= p_in[23:16];
            end
            if (byte_sel[3]) begin
                master_data[31:24] <= p_in[31:24];
            end
        end

        else begin
            if(rx_clk) begin
                master_data[rx_bit_pos[31:0]] <= miso;
            end
        end
    end


endmodule
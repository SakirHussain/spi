module spi_clgen(
                    wb_clk,
                    wb_reset,
                    tip,
                    go,
                    lstclk,
                    divider,
                    sclk,
                    cpol_0,
                    cpol_1 );

input clock, wb_reset, tip, go, lstclk;
input [31:0] divider;

output sclk, cpol_0, cpol_1;

reg [31:0] count ;

// always @(wb_reset:sensitivity_list) begin
//     if (wb_reset == 1'b1) begin
//         sclk <= 0;
//         cpol_0 <= 0;
//         cpol_1 <= 0;
//     end
// end


always @(posedge wb_clk or posedge wb_reset:sensitivity_list) begin

    if (wb_reset == 1'b1) begin
        sclk <= 0;
        cpol_0 <= 0;
        cpol_1 <= 0;
    end

    count <= count + 1;
    if (count == (divider + 1)) begin
        sclk <= ~sclk;
    end

    if (count == divider and sclk == 1'b0) begin
        cpol_0 <= 1'b1;          //rising edge
    end
    else if (count == divider and sclk == 1'b1) begin
        cpol_1 <= 1'b1;                  //falling edge
    end

end


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

input wb_clk, wb_reset, tip, go, lstclk;
input [31:0] divider;

output reg sclk, cpol_0, cpol_1;

reg [31:0] count ;

// always @(wb_reset:sensitivity_list) begin
//     if (wb_reset == 1'b1) begin
//         sclk <= 0;
//         cpol_0 <= 0;
//         cpol_1 <= 0;
//     end
// end


always @(posedge wb_clk or posedge wb_reset) begin

    if (wb_reset == 1'b1) begin
        sclk <= 0;
        cpol_0 <= 0;
        cpol_1 <= 0;
        count <= 0;
    end
    else begin
            count <= count + 32'h0001;
        if (count == (divider + 32'h0001)) begin
            sclk <= ~sclk;
            count <= 32'h0000;
        end

        if (count == divider && sclk == 1'b0) begin
            cpol_0 <= 1'b1;          //rising edge
            #10;                    //this might need fixing
            cpol_0 <= 1'b0;
        end
        else if (count == divider && sclk == 1'b1) begin
            cpol_1 <= 1'b1;                  //falling edge
            #10;                    //this might need fixing
            cpol_1 <= 1'b0;
        end
    end    
end

endmodule


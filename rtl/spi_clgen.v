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
            count <= 32'h0000;
        end
        else if (tip) begin
            if (count == divider + 32'h0001) begin
                count <= 32'h0000;
            end
            else begin
                count <= count + 1;
            end
        // else if (count) begin
        //     count <= 32'h0004
        // end        
        end
    end

    always @(posedge wb_clk or posedge wb_reset) begin
        if (wb_reset) begin
            sclk <= 1'b0;
        end
        else if (tip) begin
            if(count == (divider + 32'h0001)) begin
                if(!lstclk || sclk) begin
                    sclk = ~sclk;
                end
            end
        end
    end

    always @(posedge wb_clk or posedge wb_reset) begin
        if (wb_reset) begin
            cpol_0 <= 1'b0;
            cpol_1 <= 1'b0;
        end
        else begin
            cpol_0 <= 1'b0;
            cpol_1 <= 1'b0;
            if (tip) begin
                if (~sclk) begin
                    if (count == divider) begin
                        cpol_0 <= 1'b1;
                    end
                end
            end

            if (tip) begin
                if (sclk) begin
                    if(count == divider) begin
                        cpol_1 <= 1'b1;
                    end
                end
            end
        end
    end
endmodule


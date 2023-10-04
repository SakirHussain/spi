module spi_clgen_tb;

    // Inputs
    reg wb_clk;
    reg wb_reset;
    reg tip;
    reg go;
    reg lstclk;
    reg [31:0] divider;

    // Outputs
    wire sclk;
    wire cpol_0;
    wire cpol_1;

    // Instantiate the spi_clgen module
    spi_clgen uut (
        .wb_clk(wb_clk),
        .wb_reset(wb_reset),
        .tip(tip),
        .go(go),
        .lstclk(lstclk),
        .divider(divider),
        .sclk(sclk),
        .cpol_0(cpol_0),
        .cpol_1(cpol_1)
    );

    // Clock generation
    initial begin
      wb_clk = 1'b0;
      forever begin
        #5 wb_clk = ~wb_clk;
      end
    end

    // Initializations
    initial begin
        // wb_clk = 0;
        wb_reset = 0;
        tip = 1;
        go = 0;
        lstclk = 0;
        divider = 32'h0004; // You can set the divider value as needed
        
        // Apply reset
        wb_reset = 1;
        #10 wb_reset = 0;

        // Apply tip (toggle it)
        // tip = 1;
        // #10 tip = 0;

        // Simulate for a period of time
        #1000 $finish; // Finish the simulation after 1000 time units
    end

    // Monitor and display outputs
    initial
        $display("sclk = %b, cpol_0 = %b, cpol_1 = %b", sclk, cpol_0, cpol_1);

endmodule

module spi_clgen_tb();

  // Define constants for clock period and reset duration
  reg clk;
  reg wb_reset;
  reg tip;
  reg go;
  reg lstclk;
  reg [31:0] divider;
  
  wire sclk;
  wire cpol_0;
  wire cpol_1;

  // Instantiate the spi_clgen module
  spi_clgen uut (
    .wb_clk(clk),
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
    clk = 1'b0;
    forever begin
        #5 clk = ~clk;
    end
  end
  
  // Initialize inputs
  initial begin
    // Initialize inputs
    wb_reset = 1'b0;
    tip = 1'b0;
    go = 1'b0;
    lstclk = 1'b0;
    divider = 32'h0004; // Set your desired divider value here

    // Apply reset
    wb_reset = 1'b1;
    #10; // Hold reset for 20 time units
    wb_reset = 1'b0;

    // Generate stimulus
    tip = 1'b1;
    go = 1'b1;
    lstclk = 1'b0;
    #100; // Run the simulation for a while
    tip = 1'b0;
    go = 1'b0;
    lstclk = 1'b0;
    #100; // Run the simulation for a while

    // Finish simulation
    $finish;
  end

  // Monitor outputs
  initial
    $display("sclk = %b, cpol_0 = %b, cpol_1 = %b", sclk, cpol_0, cpol_1);
  

endmodule

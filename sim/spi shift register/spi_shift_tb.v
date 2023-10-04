module tb_spi_shift;

  // Parameters
  reg rx_negedge;
  reg tx_negedge;
  reg [3:0] byte_sel;
  reg latch;
  reg [6:0] len;
  reg [31:0] p_in;
  reg wb_clk;
  reg wb_reset;
  reg go;
  wire [31:0] p_out;
  wire last;
  wire miso;
  wire lsb;
  wire sclk;
  wire cpol_0;
  wire cpol_1;
  wire tip;
  wire [31:0] mosi;

  // Instantiate SPI Shift Register Module
  spi_shift uut (
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

  // Clock Generation
  always begin
    #5 wb_clk = ~wb_clk;
  end

  // Initialize Inputs
  initial begin
    wb_clk = 0;
    rx_negedge = 0;
    tx_negedge = 0;
    byte_sel = 4'b0101;
    latch = 1;
    len = 7'b0000100;
    p_in = 32'h12345678;
    wb_reset = 1;
    go = 1;
    
    // Apply test sequence
    #10;        // Wait for a few cycles
    wb_reset = 0;  // Release the reset
    #10;        // Wait for a few cycles
    go = 0;       // Disable SPI communication
    #100;       // Simulate for some cycles
    
    // Finish simulation
    $finish;
  end

endmodule

`timescale 1ns/1ps

module uart_tx_tb;

reg clk;
reg rst;
reg baud_tick;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

// Instantiate UART TX
uart_tx uut (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

// Clock Generation (10 ns period)
always #5 clk = ~clk;

// Baud Tick Generation (for simulation)
always #20 baud_tick = ~baud_tick;

initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    baud_tick = 0;
    tx_start = 0;
    tx_data = 8'h00;

    // Reset
    #20;
    rst = 0;

    // Transmit 0x41 ('A')
    #20;
    tx_data = 8'h41;
    tx_start = 1;

    #10;
    tx_start = 0;

    // Wait for transmission to complete
    #500;

    $finish;
end

endmodule
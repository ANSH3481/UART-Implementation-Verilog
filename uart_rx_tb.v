`timescale 1ns/1ps

module uart_rx_tb;

reg clk;
reg rst;
reg baud_tick;
reg rx;

wire [7:0] rx_data;
wire rx_done;

uart_rx uut (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

// Clock generation
always #5 clk = ~clk;

// Baud tick generation
always #20 baud_tick = ~baud_tick;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, uart_rx_tb);

    clk = 0;
    rst = 1;
    baud_tick = 0;
    rx = 1;     // UART line idle high

    #20;
    rst = 0;

    // Start bit
    #40;
    rx = 0;

    // Data bits for 8'h41 (LSB first)
    #40 rx = 1;   // D0
    #40 rx = 0;   // D1
    #40 rx = 0;   // D2
    #40 rx = 0;   // D3
    #40 rx = 0;   // D4
    #40 rx = 0;   // D5
    #40 rx = 1;   // D6
    #40 rx = 0;   // D7

    // Stop bit
    #40 rx = 1;

    #200;

    $finish;
end

endmodule
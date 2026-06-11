`timescale 1ns/1ps

module uart_top_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;
wire [7:0] rx_data;
wire rx_done;

uart_top uut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, uart_top_tb);

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #20;
    rst = 0;

    // Send 'A'
    #20;
    tx_data = 8'h41;
    tx_start = 1;

    #10;
    tx_start = 0;

    // Wait for loopback
    #6000000;

    $finish;
end

endmodule
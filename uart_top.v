module uart_top (
    input  wire clk,
    input  wire rst,
    input  wire tx_start,
    input  wire [7:0] tx_data,

    output wire tx,
    output wire tx_busy,
    output wire [7:0] rx_data,
    output wire rx_done
);

wire baud_tick;
wire rx;

// Baud Rate Generator
baud_rate_generator baud_gen (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

// UART Transmitter
uart_tx tx_inst (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

// Loopback connection
assign rx = tx;

// UART Receiver
uart_rx rx_inst (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

endmodule
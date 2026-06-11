module baud_rate_generator #
(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)
(
    input  wire clk,
    input  wire rst,
    output reg  baud_tick
);

localparam DIVISOR = CLK_FREQ / BAUD_RATE;

reg [15:0] counter;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        counter   <= 16'd0;
        baud_tick <= 1'b0;
    end
    else
    begin
        if (counter == DIVISOR - 1)
        begin
            counter   <= 16'd0;
            baud_tick <= 1'b1;
        end
        else
        begin
            counter   <= counter + 1'b1;
            baud_tick <= 1'b0;
        end
    end
end

endmodule
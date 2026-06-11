module uart_rx(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire rx,

    output reg [7:0] rx_data,
    output reg rx_done
);

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] data_reg;

localparam IDLE  = 2'b00,
           DATA  = 2'b01,
           STOP  = 2'b10;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state     <= IDLE;
        bit_index <= 3'd0;
        data_reg  <= 8'd0;
        rx_data   <= 8'd0;
        rx_done   <= 1'b0;
    end
    else
    begin
        rx_done <= 1'b0;   // default

        case(state)

            IDLE:
            begin
                if (rx == 1'b0)      // Detect Start Bit
                begin
                    bit_index <= 3'd0;
                    state <= DATA;
                end
            end

            DATA:
            begin
                if (baud_tick)
                begin
                    data_reg[bit_index] <= rx;

                    if (bit_index == 3'd7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1'b1;
                end
            end

            STOP:
            begin
                if (baud_tick)
                begin
                    rx_data <= data_reg;
                    rx_done <= 1'b1;
                    state <= IDLE;
                end
            end

            default:
                state <= IDLE;

        endcase
    end
end

endmodule
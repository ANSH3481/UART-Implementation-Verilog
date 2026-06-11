module uart_tx(
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire tx_start,
    input wire [7:0] tx_data,

    output reg tx,
    output reg tx_busy
);

reg [1:0] state;
reg [2:0] bit_index;
reg [7:0] data_reg;

localparam IDLE  = 2'b00,
           START = 2'b01,
           DATA  = 2'b10,
           STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state     <= IDLE;
        tx        <= 1'b1;   // Idle state of UART line
        tx_busy   <= 1'b0;
        bit_index <= 3'd0;
        data_reg  <= 8'd0;
    end
    else
    begin
        case(state)

            IDLE:
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;

                if(tx_start)
                begin
                    tx_busy   <= 1'b1;
                    data_reg  <= tx_data;
                    bit_index <= 3'd0;
                    state     <= START;
                end
            end

            START:
            begin
                if(baud_tick)
                begin
                    tx <= 1'b0;      // Start bit
                    state <= DATA;
                end
            end

            DATA:
            begin
                if(baud_tick)
                begin
                    tx <= data_reg[bit_index];

                    if(bit_index == 3'd7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1'b1;
                end
            end

            STOP:
            begin
                if(baud_tick)
                begin
                    tx <= 1'b1;      // Stop bit
                    state <= IDLE;
                end
            end

            default:
                state <= IDLE;

        endcase
    end
end

endmodule
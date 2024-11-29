module clk_dividers(
    input clk,        // 100 MHz clock
    input reset,      // Active-high reset
    output reg ms_clk,  // 1 ms clock
    output reg sec_clk  // 1 sec clock
);

    // Counters for milliseconds and seconds
    reg [16:0] ms_counter;   // 17-bit counter for 100,000 cycles (max value = 99,999)
    reg [9:0] sec_counter;   // 10-bit counter for 1,000 ms (max value = 999)

    // Generate 1 ms clock (100 MHz / 100,000 = 1 kHz)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ms_counter <= 0;
            ms_clk <= 0;
        end else if (ms_counter == 99999) begin
            ms_counter <= 0;
            ms_clk <= ~ms_clk;  // Toggle every 100,000 cycles
        end else begin
            ms_counter <= ms_counter + 1;
        end
    end

    // Generate 1 sec clock (1 kHz / 1,000 = 1 Hz)
    always @(posedge ms_clk or posedge reset) begin
        if (reset) begin
            sec_counter <= 0;
            sec_clk <= 0;
        end else if (sec_counter == 999) begin
            sec_counter <= 0;
            sec_clk <= ~sec_clk;  // Toggle every 1,000 ms (1 second)
        end else begin
            sec_counter <= sec_counter + 1;
        end
    end

endmodule

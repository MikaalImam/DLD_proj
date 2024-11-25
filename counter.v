module counter(
    input clk,revolution, reset,
    output [6:0] out,
    output [6:0] tens_out,
    output reg [6:0] rev_counter,
    output reg [6:0] distOnes,
    output reg [6:0] distTens,
    output reg [6:0] distHundreds,
    output reg [6:0] distThousands,
    output reg [6:0] speedOnes,
    output reg [6:0] speedTens
    
        );
     //1 Hz frequency counter
    /////////////////////////////////////////////////////////////
    reg [14:0] dist;
    reg [26:0] counter;
    wire [26:0] counter_NS;
    reg [6:0] ascii;
    wire [6:0] ascii_NS;
    wire nextOp;
    
    reg [6:0] tens;
    wire [6:0] tens_NS;  
    
    reg [31:0] ms_counter;          // Current millisecond counter
    reg [31:0] last_ms_counter;     // Millisecond value at the last revolution
    reg [31:0] time_difference_ms;  // Time difference between revolutions
    reg [31:0] cycle_count;         // Counts high-frequency clock cycles
    parameter CLOCK_FREQ_MHZ = 1_000_000;  // Clock frequency (e.g., 1 MHz)
    parameter CYCLES_PER_MS = CLOCK_FREQ_MHZ / 1_000;
    
    integer speed_mps;
    
    
    //CS
    always @ (posedge clk, posedge reset)
          if(reset)
          begin
              counter<=0;
              ascii <= 7'h30;
              tens <= 7'h30;
          end
          else
          begin
              counter <= counter_NS;
              ascii <= ascii_NS;
              tens <= tens_NS;
          end
    //NS
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ms_counter <= 0;
            cycle_count <= 0;
        end else begin
            // Increment cycle count
            cycle_count <= cycle_count + 1;

            // Increment millisecond counter when a millisecond's worth of cycles is counted
            
        end
    end
    

    always @(posedge revolution or posedge reset) begin
        if (reset) begin
            rev_counter <= 7'h30;
            dist <= 0;
            time_difference_ms <= 0;
            last_ms_counter <= 0;
            speedOnes <= 7'h30;
            speedTens <= 7'h30;
        end else if (rev_counter < 7'h39) begin
            rev_counter <= rev_counter + 1;
            dist <= dist + 2;
    
            // Update distance registers
            distOnes <=  14'h30 + dist % 10;
            distTens <=  14'h30 + (dist / 10) % 10;
            distHundreds <=  14'h30 + (dist / 100) % 10;
            distThousands <=  14'h30 + (dist / 1000) % 10;
    
            // Calculate time difference
            time_difference_ms <= ms_counter - last_ms_counter;
            last_ms_counter <= ms_counter; // Update last revolution time
    
            // Calculate speed (distance / time) in meters per second
            speed_mps = (dist - last_ms_counter); // Speed in meters/second (2 meters per second for 1 revolution)
            last_ms_counter <= dist; // Save current distance
    
            // Convert speed to ASCII for display
            speedTens <= (speed_mps / 10) + 7'h30; // Tens place
            speedOnes <= (speed_mps % 10) + 7'h30; // Ones place
    
            // Reset distance if maximum value reached
            if (dist >= 9999) begin
                dist <= 0;
            end         
        end else begin
            rev_counter <= 7'h30;
        end
    end
    
    assign counter_NS = (counter < 99999999) ? counter + 1 : 0; //1Hz
    assign nextOp = (counter == 0);
    assign ascii_NS = nextOp ? ascii < 7'h39 ? ascii + 7'h1 : 7'h30 : ascii;
    assign out = ascii;
    assign tens_NS = nextOp ? (ascii < 7'h39 ? tens : (tens < 7'h39 ? tens + 7'h1 : 7'h30)) : tens;    
    assign tens_out = tens;
endmodule

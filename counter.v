module counter(
    input clk,revolution, reset,
    output [6:0] out,
    output [6:0] tens_out,
    output reg [6:0] rev_counter
        );
     //1 Hz frequency counter
    /////////////////////////////////////////////////////////////
    
    reg [26:0] counter;
    wire [26:0] counter_NS;
    reg [6:0] ascii;
    wire [6:0] ascii_NS;
    wire nextOp;
    
    reg [6:0] tens;
    wire [6:0] tens_NS;  
    
    
    
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
    
    always @(posedge revolution or posedge reset) begin
        if (reset) begin
            rev_counter <= 7'h30;
        end else if (rev_counter < 7'h39) begin
            rev_counter <= rev_counter + 1;
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

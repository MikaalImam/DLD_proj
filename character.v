`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.11.2024 17:12:44
// Design Name: 
// Module Name: character
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module character(input sensor,

                     input [9:0] x,y,
                     output display_char);
    wire horizontalOn, verticalOn;
    
    assign horizontalOn = (x >= 10'd80 && x < 10'd80 + 10'd8) ? 1 : 0; //Assert horizontalOn for 7 more pixels from desired X
    assign verticalOn = (y >= 10'd300 && y < 10'd300 + 10'd16) ? 1 : 0; //Assert verticalOn for 15 more pixels from desired Y
    assign display_char = horizontalOn && verticalOn;
    
   //assign asciiData = ascii_In; //Buffer the input to the output
   //assign horizontalOn = (x >= x_desired && x < x_desired + 10'd8) ? 1 : 0; //Assert horizontalOn for 7 more pixels from desired X
   //assign verticalOn = (y >= y_desired && y < y_desired + 10'd16) ? 1 : 0; //Assert verticalOn for 15 more pixels from desired Y
   //assign displayContents = horizontalOn && verticalOn; //content of ROM should be displayed at these desired X,Y range
endmodule

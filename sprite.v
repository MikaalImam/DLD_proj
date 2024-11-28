`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 04:56:47 PM
// Design Name: 
// Module Name: sprite
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This module displays a 64x64 sprite (a dino) at the specified location on the screen
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sprite_display (
    input wire clk,
    input wire reset,
    input [9:0] x_desired, y_desired,  // Position where the sprite should be displayed
    input [9:0] x, y,                   // Current x, y pixel coordinates
    output [11:0] spriteData,           // Pixel color data (RGB)
    output display_sprite               // Whether to display the sprite at the location
);

    // Define a 64x64 sprite (dino)
    reg [31:0] sprite[31:0]; // A 64x64 sprite, 64 rows of 64 bits each
    
    initial begin
        // Define the sprite pattern for the dino
        sprite[0] = 32'b00000000000000000000000000000000;
        sprite[1] = 32'b00000000000000000000000000000000;
        sprite[2] = 32'b00000000000000000000000000000000;
        sprite[3] = 32'b00000000000000000000000000000000;
        sprite[4] = 32'b00000000000000000000000000000000;
        sprite[5] = 32'b00000000000000000000000000000000;
        sprite[6] = 32'b00000000000000000000000000000000;
        sprite[7] = 32'b00000000000000000000000000000000;
        sprite[8] = 32'b00000001111110000000000000000000;
        sprite[9] = 32'b00000001000010000000101000000000;
        sprite[10] = 32'b00000000100110000000011000000000;
        sprite[11] = 32'b00000000000111111111110000000000;
        sprite[12] = 32'b00000000001110000000111000000000;
        sprite[13] = 32'b00000000001010000000101000000000;
        sprite[14] = 32'b00000111111001000001101111100000;
        sprite[15] = 32'b00001000001001100000010000010000;
        sprite[16] = 32'b00011000001100100010110000011000;
        sprite[17] = 32'b00110000000110110111100000001100;
        sprite[18] = 32'b00100000000010001101000000000100;
        sprite[19] = 32'b00100000000010001111000000000100;
        sprite[20] = 32'b00010000000100000000100000001000;
        sprite[21] = 32'b00011000001100000000110000011000;
        sprite[22] = 32'b00001000001000000000010000010000;
        sprite[23] = 32'b00000111110000000000001111100000;
        sprite[24] = 32'b00000000000000000000000000000000;
        sprite[25] = 32'b00000000000000000000000000000000;
        sprite[26] = 32'b00000000000000000000000000000000;
        sprite[27] = 32'b00000000000000000000000000000000;
        sprite[28] = 32'b00000000000000000000000000000000;
        sprite[29] = 32'b00000000000000000000000000000000;
        sprite[30] = 32'b00000000000000000000000000000000;
        sprite[31] = 32'b00000000000000000000000000000000;
end
        

   // Vertical positioning: map y to a sprite row
    wire [4:0] spriteRow;
    assign spriteRow = y - y_desired;  // Relative y position within the sprite, should be between 0 and 15
    // Horizontal positioning: map x to a column within the sprite row
    wire [4:0] spriteCol;
    assign spriteCol = x - x_desired;  // Relative x position within the sprite row, should be between 0 and 15
    // Get the pixel value from the sprite
    assign spriteData = (sprite[spriteRow][spriteCol] == 1'b1) ? 12'hFFF : 12'h000;  // If pixel is on, set to white; else black


    // Output the pixel value based on x, y coordinates
    assign horizontalOn = (x >= x_desired && x < x_desired + 10'd32) ? 1 : 0; //Assert horizontalOn for 7 more pixels from desired X
    assign verticalOn = (y >= y_desired && y < y_desired + 10'd32) ? 1 : 0; //Assert verticalOn for 15 more pixels from desired Y
    assign display_sprite = horizontalOn && verticalOn; //content of ROM should be displayed at these desired X,Y range
endmodule

module vga_test
	(
		input wire clk, reset, revolution, home_page, //times_up, 
		output wire hsync, vsync,
		output wire [11:0] rgb
	);
	wire times_up;
	wire ms_clk;
    wire sec_clk;
    clk_dividers clkmod(.clk(clk), .reset(reset), .ms_clk(ms_clk), .sec_clk(sec_clk));
//	wire ms_clk;
//	ms_clock_generator ms_gen (
//        .clk(clk),        // 100 MHz clock from Basys3
//        .reset(reset),    // Reset signal
//        .ms_clk(ms_clk)   // Generated 1 ms clock
//    );
//	//VGA/////////////////////////////////////////////////////////////////////////////
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
    wire [9:0] x,y; //Pixel location
        // instantiate vga_sync for the monitor sync and x,y pixel tracing
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .x(x), .y(y));
    //////////////////////////////////////////////////////////////////////////////////
    
    //COUNTER FOR LIVE DATA //////////////////////////////////////////////////////////
    //Instantiate a counter with counterValue representing the 0-9 count in ASCII
    
    wire [6:0] counterValue; 
    wire [6:0] rev_counter;
    wire [6:0] final_tens;
    wire [6:0] final_mins;
    wire [6:0] distOnes;
    wire [6:0] distTens;
    wire [6:0] distHundreds;
    wire [6:0] distThousands;
    wire [6:0] speedOnes;
    wire [6:0] speedTens;
    wire [6:0] HOnes;
    wire [6:0] HTens;
    wire [6:0] HHundreds;
    wire [6:0] HThousands;
    counter counter1(.clk(clk),.revolution(revolution), .reset(home_page), .ms_clk(ms_clk), //switched rest wtih my own reset 
            .out(counterValue), .tens_out(final_tens), .mins_out(final_mins), 
            .rev_counter(rev_counter),
            .distOnes(distOnes),
            .distTens(distTens),
            .distHundreds(distHundreds),
            .distThousands(distThousands),
            .HOnes(HOnes),
            .HTens(HTens),
            .HHundreds(HHundreds),
            .HThousands(HThousands),
            .speedOnes(speedOnes),
            .speedTens(speedTens),
            .times_up(times_up)
            );
            
    //////////////////////////////////////////////////////////////////////////////////
    
    //READ MEMORY FILE FOR INPUT ASCII ARRAY, CREATE SIGNAL ARRAY                       
    wire [6:0] ascii;  //Signal is concatenated with X coordinate to get a value for the ROM address                 
    wire [6:0] a[59:0]; //Each index of this array holds a 7-bit ASCII value //6???
    wire d[59:0]; //Each index of this array holds a signal that says whether the i-th item in array a above should display
    wire displayContents; //Control signal to determine whether a character should be displayed on the screen

//initial begin
//    rev_counter = 0; // Initialize to 0 for simulation
//end
    
//always @(posedge revolution) begin
//    if (rev_counter < 9) begin
//        rev_counter <= rev_counter + 1;
//    end
//    else begin
//        rev_counter = 0;
//    end
//end 
    //Read memory file for ascii inputs
    //reg [6:0] readAscii [7:0];
    //initial begin
    //    $readmemh("ascii.txt", readAscii);
    //end
    ///////////////////////////////////////////////////////////////////////////////////
    
    //INSTANTIATE TEXT GENERATION MODULES/////////////////////////////////////////////////////////
        //Manually feed in data to ascii_in or use another module to get live data, such as a counter
        //In this case readAscii is an array that had data imported from a hex memory file
        
        //speed
        textGeneration c0 (.clk(clk),.reset(reset),.asciiData(a[0]), .ascii_In(7'h53),//S
        .x(x),.y(y), .displayContents(d[0]), .x_desired(10'd80), .y_desired(10'd80));
        
        textGeneration c1 (.clk(clk),.reset(reset),.asciiData(a[1]), .ascii_In(7'h50), //P
        .x(x),.y(y), .displayContents(d[1]), .x_desired(10'd88), .y_desired(10'd80)); 
    
        textGeneration c2 (.clk(clk),.reset(reset),.asciiData(a[2]), .ascii_In(7'h45), //E
        .x(x),.y(y), .displayContents(d[2]), .x_desired(10'd96), .y_desired(10'd80)); 
        
        textGeneration c3 (.clk(clk),.reset(reset),.asciiData(a[3]), .ascii_In(7'h45), //E
        .x(x),.y(y), .displayContents(d[3]), .x_desired(10'd104), .y_desired(10'd80));
        
        textGeneration c4 (.clk(clk),.reset(reset),.asciiData(a[4]), .ascii_In(7'h44), //D
        .x(x),.y(y), .displayContents(d[4]), .x_desired(10'd112), .y_desired(10'd80)); 

        textGeneration c5 (.clk(clk),.reset(reset),.asciiData(a[5]), .ascii_In(speedTens), //0
        .x(x),.y(y), .displayContents(d[5]), .x_desired(10'd128), .y_desired(10'd80)); 
        
        textGeneration c6 (.clk(clk),.reset(reset),.asciiData(a[6]), .ascii_In(speedOnes), //0
        .x(x),.y(y), .displayContents(d[6]), .x_desired(10'd136), .y_desired(10'd80));         
        
        //dist
         textGeneration c7 (.clk(clk),.reset(reset),.asciiData(a[7]), .ascii_In(7'h44), //D
        .x(x),.y(y), .displayContents(d[7]), .x_desired(10'd80), .y_desired(10'd110)); 
        
        textGeneration c8 (.clk(clk),.reset(reset),.asciiData(a[8]), .ascii_In(7'h49), //I
        .x(x),.y(y), .displayContents(d[8]), .x_desired(10'd88), .y_desired(10'd110)); 
        
        textGeneration c9 (.clk(clk),.reset(reset),.asciiData(a[9]), .ascii_In(7'h53), //S
        .x(x),.y(y), .displayContents(d[9]), .x_desired(10'd96), .y_desired(10'd110)); 
        
        textGeneration c10 (.clk(clk),.reset(reset),.asciiData(a[10]), .ascii_In(7'h54), //T
        .x(x),.y(y), .displayContents(d[10]), .x_desired(10'd104), .y_desired(10'd110)); 
        
        textGeneration c11 (.clk(clk),.reset(reset),.asciiData(a[11]), .ascii_In(distThousands), //0
        .x(x),.y(y), .displayContents(d[11]), .x_desired(10'd128), .y_desired(10'd110)); 
        
        textGeneration c12 (.clk(clk),.reset(reset),.asciiData(a[12]), .ascii_In(distHundreds), //0
        .x(x),.y(y), .displayContents(d[12]), .x_desired(10'd136), .y_desired(10'd110));   
        
        textGeneration c13 (.clk(clk),.reset(reset),.asciiData(a[13]), .ascii_In(distTens), //0
        .x(x),.y(y), .displayContents(d[13]), .x_desired(10'd144), .y_desired(10'd110));   
        
        textGeneration c14 (.clk(clk),.reset(reset),.asciiData(a[14]), .ascii_In(distOnes), //0
        .x(x),.y(y), .displayContents(d[14]), .x_desired(10'd152), .y_desired(10'd110));   
              
        
        //time
        textGeneration c15 (.clk(clk),.reset(reset),.asciiData(a[15]), .ascii_In(7'h54), //T
        .x(x),.y(y), .displayContents(d[15]), .x_desired(10'd80), .y_desired(10'd140)); 
        
        textGeneration c16 (.clk(clk),.reset(reset),.asciiData(a[16]), .ascii_In(7'h49), //I
        .x(x),.y(y), .displayContents(d[16]), .x_desired(10'd88), .y_desired(10'd140)); 
        
        textGeneration c17 (.clk(clk),.reset(reset),.asciiData(a[17]), .ascii_In(7'h4d), //M
        .x(x),.y(y), .displayContents(d[17]), .x_desired(10'd96), .y_desired(10'd140)); 
        
        textGeneration c18 (.clk(clk),.reset(reset),.asciiData(a[18]), .ascii_In(7'h45), //E
        .x(x),.y(y), .displayContents(d[18]), .x_desired(10'd104), .y_desired(10'd140)); 

        //time
        textGeneration c19 (.clk(clk),.reset(reset),.asciiData(a[19]), .ascii_In(final_mins),
        .x(x),.y(y), .displayContents(d[19]), .x_desired(10'd128), .y_desired(10'd140)); 

        textGeneration c20 (.clk(clk),.reset(reset),.asciiData(a[20]), .ascii_In(final_tens),
        .x(x),.y(y), .displayContents(d[20]), .x_desired(10'd144), .y_desired(10'd140));      
        
        textGeneration c21 (.clk(clk),.reset(reset),.asciiData(a[21]), .ascii_In(counterValue),
        .x(x),.y(y), .displayContents(d[21]), .x_desired(10'd152), .y_desired(10'd140));
        //Revolution
        textGeneration c22 (.clk(clk),.reset(reset),.asciiData(a[22]), .ascii_In(rev_counter),
        .x(x),.y(y), .displayContents(d[22]), .x_desired(10'd496), .y_desired(10'd80));  
        
        //Home page text
         textGeneration c23 (.clk(clk),.reset(reset),.asciiData(a[23]), .ascii_In(7'h43),
        .x(x),.y(y), .displayContents(d[23]), .x_desired(10'd272), .y_desired(10'd240));  
        
        textGeneration c24 (.clk(clk),.reset(reset),.asciiData(a[24]), .ascii_In(7'h59),
        .x(x),.y(y), .displayContents(d[24]), .x_desired(10'd280), .y_desired(10'd240));  
        
        textGeneration c25 (.clk(clk),.reset(reset),.asciiData(a[25]), .ascii_In(7'h43),
        .x(x),.y(y), .displayContents(d[25]), .x_desired(10'd288), .y_desired(10'd240));  
        
        textGeneration c26 (.clk(clk),.reset(reset),.asciiData(a[26]), .ascii_In(7'h4c),
        .x(x),.y(y), .displayContents(d[26]), .x_desired(10'd296), .y_desired(10'd240));  

        textGeneration c27 (.clk(clk),.reset(reset),.asciiData(a[27]), .ascii_In(7'h45),
        .x(x),.y(y), .displayContents(d[27]), .x_desired(10'd304), .y_desired(10'd240));  
        
        textGeneration c28 (.clk(clk),.reset(reset),.asciiData(a[28]), .ascii_In(7'h4d),
        .x(x),.y(y), .displayContents(d[28]), .x_desired(10'd312), .y_desired(10'd240));  
        
        textGeneration c29 (.clk(clk),.reset(reset),.asciiData(a[29]), .ascii_In(7'h49),
        .x(x),.y(y), .displayContents(d[29]), .x_desired(10'd320), .y_desired(10'd240));  
        
        textGeneration c30 (.clk(clk),.reset(reset),.asciiData(a[30]), .ascii_In(7'h4c),
        .x(x),.y(y), .displayContents(d[30]), .x_desired(10'd328), .y_desired(10'd240));  

        textGeneration c31 (.clk(clk),.reset(reset),.asciiData(a[31]), .ascii_In(7'h4c),
        .x(x),.y(y), .displayContents(d[31]), .x_desired(10'd336), .y_desired(10'd240));  
        
        //Highscore
        textGeneration c32 (.clk(clk),.reset(reset),.asciiData(a[32]), .ascii_In(7'h48),
        .x(x),.y(y), .displayContents(d[32]), .x_desired(10'd424), .y_desired(10'd96));

        textGeneration c33 (.clk(clk),.reset(reset),.asciiData(a[33]), .ascii_In(7'h49),
        .x(x),.y(y), .displayContents(d[33]), .x_desired(10'd432), .y_desired(10'd96));

        textGeneration c34 (.clk(clk),.reset(reset),.asciiData(a[34]), .ascii_In(7'h47),
        .x(x),.y(y), .displayContents(d[34]), .x_desired(10'd440), .y_desired(10'd96));

        textGeneration c35 (.clk(clk),.reset(reset),.asciiData(a[35]), .ascii_In(7'h48),
        .x(x),.y(y), .displayContents(d[35]), .x_desired(10'd448), .y_desired(10'd96));

        textGeneration c36 (.clk(clk),.reset(reset),.asciiData(a[36]), .ascii_In(7'h53),
        .x(x),.y(y), .displayContents(d[36]), .x_desired(10'd464), .y_desired(10'd96));

        textGeneration c37 (.clk(clk),.reset(reset),.asciiData(a[37]), .ascii_In(7'h43),
        .x(x),.y(y), .displayContents(d[37]), .x_desired(10'd472), .y_desired(10'd96));

        textGeneration c38 (.clk(clk),.reset(reset),.asciiData(a[38]), .ascii_In(7'h4f),
        .x(x),.y(y), .displayContents(d[38]), .x_desired(10'd480), .y_desired(10'd96));

        textGeneration c39 (.clk(clk),.reset(reset),.asciiData(a[39]), .ascii_In(7'h52),
        .x(x),.y(y), .displayContents(d[39]), .x_desired(10'd488), .y_desired(10'd96));

        textGeneration c40 (.clk(clk),.reset(reset),.asciiData(a[40]), .ascii_In(7'h45),
        .x(x),.y(y), .displayContents(d[40]), .x_desired(10'd496), .y_desired(10'd96));
        
        //Times up page
         textGeneration c41 (.clk(clk),.reset(reset),.asciiData(a[41]), .ascii_In(7'h54), 
        .x(x),.y(y), .displayContents(d[41]), .x_desired(10'd272), .y_desired(10'd210));  

        textGeneration c42 (.clk(clk),.reset(reset),.asciiData(a[42]), .ascii_In(7'h49),
        .x(x),.y(y), .displayContents(d[42]), .x_desired(10'd280), .y_desired(10'd210));

        textGeneration c43 (.clk(clk),.reset(reset),.asciiData(a[43]), .ascii_In(7'h4d),
        .x(x),.y(y), .displayContents(d[43]), .x_desired(10'd288), .y_desired(10'd210));

        textGeneration c44 (.clk(clk),.reset(reset),.asciiData(a[44]), .ascii_In(7'h45),
        .x(x),.y(y), .displayContents(d[44]), .x_desired(10'd296), .y_desired(10'd210));

        textGeneration c45 (.clk(clk),.reset(reset),.asciiData(a[45]), .ascii_In(7'h53),
        .x(x),.y(y), .displayContents(d[45]), .x_desired(10'd304), .y_desired(10'd210));

        textGeneration c46 (.clk(clk),.reset(reset),.asciiData(a[46]), .ascii_In(7'h55),
        .x(x),.y(y), .displayContents(d[46]), .x_desired(10'd320), .y_desired(10'd210));

        textGeneration c47 (.clk(clk),.reset(reset),.asciiData(a[47]), .ascii_In(7'h50),
        .x(x),.y(y), .displayContents(d[47]), .x_desired(10'd328), .y_desired(10'd210));

        textGeneration c48 (.clk(clk),.reset(reset),.asciiData(a[48]), .ascii_In(7'h44),
        .x(x),.y(y), .displayContents(d[48]), .x_desired(10'd272), .y_desired(10'd270));

        textGeneration c49 (.clk(clk),.reset(reset),.asciiData(a[49]), .ascii_In(7'h49),
        .x(x),.y(y), .displayContents(d[49]), .x_desired(10'd280), .y_desired(10'd270));

        textGeneration c50 (.clk(clk),.reset(reset),.asciiData(a[50]), .ascii_In(7'h53),
        .x(x),.y(y), .displayContents(d[50]), .x_desired(10'd288), .y_desired(10'd270));

        textGeneration c51 (.clk(clk),.reset(reset),.asciiData(a[51]), .ascii_In(7'h54),
        .x(x),.y(y), .displayContents(d[51]), .x_desired(10'd296), .y_desired(10'd270));
        
        textGeneration c52 (.clk(clk),.reset(reset),.asciiData(a[52]), .ascii_In(distThousands), //0
        .x(x),.y(y), .displayContents(d[52]), .x_desired(10'd320), .y_desired(10'd270)); 
        
        textGeneration c53 (.clk(clk),.reset(reset),.asciiData(a[53]), .ascii_In(distHundreds), //0
        .x(x),.y(y), .displayContents(d[53]), .x_desired(10'd328), .y_desired(10'd270));   
        
        textGeneration c54 (.clk(clk),.reset(reset),.asciiData(a[54]), .ascii_In(distTens), //0
        .x(x),.y(y), .displayContents(d[54]), .x_desired(10'd336), .y_desired(10'd270));   
        
        textGeneration c55 (.clk(clk),.reset(reset),.asciiData(a[55]), .ascii_In(distOnes), //0
        .x(x),.y(y), .displayContents(d[55]), .x_desired(10'd344), .y_desired(10'd270));
        
        textGeneration c56 (.clk(clk),.reset(reset),.asciiData(a[56]), .ascii_In(HThousands), //0
        .x(x),.y(y), .displayContents(d[56]), .x_desired(10'd512), .y_desired(10'd96)); 
        
        textGeneration c57 (.clk(clk),.reset(reset),.asciiData(a[57]), .ascii_In(HHundreds), //0
        .x(x),.y(y), .displayContents(d[57]), .x_desired(10'd520), .y_desired(10'd96));   
        
        textGeneration c58 (.clk(clk),.reset(reset),.asciiData(a[58]), .ascii_In(HTens), //0
        .x(x),.y(y), .displayContents(d[58]), .x_desired(10'd528), .y_desired(10'd96));   
        
        textGeneration c59 (.clk(clk),.reset(reset),.asciiData(a[59]), .ascii_In(HOnes), //0
        .x(x),.y(y), .displayContents(d[59]), .x_desired(10'd536), .y_desired(10'd96));
        
   
 //Decoder to trigger displayContents signal high or low depending on which ASCII char is reached
    wire display_sprite;
    wire [11:0] spriteData;
    wire display_sprite_2;
    wire [11:0] spriteData_2;
    wire display_sprite_3;
    wire [11:0] spriteData_3;
    reg [9:0] sprite_x; 
    reg [23:0] clk_div; // 30-bit register for clock division
    wire slow_clk = clk_div[23]; // Use the MSB as the slower clock signal
    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_div <= 24'd0; // Reset the counter to 0
        else
            clk_div <= clk_div + 5; // Increment the counter
    end

    always @(posedge slow_clk or posedge reset) begin
    if (reset) 
        sprite_x <= 10'd0; // Reset the x coordinate
    else if (sprite_x>632)
        sprite_x<=10'd0;
    else 
        sprite_x <= sprite_x + 1; // Increment x coordinate
    end

    sprite_display sprite1(.clk(clk),.reset(reset),.home_page(home_page), .x_desired(sprite_x),.y_desired(10'd200),.x(x),.y(y),.spriteData(spriteData),.display_sprite(display_sprite));
    
    sprite_display sprite2(.clk(clk),.reset(reset),.home_page(home_page),.x_desired(sprite_x),.y_desired(10'd270),.x(x),.y(y),.spriteData(spriteData_2),.display_sprite(display_sprite_2));
    
    sprite_display sprite3(.clk(clk),.reset(reset),.home_page(home_page),.x_desired(sprite_x),.y_desired(10'd300),.x(x),.y(y),.spriteData(spriteData_3),.display_sprite(display_sprite_3));
    
assign displayContents = (home_page == 0) ? 
                    (times_up == 0) ? 
                    (d[0] ? d[0] :
                    d[1] ? d[1] :
                    d[2] ? d[2] :
                    d[3] ? d[3] :
                    d[4] ? d[4] :
                    d[5] ? d[5] :
                    d[6] ? d[6] :
                    d[7] ? d[7] :
                    d[8] ? d[8] :
                    d[9] ? d[9] :
                    d[10] ? d[10] :
                    d[11] ? d[11] :
                    d[12] ? d[12] :
                    d[13] ? d[13] :
                    d[14] ? d[14] :
                    d[15] ? d[15] :
                    d[16] ? d[16] :
                    d[17] ? d[17] :
                    d[19] ? d[19] :
                    d[20] ? d[20] :
                    d[21] ? d[21] :
//                    d[22] ? d[22] :
                    d[18] ? d[18] :
                    d[32] ? d[32] :
                    d[33] ? d[33] :
                    d[34] ? d[34] :
                    d[35] ? d[35] :
                    d[36] ? d[36] :
                    d[37] ? d[37] :
                    d[38] ? d[38] :
                    d[39] ? d[39] :
                    d[40] ? d[40] :
                    d[56] ? d[56] :
                    d[57] ? d[57] :
                    d[58] ? d[58] :
                    d[59] ? d[59] :
                    display_sprite ? display_sprite : 0) : //times_up == 1
                    (d[41] ? d[41] :
                    d[42] ? d[42] :
                    d[43] ? d[43] :
                    d[44] ? d[44] :
                    d[45] ? d[45] :
                    d[46] ? d[46] :
                    d[47] ? d[47] :
                    d[48] ? d[48] :
                    d[49] ? d[49] :
                    d[50] ? d[50] :
                    d[51] ? d[51] :
                    d[52] ? d[52] :
                    d[53] ? d[53] :
                    d[54] ? d[54] :
                    d[55] ? d[55] :
                    display_sprite_3 ? display_sprite_3: 0) : 
                    (d[23] ? d[23] : //home_page is == 1
                    d[24] ? d[24] :
                    d[25] ? d[25] :
                    d[26] ? d[26] :
                    d[27] ? d[27] :
                    d[28] ? d[28] :
                    d[29] ? d[29] :
                    d[30] ? d[30] :
                    d[31] ? d[31] :
                    display_sprite_2 ? display_sprite_2 : 0);
//Decoder to assign correct ASCII value depending on which displayContents signal is used                        
assign ascii = d[0] ? a[0] :
                d[1] ? a[1] :
                d[2] ? a[2] :
                d[3] ? a[3] :
                d[4] ? a[4] :
                d[5] ? a[5] :
                d[6] ? a[6] :
                d[7] ? a[7] :
                d[8] ? a[8] :
                d[9] ? a[9] :
                d[10] ? a[10] :
                d[11] ? a[11] :
                d[12] ? a[12] :
                d[13] ? a[13] :
                d[14] ? a[14] :
                d[15] ? a[15] :
                d[16] ? a[16] :
                d[17] ? a[17] :
                d[19] ? a[19] :
                d[20] ? a[20] :
                d[21] ? a[21] :
                d[22] ? a[22] :
                d[18] ? a[18] : 
                d[23] ? a[23] :
                d[24] ? a[24] :
                d[25] ? a[25] :
                d[26] ? a[26] :
                d[27] ? a[27] :
                d[28] ? a[28] :
                d[29] ? a[29] :
                d[30] ? a[30] :
                d[31] ? a[31] : 
                d[32] ? a[32] : 
                d[33] ? a[33] : 
                d[34] ? a[34] : 
                d[35] ? a[35] : 
                d[36] ? a[36] : 
                d[37] ? a[37] : 
                d[38] ? a[38] : 
                d[39] ? a[39] : 
                d[40] ? a[40] : 
                d[40] ? a[40] :
                d[41] ? a[41] :
                d[42] ? a[42] :
                d[43] ? a[43] :
                d[44] ? a[44] :
                d[45] ? a[45] :
                d[46] ? a[46] :
                d[47] ? a[47] :
                d[48] ? a[48] :
                d[49] ? a[49] :
                d[50] ? a[50] :
                d[51] ? a[51] :
                d[52] ? a[52] :
                d[53] ? a[53] :
                d[54] ? a[54] :
                d[55] ? a[55] :
                d[56] ? a[56] :
                d[57] ? a[57] :
                d[58] ? a[58] :
                d[59] ? a[59] : 7'h30; //default to 0

 
 //ASCII_ROM////////////////////////////////////////////////////////////       
    //Connections to ascii_rom
    wire [10:0] rom_addr;
    //Handle the row of the rom
    wire [3:0] rom_row;
    //Handle the column of the rom data
    wire [2:0] rom_col;
    //Wire to connect to rom_data of ascii_rom
    wire [7:0] rom_data;
    //Bit to signal display of data
    wire rom_bit;
    ascii_rom rom1(.clk(clk), .rom_addr(rom_addr), .data(rom_data));

    //Concatenate to get 11 bit rom_addr
    assign rom_row = y[3:0];
    assign rom_addr = {ascii, rom_row};
    assign rom_col = x[2:0];
    assign rom_bit = rom_data[~rom_col]; //need to negate since it initially displays mirrored
///////////////////////////////////////////////////////////////////////////////////////////////
    
    //If video on then check
        //If rom_bit is on
            //If x and y are in the origin/end range
                //Set RGB to display whatever is in the ROM within the origin/end range
            //Else we are out of range so we should not modify anything, RGB set to blue
        //rom_bit is off display blue
    //Video_off display black
            
    //assign rgb = video_on ? (rom_bit ? ((displayContents) ? 12'hFFF: 12'h8): 12'h8) : 12'b0; //blue background white text
    
assign rgb = video_on ? (       //add changes here
               home_page == 1 ? display_sprite_2 ? spriteData_2 : (rom_bit ? (displayContents ? 12'hFFF :12'h000) : 12'h000) :
               times_up == 1 ?  display_sprite_3 ? spriteData_3 : (rom_bit ? (displayContents ? 12'hFFF :12'h000) : 12'h000) :
               (display_sprite ? spriteData :  // If sprite is being displayed, use spriteData
               (rom_bit ? (displayContents ? 12'hFFF :12'h000) : 12'h000))
            ) : 12'b0;
endmodule

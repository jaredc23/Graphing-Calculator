/**
This module controls the HDMI through horizontal and vertical sync in order to
keep track of the pixel location. It uses RAM to store
-----------------------------------------------------------------------------
*/


module vgaHdmi
(
  // **input**
  input clock, clock50, reset,
  input [3:0] color,
  input [19:0] address,
  input writeEnable,
  output [7:0]LED,

  // **output**
  output reg hsync, vsync,
  output reg dataEnable,
  output reg vgaClock,
  output [23:0] RGBchannel
);

reg [9:0]pixelH, pixelV; //The vertical and horizontal pixel

initial begin
  hsync      = 1;
  vsync      = 1;
  pixelH     = 0;
  pixelV     = 0;
  dataEnable = 0;
  vgaClock   = 0;
end

// Sets the horizontal and vertial pixel by keeping track of the region.

always @(posedge clock or posedge reset) begin
  if(reset) begin
    hsync  <= 1;
    vsync  <= 1;
    pixelH <= 0;
    pixelV <= 0;
  end
  else begin
    // Display Horizontal
    if(pixelH==0 && pixelV!=524) begin
      pixelH<=pixelH+1'b1;
      pixelV<=pixelV+1'b1;
    end
    else if(pixelH==0 && pixelV==524) begin
      pixelH <= pixelH + 1'b1;
      pixelV <= 0; // pixel 525
    end
    else if(pixelH<=640) pixelH <= pixelH + 1'b1;
    // Front Porch
    else if(pixelH<=656) pixelH <= pixelH + 1'b1;
    // Sync Pulse
    else if(pixelH<=752) begin
      pixelH <= pixelH + 1'b1;
      hsync  <= 0;
    end
    // Back Porch
    else if(pixelH<799) begin
      pixelH <= pixelH+1'b1;
      hsync  <= 1;
    end
    else pixelH<=0; // pixel 800

    // Manejo Senal Vertical
    // Sync Pulse
    if(pixelV == 491 || pixelV == 492)
      vsync <= 0;
    else
      vsync <= 1;
  end
end

// dataEnable signal
always @(posedge clock or posedge reset) begin
  if(reset) dataEnable<= 0;

  else begin
    if(pixelH >= 0 && pixelH <640 && pixelV >= 0 && pixelV < 480)
      dataEnable <= 1;
    else
      dataEnable <= 0;
  end
end

// VGA pixeClock signal
initial vgaClock = 0;

always @(posedge clock50 or posedge reset) begin
  if(reset) vgaClock <= 0;
  else      vgaClock <= ~vgaClock;
end 

wire [3:0] qcolor; //Color number from the RAM
//wire [23:0] rgbvalue;


dual_port_ram dual_inst(
	.data(color),//1'b1),
	.read_addr({pixelV, pixelH}),
	.write_addr(address),
	.we(writeEnable),
	.read_clock(clock50),
	.write_clock(~clock50),
	.q(qcolor)
);

color_mux_16colors mux_inst(
	.sel(qcolor),
	.out(RGBchannel)
);
endmodule


//This is a 4 to 16 multiplexer to allow for 16 colors.
// Uses Microsoft Windows and IBM OS/2 default 16-color palette

module color_mux_16colors (
	input [3:0] sel,
	output reg [23:0] out
);	

	always @(sel) begin //Change when select changes
		case(sel)
			4'b0000 : out <= 24'h000000; //Black
			4'b0001 : out <= 24'h800000; //Dark Red
			4'b0010 : out <= 24'h008000; //Dark Green
			4'b0011 : out <= 24'h808000; //Dark Yellow
			4'b0100 : out <= 24'h000080; //Dark Blue
			4'b0101 : out <= 24'h800080; //Dark Magenta
			4'b0110 : out <= 24'h008080; //Dark Cyan
			4'b0111 : out <= 24'hC0C0C0; //Light Grey
			4'b1000 : out <= 24'h808080; //Dark Grey
			4'b1001 : out <= 24'hFF0000; //Red
			4'b1010 : out <= 24'h00FF00; //Green
			4'b1011 : out <= 24'hFFFF00; //Yellow
			4'b1100 : out <= 24'h0000FF; //Blue
			4'b1101 : out <= 24'hFF00FF; //Magenta
			4'b1110 : out <= 24'h00FFFF; //Light Cyan
			4'b1111 : out <= 24'hFFFFFF; //White
		endcase
	end
	
endmodule



// Quartus Prime Verilog Template (With minor edits)
// Simple Dual Port RAM with separate read/write addresses and
// separate read/write clocks

module dual_port_ram
#(parameter DATA_WIDTH=4, parameter ADDR_WIDTH=20)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, read_clock, write_clock,
	output /*reg */[(DATA_WIDTH-1):0] q
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	always @ (posedge write_clock)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;
	end

	assign q = ram[read_addr]; //Made it continous reading, which got rid of timing errors in the pixels
	
endmodule

//---------------------------------------------------------------


/**
Descripcion,
Modulo que sincroniza las senales (hsync y vsync)
de un controlador VGA de 640x480 60hz, funciona con un reloj de 25Mhz

Ademas tiene las coordenadas de los pixeles H (eje x),
y de los pixeles V (eje y). Para enviar la senal RGB correspondiente
a cada pixel

-----------------------------------------------------------------------------
Author : Nicolas Hasbun, nhasbun@gmail.com
File   : vgaHdmi.v
Create : 2017-06-15 15:07:05
Editor : sublime text3, tab size (2)
-----------------------------------------------------------------------------
*/

// **Info Source**
// https://eewiki.net/pages/viewpage.action?pageId=15925278

module vgaHdmi
(
  // **input**
  input clock, clock50, reset,
  input [3:0] color,
  input [19:0] address,
  input writeEnable,
  //output [7:1]LED,

  // **output**
  output reg hsync, vsync,
  output reg dataEnable,
  output reg vgaClock,
  output [23:0] RGBchannel
);

reg [9:0]pixelH, pixelV; // estado interno de pixeles del modulo
//reg [23:0] color_map [3:0];
//reg [23:0] color;
//reg [31:0] xoff, yoff, xmin, xmax, ymin, ymax;

initial begin
  hsync      = 1;
  vsync      = 1;
  pixelH     = 0;
  pixelV     = 0;
  dataEnable = 0;
  vgaClock   = 0;
  
  //color_map[0]= 24'b0; //Black
  //color_map[1]= 24'b111111111111111111111111; //White
  //color_map[2]= 24'b11111111; //Blue
  //color_map[3]= 24'b111111110000000000000000; //Red
end

// Manejo de Pixeles y Sincronizacion

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
// Los clocks no deben manejar salidas directas, se debe usar un truco
initial vgaClock = 0;

always @(posedge clock50 or posedge reset) begin
  if(reset) vgaClock <= 0;
  else      vgaClock <= ~vgaClock;
end 

wire [3:0] color_;

dual_port_ram #(4, 20) dual_inst(
	.data(color),
	.read_addr({pixelV, pixelH}),
	.write_addr(address),//{10'd240, 10'd320}),//address),
	.we(writeEnable),
	.read_clock(clock50),
	.write_clock(~clock50),
	.q(color_)
);

assign RGBchannel = color_[0] ? 24'b111111111111111111111111 : 24'b0;//color_map[color_];

endmodule


// Quartus Prime Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// separate read/write clocks

module dual_port_ram
#(parameter DATA_WIDTH=24, parameter ADDR_WIDTH=18)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, read_clock, write_clock,
	output reg [(DATA_WIDTH-1):0] q
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	always @ (posedge write_clock)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;
	end
	
	always @ (posedge read_clock)
	begin
		// Read 
		q <= ram[read_addr];
	end
	
endmodule



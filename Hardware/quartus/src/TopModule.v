/**
This module interfaces with the I2C and the vgaHDMI module, it creates a resolution of 640x480
*/

`include "vgaHdmi.v"
`include "i2c/I2C_HDMI_Config.v"

module TopModule(
  // **input**
  input clock50, reset_n, 
  input [3:0] color,
  input [19:0] address,
  input writeEnable,
  output [7:0] LED,

  // ********************************** //
  // ** HDMI CONNECTIONS **

  // AUDIO
  // These are disconnected, because they are not used
  output HDMI_I2S0,
  output HDMI_MCLK,
  output HDMI_LRCLK,
  output HDMI_SCLK,

  // VIDEO
  output [23:0] HDMI_TX_D, // RGBchannel
  output HDMI_TX_VS,  // vsync
  output HDMI_TX_HS,  // hsync
  output HDMI_TX_DE,  // dataEnable
  output HDMI_TX_CLK, // vgaClock

  // REGISTERS AND CONFIG LOGIC
  // HPD viene del conector
  input HDMI_TX_INT,
  inout HDMI_I2C_SDA,  // HDMI i2c data
  output HDMI_I2C_SCL, // HDMI i2c clock
  output READY        // HDMI is ready signal from i2c module
  // ********************************** //
  );

wire clock25, locked;
wire reset;
assign reset = ~reset_n; //

//Set the audio to high impedance
assign HDMI_I2S0  = 1'b z;
assign HDMI_MCLK  = 1'b z;
assign HDMI_LRCLK = 1'b z;
assign HDMI_SCLK  = 1'b z;

// **VGA CLOCK**
pll_25 pll_25(
  .refclk(clock50),
  .rst(reset),

  .outclk_0(clock25),
  .locked(locked)
  );

// **VGA MAIN CONTROLLER**
vgaHdmi vgaHdmi (
  // input
  .clock      (clock25),
  .clock50    (clock50),
  .reset      (~locked),
  .hsync      (HDMI_TX_HS),
  .vsync      (HDMI_TX_VS),
  .color		  (color),
  .address    (address),
  .writeEnable(writeEnable),
  .LED		  (LED),

  // output
  .dataEnable (HDMI_TX_DE),
  .vgaClock   (HDMI_TX_CLK),
  .RGBchannel (HDMI_TX_D)
);

// **I2C Interface for ADV7513 initial config**
I2C_HDMI_Config #(
  .CLK_Freq (50000000), // 50MHz
  .I2C_Freq (20000)    // 20kHz for i2c clock
  )

  I2C_HDMI_Config (
  .iCLK        (clock50),
  .iRST_N      (reset_n),
  .I2C_SCLK    (HDMI_I2C_SCL),
  .I2C_SDAT    (HDMI_I2C_SDA),
  .HDMI_TX_INT (HDMI_TX_INT),
  .READY       (READY)
);

endmodule
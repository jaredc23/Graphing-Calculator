# FPGA Graphing Calculator
This project is a graphing calculator using the DE10-Nano FPGA. The interfaces the onboard ADV7513 in order to drive an HDMI display, as well as interfacing with the HPS of the SoC to be controlled via C or C++ code.

Features
- 640x480 HDMI display
- 16 colors
- Simple and easy to use C++ library to write to the display
- Graphing library
    - Graphs any 2D function
    - Customizable line width and color
    - Animated line drawing option
    - Various gridline options

# How to use
## Hardware
This project was compiled and tested on the DE10-Nano SoC. You can use the Quartus project included in [Hardware/quartus](https://github.com/jaredc23/Graphing-Calculator/tree/main/Hardware/quartus) to compile and run the project. It may also be possible to use the [Hardware/quartus/output_files/vgaHDMI.sof](https://github.com/jaredc23/Graphing-Calculator/blob/main/Hardware/quartus/output_files/vgaHdmi.sof) file directly without prior compilation, in order to avoid the near 8 minute compilation time. Once uploaded, a black screen should appear out of the HDMI. For most displays, there will also be some confimation that the source is active.

## Software
In order to use the software aspect of the project, the code must be uploaded to the HPS side of the FPGA. The software communicates to the hardware through PIO ports by changing the value of some designated registers. In order to verify the proper usage, there is a test file ([Software/main.cpp](https://github.com/jaredc23/Graphing-Calculator/blob/main/Software/main.cpp)) which draws 4 different functions, the fourth being animated. This utilizes the Graph class, showing all of it's capabilities. 

There is also the HDMI class included, which can be used separate of the Graphing class, therefore it is possible to make other applications that use an HDMI display.

# To-Do
There is still some aspects of this project that could be explored. Here are some things of interest that may be added some time in the future.
- More colors
    - Due to space constraints on the FPGA, only 16 colors were added. For a graphing application, this is more than enough, but for any other application this may be quite limiting. Therefore, it might be useful to find a way to add more colors in the future.
- User interface
    - It would be very interesting to add more to the display, such as numbers on the axis to show units, or a keyboard interface to make a way to graph without needing to recode and run.

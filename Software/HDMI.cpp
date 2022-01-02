/* 
 * @file HDMI.cpp
 * @author	Jared Cohen (cohen.jar@northeastern.edu)
 * @date	Dec 2 2021
 * @brief	This is the .cpp file in which the HDMI class is made, implements the HDMI class's methods.
 */


#include <iostream>
using namespace std;

#include "HDMI.h"

HDMI::HDMI()
{
    //Nothing to do
}

HDMI::~HDMI()
{
    //Nothing to do
}

//Formats an integer to send via the PIO output. 
int HDMI::getPixelInfo(int x, int y, int color, int enable)
{
    int toSend = color << 10; //Format of the integer:    ccccyyyyyyyyyyxxxxxxxxxxe -> c=color, y = ycoord, x = xcoord, e = write_enable
    return (  (  ((toSend + y)<<10) + x)    << 1) + enable;
}

//Writes a single pixel in the screen with a given color.
void HDMI::writePixel(int x, int y, int color)
{
    int pixel = getPixelInfo(x, y, color, 1);
    WritePIOout(pixel);
    WritePIOout(pixel - 1);
}

//Fills the entire screen with a certain color
void HDMI::writeScreen(int color)
{
    for(int x = 0; x <= 640; x++)
        for(int y = 0; y <= 480; y++)
            WritePIOout(getPixelInfo(x, y, color, 1));

    WritePIOout(0);
}
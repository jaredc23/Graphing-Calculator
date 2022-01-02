/* 
 * @file HDMI.h
 * @author  Jared Cohen (cohen.jar@northeastern.edu)
 * @date	Dec 2 2021
 * @brief	This is the .h file in which the HDMI class is prototyped, it will be used to communicate with the HDMI screen.
 */

#ifndef HDMI_H
#define HDMI_H

#include "PIOControl.h"

//const unsigned int OUT_BASE  = 0x00003000;   // PIO output  Constants used to communicate vio PIOs
//const unsigned int IN_BASE   = 0x00005000;   // PIO input

class HDMI : public PIOControl
{
    private:
        int getPixelInfo(int x, int y, int color, int enable); //Gets the integer information of a pixel
    public:
        HDMI();
        ~HDMI();
        void writePixel(int x, int y, int color); //Writes a single pixel to the screen
        void writeScreen(int color); //Writes an entire screen a certain color
};


#endif
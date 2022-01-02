/* 
 * @file PIOControl.h
 * @author  Jared Cohen (cohen.jar@northeastern.edu)
 * @date	Dec 2 2021
 * @brief	This is the .h file in which the PIO class is prototyped, it will be used to communicate with the pio registers made in Quartus.
 */

#ifndef PIOCONTROL_H
#define PIOCONTROL_H

#include "DE1SoCfpga.h"

//LED control class, used for reading and writing to LEDs and switches on the FPGA board
class PIOControl : public DE1SoCfpga
{
  private:
    unsigned int out_regValue; //Private variables
    unsigned int in_regValue;
  public:
    PIOControl(); //Constructor method
    ~PIOControl(); //Destructor
    void WritePIOout(int value); //Prototypes for the rest of the functions
    int ReadPIOIn();
};


#endif

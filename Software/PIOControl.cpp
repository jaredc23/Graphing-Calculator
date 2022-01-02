/* 
 * @file PIOControl.cpp
 * @author	Jared Cohen (cohen.jar@northeastern.edu)
 * @date	Dec 2 2021
 * @brief	This is the .cpp file in which the PIO class is made, it will be used to communicate with the pio registers made in Quartus.
 */

#include <iostream>
#include "PIOControl.h"
using namespace std;


PIOControl::PIOControl() //Constructor
{
  out_regValue = RegisterRead(OUT_BASE);
  in_regValue = RegisterRead(IN_BASE);
}

PIOControl::~PIOControl() //Close the LEDs and alert the user
{
}


void PIOControl::WritePIOout(int value) //Writes to the PIOout register of the fpga
{
  //RegisterWrite(OUT_BASE, value); //Call register write with the out_base register
  //while(ReadPIOIn() == 0){}
  RegisterWrite(OUT_BASE, value + 1);
  RegisterWrite(OUT_BASE, value);
}

int PIOControl::ReadPIOIn() //Reads the PIOout register of the fpga
{
  return RegisterRead(IN_BASE); //Call register write with the in_base register
}
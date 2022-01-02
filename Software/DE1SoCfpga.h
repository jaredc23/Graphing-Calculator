#ifndef DE1SOCFPGA_H
#define DE1SOCFPGA_H


const unsigned int LW_BRIDGE_BASE 	= 0xFF200000;  // Base offset 
// Length of memory-mapped IO window 
const unsigned int LW_BRIDGE_SPAN 	= 0x00040000;  // Address map size

const unsigned int OUT_BASE  = 0x00003000;   // PIO output
const unsigned int IN_BASE   = 0x00005000;   // PIO input

class DE1SoCfpga{

  private:
    char *pBase; //Class variables for the base address
    int fd; //Used to open memory (/dev/mem)
  public:
    DE1SoCfpga();
    ~DE1SoCfpga();
    int RegisterRead(unsigned int reg_offset);
    void RegisterWrite(unsigned int reg_offset, int value);
};

#endif
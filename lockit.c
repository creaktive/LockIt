#include <cmos.h>

int main(void)
{
   WriteCMOS(0x11, ReadCMOS(0x11) | 0x3);

   WriteCMOS(0x1C, 0x8B);
   WriteCMOS(0x1D, 0x53);

   ChecksumUpdate();

   return 0;
}
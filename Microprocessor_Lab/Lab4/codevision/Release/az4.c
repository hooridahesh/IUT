#include <myheaders.h>

void main(void)
{
// Declare your local variables here

init();
DDRC = 0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      }
}



#include "headers.h"
#include "init_config.h"
#include "subtask.h"

void main(void)
{
   char entered;
   char subtask3_entered[10];

#asm("sei")

   init_configs();

   print_lcd("part2 is running!");
   print_terminal("part2 is running!\r\nEnter a character:");

   while (1)
   {

      entered = getchar();

      if (subtask2(entered) == -1)
      {
         print_lcd("Part2 is ending!");
         print_terminal("Part2 is ending!");
         delay_ms(2000);
         break;
      }
   }

   print_lcd("part3 is running!");
   print_terminal("Part3 is running!");

   while (1)
   {
      print_terminal("Enter a 5 digits number with this format: (number)");
      scanf("%s", subtask3_entered);
      subtask3(subtask3_entered);
   }
}
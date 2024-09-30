#include "sub_tasks.h"

void main(void)
{

#asm("sei");

  init_program_configs();
  q5_subTask();

  while (1)
  {
    q4_subTask();
  }
}

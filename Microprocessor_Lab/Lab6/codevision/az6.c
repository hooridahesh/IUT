

#include <headers.h>

long int adc_data[LAST_ADC_INPUT - FIRST_ADC_INPUT + 1];

void main(void)
{
  subTask1();
  delay_ms(1000);

  init_Q3();

  while (1)
  {
    subTask3();
    subTask2();
  }
}

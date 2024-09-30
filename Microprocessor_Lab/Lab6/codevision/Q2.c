#include <headers.h>


// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char input_index=0;
// Read the AD conversion result
adc_data[input_index]=ADCW;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
}

void init_Q2(){

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
//ADC Auto Trigger Source: Free Running
ADMUX=FIRST_ADC_INPUT | ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (1<<ADSC) | (1<<ADATE) | (0<<ADIF) | (1<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);


// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);  
    
    
// Global enable interrupts
#asm("sei") 
}

void subTask2()
{
    char msg[20];

    init_Q2();   

    lcd_clear();
    sprintf(msg, "Q2\nADC0 => %d mV", ((adc_data[0] * 5000)/ 1023) );
    lcd_puts(msg);
    delay_ms(500);
    subTask3();
    
    lcd_clear();
    sprintf(msg, "Q2\nADC1 => %d mV", ((adc_data[1] * 5000)/ 1023));
    lcd_puts(msg);
    delay_ms(500);
    subTask3();
    
    lcd_clear();
    sprintf(msg, "Q2\nADC2 => %d mV", ((adc_data[2] * 5000)/ 1023));
    lcd_puts(msg);
    delay_ms(500);
    subTask3();    
    
    lcd_clear();
    sprintf(msg, "Q2\nADC3 => %d mV", ((adc_data[3] * 5000)/ 1023));
    lcd_puts(msg);
    delay_ms(500);
    subTask3();
    
    lcd_clear();
    sprintf(msg, "Q2\nADC4 => %d mV", ((adc_data[4] * 5000)/ 1023));
    lcd_puts(msg);
    delay_ms(500);
    subTask3();
    
    lcd_clear();
    sprintf(msg, "Q2\nADC5 => %d mV", ((adc_data[5] * 5000)/ 1023));
    lcd_puts(msg);
    delay_ms(500);
    subTask3();
    
    lcd_clear();
    sprintf(msg, "Q2\nADC6 => %d mV", ((adc_data[6] * 5000)/ 1023));
    lcd_puts(msg);
    delay_ms(500);
    subTask3();
    
    lcd_clear();
    sprintf(msg, "Q2\nADC7 => %d mV", ((adc_data[7] * 5000)/ 1023));
    lcd_puts(msg);
    delay_ms(500);
    subTask3();        
}
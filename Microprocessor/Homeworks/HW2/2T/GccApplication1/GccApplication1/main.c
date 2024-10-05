
//Asynchronous --- Transfer

#include <avr/io.h>
#include <avr/interrupt.h>

ISR(USART_UDRE_vect)
{
	UDR = 'H';	       //H=48 --> 0100 1000
}


int main(void)
{
	UCSRB |=(1<<TXEN) | (1<<UDRIE);
	UCSRC |=(1<<UCSZ1) | (1<<UCSZ0) | (1<<URSEL);
	UBRRL = 0X33;
	
	sei();
	while(1);
	return 0;	
}


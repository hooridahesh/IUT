
//Synchronous --- Transfer

#include <avr/io.h>
#include <avr/interrupt.h>

ISR(USART_UDRE_vect)
{
	UDR = 'M';	       //H=48 --> 0100 1000
}


int main(void)
{
	
	DDRB = 0xFF;
	UCSRB =(1<<TXEN) | (1<<UDRIE);
	UCSRC =(1<<UCSZ1) | (1<<UCSZ0) | (1<<URSEL) | (1<<UMSEL) | (1<<UCPOL);
	UBRRL = 0X33;

	sei();
	while(1);
	return 0;
}



//Synchronous --- Receive

#include <avr/io.h>
#include <avr/interrupt.h>

ISR(USART_RXC_vect)
{
	PORTA=UDR;	       //H=48 --> 0100 1000
}


int main(void)
{
	DDRA = 0XFF;
	DDRB = 0x00; 
	UCSRB = (1<<RXEN) | (1<<RXCIE);
	UCSRC = (1<<UCSZ1) | (1<<UCSZ0) | (1<<URSEL) | (1<<UMSEL) | (1<<UCPOL);
	UBRRL = 0X33;

	sei();
	while(1);
	return 0;
}


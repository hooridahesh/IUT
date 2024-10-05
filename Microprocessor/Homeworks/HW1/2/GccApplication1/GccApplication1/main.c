
#include <avr/io.h>
#include <avr/interrupt.h>

int main( )
{
	DDRB |= 0b00100000;
	TCNT0 = -8;           //1  , 8 MHz
	TCCR0 = 0x01;
	
	TIMSK = (1<<TOIE0);
	sei ();
	
	DDRC = 0x00;
	DDRD = 0xFF;
	
	while (1)
	PORTD = PINC;
	
}

ISR (TIMER0_OVF_vect)
{
	
	TCNT0 = -8;
	PORTB ^= 0x20;
}
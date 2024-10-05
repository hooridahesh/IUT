
#include <avr/io.h>


int main( )
{
	DDRB &= 0b11111101;
	DDRC = 0xFF;
	DDRD = 0xFF;
	
	
	TCCR1A = 0x00;
	TCCR1B = 0X07;
	
	TCNT1H = 0x00;
	TCNT1L = 0x00;
	
	
	
	while (1)
	{
		PORTC = TCNT1L;
		PORTD = TCNT1H;

		if(TIFR & (1<<TOV1))
			TIFR = 1<<TOV1;
	}
}
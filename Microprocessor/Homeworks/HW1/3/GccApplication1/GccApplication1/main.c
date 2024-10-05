
#include <avr/io.h>
#include <avr/interrupt.h>


int main(void)
{
	PORTC=0;
	DDRC = 0xFF;
	DDRD |= (1 << PD4) | (1 << PD2) | (1 << PD3);
	 
	TCNT0 = -8;             //1 , 8MHz
	TCCR0 = 0x01;
	TIMSK |= (1<<TOIE0);
	MCUCR |= (1 << ISC01) | (1 << ISC11);
	GICR |= (1 << INT0) | (1 << INT1);
	GIFR |= (1 << INTF0) | (1 << INTF1);
	sei();
	
	while (1){}
	
}

ISR(TIMER0_OVF_vect){
	if (PORTC >100 && PORTC<200) {
		TCNT0 = -8;
		PORTD ^= 0b00010000;
	}
}

ISR(INT0_vect) {
	PORTC++;
}

ISR(INT1_vect) {
	if (PORTC > 0) {
		PORTC--;
	}
}

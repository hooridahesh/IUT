#include <io.h>
#include <delay.h>

unsigned char i;

unsigned int sevenSeg[] = {
    0b00111111, // number 0 on 7_seg
    0b00000110, // number 1 on 7_seg
    0b01011011, // number 2 on 7_seg
    0b01001111, // number 3 on 7_seg
    0b01100110, // number 4 on 7_seg
    0b01101101, // number 5 on 7_seg
    0b01111101, // number 6 on 7_seg
    0b00000111, // number 7 on 7_seg
    0b01111111, // number 8 on 7_seg
    0b01101111, // number 9 on 7_seg
};


void subRoutine1();
void subRoutine2();
void subRoutine3();
void subRoutine4();
void subRoutine5();
void subRoutine6();


void main(void)
{
    DDRA = 0x00;
    DDRB = 0xFF;
    DDRC = 0xFF;
    DDRD = 0x0F;
    
    while(1){
        subRoutine1();
        subRoutine2(); 
        subRoutine3();
        subRoutine4();
        subRoutine5();
        subRoutine6();  
    }
    
}

void subRoutine1()
{
    for (i = 0; i < 4; i++)
    {
        delay_ms(500);
        PORTB = 0xFF; 
        delay_ms(500);
        PORTB = 0x00; 
        delay_ms(500);
    }
}

void subRoutine2()
{
    unsigned char LED_Position = 1;
    for (i=0; i<8; i++)
    {
        PORTB = LED_Position; 
        delay_ms(3000);
        LED_Position = (LED_Position << 1);
    }   
    PORTB.7 = 0;
}

void subRoutine3()
{
    PORTB = PINA;
    delay_ms(2000);
    PORTB = 0x00;
    delay_ms(500);
}

void subRoutine4()
{
    PORTD = 0x00;

    for (i=9; i!= 0b11111111; i--)
    {
        PORTC = sevenSeg[i];
        delay_ms(2000);
    }
}

void subRoutine5()
{
    unsigned int h, s, d, y, number;

    number = PINA;
    number = number * 10;

    while (number >= 0)
    {
        h = number / 1000;
        s = (number % 1000) / 100;
        d = (number % 100) / 10;
        y = number % 10;
        
        if (h == 0 && s == 0 && d == 0 && y == 0) {
            break;
        }
        
        for (i = 0; i < 20; i++)
        {
            PORTD = 0b0111;
            PORTC = sevenSeg[y];
            delay_ms(5);
            PORTD = 0b1111;

            PORTD = 0b1011;
            PORTC = sevenSeg[d] + 0x80;
            delay_ms(5);
            PORTD = 0b1111;

            PORTD = 0b1101;
            PORTC = sevenSeg[s];
            delay_ms(5);
            PORTD = 0b1111;

            PORTD = 0b1110;
            PORTC = sevenSeg[h];
            delay_ms(5);
            PORTD = 0b1111;
        }

        delay_ms(200);

        number -= 2;
    }
}

void subRoutine6()
{
    unsigned int h, s, d, y, number;
    int key_state; 

    number = PINA;
    number = number * 10;
    key_state = PIND & 0xF0; 

    while (number >= 0)
    {
        h = number / 1000;
        s = (number % 1000) / 100;
        d = (number % 100) / 10;
        y = number % 10;
        
        if (h == 0 && s == 0 && d == 0 && y == 0) {
            break;
        }

        if (!(key_state & 0x80)) {  
            y = 0; 
        }
        if (!(key_state & 0x40)) { 
            d = 0;
        }
        if (!(key_state & 0x20)) { 
            s = 0;
        }
        if (!(key_state & 0x10)) { 
            h = 0;
        }

        for (i = 0; i < 20; i++)
        {
            PORTD = 0b0111;
            PORTC = sevenSeg[y];
            delay_ms(5);
            PORTD = 0b1111;

            PORTD = 0b1011;
            PORTC = sevenSeg[d] + 0x80;
            delay_ms(5);
            PORTD = 0b1111;

            PORTD = 0b1101;
            PORTC = sevenSeg[s];
            delay_ms(5);
            PORTD = 0b1111;

            PORTD = 0b1110;
            PORTC = sevenSeg[h];
            delay_ms(5);
            PORTD = 0b1111;
             
        }

        delay_ms(200);

        number -= 2;
    }
}

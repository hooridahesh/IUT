#include <headers.h>

// Declare your global variables here
const unsigned short ra[] = {
    // 32 numbers =>index = [0,31]    
    0x00, 0x32, 0x48, 0x48, 0x48, 0x30, 0x00, 0x00, // Code for char r
    0x00, 0x3E, 0x09, 0x09, 0x09, 0x3E, 0x00, 0x00, // Code for char a
    0x00, 0x7C, 0x10, 0x10, 0x10, 0x7C, 0x00, 0x00, // Code for char h
    0x00, 0x3E, 0x49, 0x49, 0x49, 0x36, 0x00, 0x00, // Code for char d
};
int i, j;
int hour = 0, minute = 30, second = 0;

void subRoutine1(void)
{
    for (i = 0 ; i < 16 ; i++) {
        for (j = i ; j < i + 16 ; j++) { 
            PORTD.7 = ((j-i)<8) ? 0 : 1 ; 
            PORTA = pow(2, (j-i)%8);
            PORTB = ra[j];
            delay_ms(3);    
        }
    }  
}

void subRoutine2()
{
    glcd_putimagef(0, 0, new_image, GLCD_PUTCOPY);
}

float degreeToRadian(float degree)
{
    return degree * (3.14 / 180.0);
}

int getX2(int x1, int amount, char unit)
{
    int x2;

    switch (unit)
    {
    case 's': // second
        x2 = x1 + (27 * sin(degreeToRadian(6 * amount)));
        break;

    case 'm': // minute
        x2 = x1 + (23 * sin(degreeToRadian(6 * amount)));
        break;

    case 'h': // hour
        x2 = x1 + (18 * sin(degreeToRadian(30 * amount)));
        break;

    default:
        break;
    }

    return x2;
}

int getY2(int y1, int amount, char unit)
{
    int y2;

    switch (unit)
    {
    case 's': // second
        y2 = y1 - (27 * cos(degreeToRadian(6 * amount)));
        break;

    case 'm': // minute
        y2 = y1 - (23 * cos(degreeToRadian(6 * amount)));
        break;

    case 'h': // hour
        y2 = y1 - (18 * cos(degreeToRadian(30 * amount)));
        break;

    default:
        break;
    }

    return y2;
}

void drawLines(int amount, char unit)
{
    int x1=32, x2, y1=31, y2;

    switch (unit)
    {
    case 's': //second
        x2 = getX2(x1, amount, 's');
        y2 = getY2(y1, amount, 's');
        break;

    case 'm': //minute
        x2 = getX2(x1, amount, 'm');
        y2 = getY2(y1, amount, 'm');
        break;

    case 'h': //hour
        x2 = getX2(x1, amount, 'h');
        y2 = getY2(y1, amount, 'h');
        break;

    default:
        break;
    }

    glcd_line(x1, y1, x2, y2);
}

interrupt[TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 value
    TCNT1H = 0x85EE >> 8;
    TCNT1L = 0x85EE & 0xff;

    second++;
    if (second == 60)
    {
        second = 0;
        minute++;
        if (minute == 60)
        {
            minute = 0;
            hour++;
            if (hour == 12)
            {
                hour = 0;
            }
        }
    }
    updateClock();
}

void updateClock()
{
    glcd_clear();
    drawLines(second, 's');
    drawLines(minute, 'm');
    drawLines(hour, 'h');

    glcd_outtextxy(30, 50, " ");
    glcd_outtextxy(30, 50, "6");
    glcd_outtextxy(54, 30, "3");
    glcd_outtextxy(4, 31, "9");
    glcd_outtextxy(27, 3, "12");
    glcd_circle(32, 31, 30);
}

void subRoutine3()
{
#asm("sei");
    updateClock();
}

void init(void){

// Variable used to store graphic display
// controller initialization data
GLCDINIT_t glcd_init_data;

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A = (0 << COM1A1) | (0 << COM1A0) | (0 << COM1B1) | (0 << COM1B0) | (0 << WGM11) | (0 << WGM10);
TCCR1B = (0 << ICNC1) | (0 << ICES1) | (0 << WGM13) | (0 << WGM12) | (1 << CS12) | (0 << CS11) | (0 << CS10);
TCNT1H = 0x85;
TCNT1L = 0xEE;
ICR1H = 0x00;
ICR1L = 0x00;
OCR1AH = 0x00;
OCR1AL = 0x00;
OCR1BH = 0x00;
OCR1BL = 0x00;

//Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK = (0 << OCIE2) | (0 << TOIE2) | (0 << TICIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (1 << TOIE1) | (0 << OCIE0) | (0 << TOIE0);


// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Graphic Display Controller initialization
// The KS0108 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// DB0 - PORTC Bit 0
// DB1 - PORTC Bit 1
// DB2 - PORTC Bit 2
// DB3 - PORTC Bit 3
// DB4 - PORTC Bit 4
// DB5 - PORTC Bit 5
// DB6 - PORTC Bit 6
// DB7 - PORTC Bit 7
// E - PORTD Bit 0
// RD /WR - PORTD Bit 1
// RS - PORTD Bit 2
// /RST - PORTD Bit 3
// CS1 - PORTD Bit 4
// CS2 - PORTD Bit 5

// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;

glcd_init(&glcd_init_data);

}

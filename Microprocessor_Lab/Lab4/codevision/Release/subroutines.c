#include <myheaders.h>

char timerStatus = 0;
int hour = 0;
int minute = 0;
int second = 0;
int hundredthOfSecond = 0;
char timerCounter = 0;

//Q2
int emptyCapacity = 1000;

//Q3
int period = 255;
int in_period;

interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
CarCap();
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
startStopTimer();
}

// External Interrupt 2 service routine
interrupt [EXT_INT2] void ext_int2_isr(void)
{
// Place your code here
DDRA = 0x00;
period = PINA;  
createWave();
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x83;
// Place your code here
showTime();

}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
//TCNT1H=0x63C0 >> 8;
//TCNT1L=0x63C0 & 0xff;

int tcnt = calPeriod(period,0,255,1,10000) * 0.000001 * (1/2*8000000);
//int tcnt = 1/2 * (1/period) * 8000000000;
TCNT1H = tcnt >> 8;
TCNT1L = tcnt & 0xff;

}

void startStopTimer(void){
    if(PINB.4 == 0){ //start 
        timerStatus = 1;
    }
    else if(PINB.5 == 0 && timerStatus == 1){ //stop  
        timerStatus = 0;
    }
    else{ //reset
        hundredthOfSecond = 0;
        second = 0;
        minute = 0;
        hour = 0;
    }
}

void showTime(void){
    char lcdTimer[17]; 
    
    // count 10 to reach 10ms
    if (timerCounter != 10)
    {
        timerCounter++;
    }
    else
    {
        timerCounter = 0;
        if(timerStatus == 1){
            calTime();           
        }
    }

    sprintf(lcdTimer, "%02d:%02d:%02d:%02d", hour, minute, second, hundredthOfSecond);
    lcd_gotoxy(0, 0);
    //lcd_clear();
    lcd_puts(lcdTimer);
}

void calTime(void)
{
    hundredthOfSecond++;
    if (hundredthOfSecond > 99)
    {
        hundredthOfSecond = 0; 
        second++;
        if (second > 59)
        {
            second = 0;
            minute++ ;
            if (minute > 59)
            {
                minute = 0; 
                hour++;
                if (hour > 99)
                {
                    hour = 0;
                }
            }

        }

    }
}

void CarCap(void){
    char capMessage[16]; 
    //counter++;
    DDRB = DDRB & 0b01110111;    
    
    if(PINB.7 == 0 && emptyCapacity > 0){
        emptyCapacity--; //car in 
    } 
    else if(PINB.3 == 0 && emptyCapacity < 1000){
        emptyCapacity++; //car out 
    }
     
    
    if (emptyCapacity == 0)
    {
        sprintf(capMessage, "FULL");
    }
    else
    {
        sprintf(capMessage, "%4d", emptyCapacity);
    }

    lcd_gotoxy(0, 1); 
    //lcd_clear();
    lcd_puts(capMessage);
    //lcd_gotoxy(0, 1);  
    //sprintf(capMessage, "%d", counter);
    //lcd_puts(capMessage);

}

long calPeriod(long per, long iMin, long iMax, long oMin, long oMax){
    long     temp =  (per - iMin) * (oMax - oMin) / (iMax - iMin) + oMin;        
    return temp;
}

void createWave(void){
    char message[17];
    in_period = calPeriod(period,0,255,1,10000);  
    if (in_period % 1000 == 0){
        sprintf(message, "%4dMS0", in_period/1000);
    }
    else {
        sprintf(message, "%4dUS0", in_period);
    }
    lcd_gotoxy(7, 1); 
    //sprintf(message, "%d", period);
    lcd_puts(message); 
}


void init(void){
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
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125/000 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 1 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x83;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000/000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Toggle on compare match
// OC1B output: Toggle on compare match
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 5 ms
// Output Pulse(s):
// OC1A Period: 10 ms Width: 5 ms
// OC1B Period: 10 ms Width: 5 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x63;
TCNT1L=0xC0;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: On
// INT2 Mode: Falling Edge
GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);

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

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);
}
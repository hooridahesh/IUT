#include <header.h>
flash unsigned char num[]={0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D,0x07, 0x7F, 0x6F};


char part1(char port_in)
{
    char data_in;
    switch(port_in)
    {
        case portA:
            DDRA=0x00; // as input
            data_in=PINA;
            break ;
        case portB:
            DDRB=0x00; // as input
            data_in=PINB;
            break;
        case portC:
            DDRC=0x00; // as input
            data_in=PINC;
            break;
        case portD:
            DDRD=0x00; // as input
            data_in=PIND;
            break;
    }
    return data_in; // can be any data with unsigned int format
}


void part2(char port_out, char data_out)
{
    switch(port_out)
    {
        case portA:
            DDRA=0xFF; // as output
            PORTA=data_out;
            break;
        case portB:
            DDRB=0xFF; // as output
            PORTB=data_out;
            break;
        case portC:
            DDRC=0xFF; // as output
            PORTC=data_out;
            break;
        case portD:
            DDRD=0xFF; // as output
            PORTD=data_out;
            break;
    }
}


void part3(int number, int time)
{
    int i;
    PORTB=0x00;
    delay_ms(time);

    for(i = 0; i < number; i++)
    {
        part2(portB, 0xFF);
        delay_ms(time);
        part2(portB, 0x00);
        delay_ms(time);
    }
}


void part4(void) {
    char data;  
    data = part1(portA);
    part2(portB,data); 
}


void part5(int data, int data_port, int enable_data) {
    int i;
    int digit[4];
    
    digit[0] = data/1000;
    digit[1] = (data%1000)/100;
    digit[2] = (data%100)/10;
    digit[3] = data%10;
    
    for(i = 0; i < 4; i++) {
        switch(data_port)
        {
            case portA:
                DDRA=0xFF; // as output
                PORTA=num[digit[i]];
                break ;
            case portB:
                DDRB=0xFF; // as output
                PORTB=num[digit[i]];
                break;
            case portC:
                DDRC=0xFF; // as output
                PORTC=num[digit[i]];
                break;
            case portD:
                DDRD=0xFF; // as output
                PORTD=num[digit[i]];
                break;
        }
        
        switch(enable_data)
        {
            case portA:
                DDRA=0x0F; // as output
                PORTA |= 0x0F;//Unable all ports
                PORTA &= ~(1 << i);
                delay_ms(150);
                PORTA |= (1 << i);
                break ;
            case portB:
                DDRB=0x0F; // as output
                PORTB |= 0x0F;//Unable all ports
                PORTB &= ~(1 << i);
                delay_ms(150);
                PORTB |= (1 << i);
                break;
            case portC:
                DDRC=0x0F; // as output
                PORTC |= 0x0F;//Unable all ports
                PORTC &= ~(1 << i);
                delay_ms(150);
                PORTC |= (1 << i);
                break;
            case portD:
                DDRD=0x0F; // as output
                PORTD |= 0x0F;//Unable all ports 
                PORTD &= ~(1 << i);
                delay_ms(150);
                PORTD |= (1 << i);
                break;
        }
   }
}



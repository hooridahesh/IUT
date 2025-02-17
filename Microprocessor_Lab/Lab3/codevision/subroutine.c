#include <header.h>

char data_key[]={
'0','1','2','3',
'4','5','6','7',
'8','9','A','B',
'C','D','E','F'
};


interrupt [EXT_INT1] void ext_int1_isr(void)
{
    char key;  
    PORTC = ~PORTC;
    key = keypad3(); 
    lcd_clear();
    lcd_putchar(data_key[key]);

}



void init(void){
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
    PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
    TCNT0=0x00;
    OCR0=0x00;

    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    ASSR=0<<AS2;
    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
    TCNT2=0x00;
    OCR2=0x00;

    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

    GICR|=(1<<INT1) | (0<<INT0) | (0<<INT2);
    MCUCR=(1<<ISC11) | (1<<ISC10) | (0<<ISC01) | (0<<ISC00);
    MCUCSR=(0<<ISC2);
    GIFR=(1<<INTF1) | (0<<INTF0) | (0<<INTF2);


    UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
    SFIOR=(0<<ACME);


    ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);


    SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);


    TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);


    lcd_init(16);
}


void func1(char* familyname, char* id) {
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_puts(familyname);
    lcd_gotoxy(0, 1);  
    lcd_puts(id);   
    delay_ms(3000);
    lcd_clear();
}

void func2(void){
   char str[94] = " Welcome to the Microprocessor lab classes in Isfahan University of Technology.             ";  //94 character
   int i = 0, j = 0; 
   int p1 = 0, p2 = 15;
   lcd_clear();          
   while(p2 != 94) { 
    lcd_gotoxy(0, 1);
    i = 0;
    for(j = p1; j < p2; j++) {  
     lcd_putchar(str[j]);
     lcd_gotoxy(i, 1);
     i = i + 1;
    }           
    p1 = p1 + 1;
    p2 = p2 + 1;
    delay_ms(200);
   }  
   delay_ms(1000);
   lcd_clear();
   memset(str,0,strlen(str)); 
}

void keypad(void)
{
    char keys[16] = {'0', '1', '2', '3',
                     '4', '5', '6', '7',
                     '8', '9', 'A', 'B',
                     'C', 'D', 'E', 'F'}; 
    int row[4] = {0x10, 0x20, 0x40, 0x80};
    int r, c, key; 
    
    DDRB = 0xF0;
    for (r=0;r<4;r++)
    {
        PORTB=row[r];
        c=20;
        delay_ms(10);
        if (PINB.0==1) c=0;
        if (PINB.1==1) c=1;
        if (PINB.2==1) c=2;
        if (PINB.3==1) c=3;
        
        if (!(c==20)){
            lcd_clear();
            key=(r*4)+c;
            PORTB=0xf0;
            while (PINB.0==1) {}
            while (PINB.1==1) {}
            while (PINB.2==1) {}
            while (PINB.3==1) {} 
            lcd_putchar(keys[key]);
            break;
        }
        PORTB=0xf0;
    }
}

char keypad3(void){
    char row[] = { 0x10,0x20,0x40,0x80 };
    char key =100;
    int r,c;
    for(r=0;r<4;r++){
        PORTB = row[r];
        c=20;
        delay_ms(10);
        if (PINB.0==1) c=0; 
        if (PINB.1==1) c=1;
        if (PINB.2==1) c=2;     
        if (PINB.3==1) c=3; 
         
    
        if (!(c==20)){             
            key=(r*4)+c; 
            PORTB=0xf0;                     
            while (PINB.0==1) {}              
            while (PINB.1==1) {}              
            while (PINB.2==1) {}             
            while (PINB.3==1) {}
            return key;
        }      
        PORTB = 0xf0;
    }
    return key;    
}


void func3(void) {
    int i;
    lcd_puts("Press a key...");
    for(i=0;i<200;i++)
        keypad(); 
    delay_ms(2000);
    lcd_clear();    
}

void check_interrupt(void){
    DDRB = 0xf0;
    PORTB = 0xf0;
    lcd_clear();
    lcd_puts("checking interrupt..."); 
    delay_ms(5000); 
}

void speed(void)
{
    char temp1, final_num, temp2;  
    char output[100];
    lcd_clear();
    lcd_puts("system init\n");
    lcd_puts("Speed:??(0-50r)"); 
    
    DDRB = 0xf0;
    PORTB = 0xf0; 
    while(1){ 
    
    while(PINB == 0xF0){}
    
    temp1=keypad3();
    lcd_clear(); 
    memset(output,0,strlen(output)); 
    lcd_puts("system init\n");
    sprintf(output, "speed:%c?(0-50r)", data_key[temp1]);
    lcd_puts(output);
    
    while(PINB == 0xF0){} 
    
    temp2=keypad3();
    lcd_clear();
    memset(output,0,strlen(output));
    sprintf(output, "System init\n speed:%c%c(0-50r)", data_key[temp1],data_key[temp2]);   
    lcd_puts(output);                                                                            
    
    delay_ms(500);
    
     final_num=(10*temp1)+temp2;
    
    if(final_num > 50)
    {
        lcd_clear();
        memset(output,0,strlen(output));
        lcd_puts("system init\n speed:EE(0-50r)"); 
        delay_ms(2000);
    } 
    else{
         delay_ms(3000);  
         memset(output,0,strlen(output));
         break;
    }
    }
    
}
void time(void){
    char temp1, final_num, temp2;  
    char output[100];
    lcd_clear();
    lcd_puts("system init\n");
    lcd_puts("time:??(0-99s)"); 
    
    DDRB = 0xf0;
    PORTB = 0xf0; 
    while(1){ 
    
    while(PINB == 0xF0){}
    
    temp1=keypad3();
    lcd_clear();
    memset(output,0,strlen(output)); 
    lcd_puts("system init\n");
    sprintf(output, "time:%c?(0-99s)", data_key[temp1]);
    lcd_puts(output);
    
    while(PINB == 0xF0){} 
    
    temp2=keypad3();
    lcd_clear();
    memset(output,0,strlen(output));
    lcd_puts("system init\n");
    sprintf(output, "time:%c%c(0-99s)", data_key[temp1],data_key[temp2]);
    lcd_puts(output);
                                                                                   
    
    delay_ms(500);
    
     final_num=(10*temp1)+temp2;
    
    if(final_num > 99)
    {
        lcd_clear();
        memset(output,0,strlen(output));
        lcd_puts("system init\n time:EE(0-99s)"); 
        delay_ms(2000);
    } 
    else{
         delay_ms(3000);
         memset(output,0,strlen(output));
         break;
    }
    }
}

void w(void){
   char temp1, final_num, temp2;  
    char output[100];
    lcd_clear();
    lcd_puts("system init\n");
    lcd_puts("W:??(0-99Kg)"); 
    
    DDRB = 0xf0;
    PORTB = 0xf0; 
    while(1){ 
    
    while(PINB == 0xF0){}
    
    temp1=keypad3();
    lcd_clear();
    memset(output,0,strlen(output));
    lcd_puts("system init\n");
    sprintf(output, "w:%c?(0-99Kg)", data_key[temp1]);
    lcd_puts(output);
    
    while(PINB == 0xF0){} 
    
    temp2=keypad3();
    lcd_clear();
    memset(output,0,strlen(output));
    lcd_puts("system init\n");
    sprintf(output, "w:%c%c(0-99Kg)", data_key[temp1],data_key[temp2]);
    lcd_puts(output);                                                                            
    
    delay_ms(500);
    
     final_num=(10*temp1)+temp2; 
    
    if(final_num > 99)
    {
        lcd_clear();
        memset(output,0,strlen(output));
        lcd_puts("system init\n w:EE(0-99Kg)");
        delay_ms(2000);
    } 
    else{
         delay_ms(3000); 
         memset(output,0,strlen(output));
         break;
    }
    }
}

void temp(void){
  char temp1, final_num, temp2; 
  char num1=20;
    char num2=80; 
    char output[100];
    lcd_clear();
    lcd_puts("System init\n Temp:??(20-80C)"); 
    
    DDRB = 0xf0;
    PORTB = 0xf0; 
    while(1){ 
    
    while(PINB == 0xF0){}
    
    temp1=keypad3();
    lcd_clear(); 
    memset(output,0,strlen(output)); 
    sprintf(output, "System init\n temp:%c?(20-80C)", data_key[temp1]);   
    lcd_puts(output);
    
    while(PINB == 0xF0){} 
    
    temp2=keypad3();
    lcd_clear();
    memset(output,0,strlen(output));
    sprintf(output, "System init\n temp:%c%c(20-80C)", data_key[temp1],data_key[temp2]);   
    lcd_puts(output);                                                                            
    
    delay_ms(500);
    
    final_num=(10*temp1)+temp2; 
    
    if(final_num < num1 || final_num > num2)
    {
        lcd_clear();
        memset(output,0,strlen(output)); 
        lcd_puts("System init\n temp:EE(20-80C)");
        delay_ms(2000);
    } 
    else{
         delay_ms(3000); 
         memset(output,0,strlen(output));
         break;
    }
    }
}

void func5(void)
{
    lcd_clear();
    speed();    
    time();
    w();
    temp();
    lcd_clear();
    lcd_puts("System Init Done\n\tThanks"); 
    delay_ms(3000);
    lcd_clear();   
}
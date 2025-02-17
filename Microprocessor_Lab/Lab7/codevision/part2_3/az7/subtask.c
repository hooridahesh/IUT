#include "subtask.h"

char buffer1[RX_BUFFER_SIZE];
bit buffer_overflow1;
unsigned char wr_index1 = 0, rd_index1 = 0;
unsigned char counter1 = 0;
char buffer2[TX_BUFFER_SIZE];
unsigned char wr_index2 = 0, rd_index2 = 0;
unsigned char counter2 = 0;

// USART Receiver interrupt service routine
interrupt[USART_RXC] void usart_rx_isr(void)
{
    char status, data;
    status = UCSRA;
    data = UDR;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0)
    {
        buffer1[wr_index1++] = data;
#if RX_BUFFER_SIZE == 256
        // special case for receiver buffer size=256
        if (++counter1 == 0)
            buffer_overflow1 = 1;
#else
        if (wr_index1 == RX_BUFFER_SIZE)
            wr_index1 = 0;
        if (++counter1 == RX_BUFFER_SIZE)
        {
            counter1 = 0;
            buffer_overflow1 = 1;
        }
#endif
    }
}

// USART Transmitter interrupt service routine
interrupt[USART_TXC] void usart_tx_isr(void)
{
    if (counter2)
    {
        --counter2;
        UDR = buffer2[rd_index2++];
#if TX_BUFFER_SIZE != 256
        if (rd_index2 == TX_BUFFER_SIZE)
            rd_index2 = 0;
#endif
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used +
char getchar(void)
{
    char data;
    while (counter1 == 0)
        ;
    data = buffer1[rd_index1++];
#if RX_BUFFER_SIZE != 256
    if (rd_index1 == RX_BUFFER_SIZE)
        rd_index1 = 0;
#endif
#asm("cli")
    --counter1;
#asm("sei")
    return data;
}
#pragma used -
#endif

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used +
void putchar(char c)
{
    while (counter2 == TX_BUFFER_SIZE)
        ;
#asm("cli")
    if (counter2 || ((UCSRA & DATA_REGISTER_EMPTY) == 0))
    {
        buffer2[wr_index2++] = c;
#if TX_BUFFER_SIZE != 256
        if (wr_index2 == TX_BUFFER_SIZE)
            wr_index2 = 0;
#endif
        ++counter2;
    }
    else
        UDR = c;
#asm("sei")
}
#pragma used -
#endif

int subtask2(char entered_character)
{
    int integer_char;
    if (is_digit_valid(entered_character))
    {
        integer_char = (int)(entered_character)-48;
        printf("\r\nData is a integer and 10*%c = %d\r\n", entered_character, integer_char * 10);  
        lcd_gotoxy(0,1);
        lcd_puts("10 * data = ");
        lcd_putchar(entered_character);
        lcd_putchar('0');
    }
    else if (entered_character == 'D')
    {
        print_lcd("LCD Deleted!");
        print_terminal("LCD Deleted!");
    }
    else if (entered_character == 'H')
    {
        lcd_clear();
        print_lcd("***Micro processor lab***");
        print_terminal("***********************Micro processor lab ***********************");
    }
    else if (entered_character == 'E')
    {
        lcd_clear();
        print_lcd("Rx: END of the part");
        print_terminal("Rx: END of the part");
        delay_ms(3000);
        return -1; // end
    }
    else
    { 
        lcd_clear();
        lcd_puts("Rx: input letter is ");
        lcd_putchar(entered_character);
        printf("\r\nRx: input letter is %c\r\n", entered_character);
    }
    return 1;
}

bool is_digit_valid(char entered_char)
{
    int integer_char;
    integer_char = (int)(entered_char)-48;

    if (integer_char >= 0 && integer_char <= 9)
    {
        return true;
    }
    return false;
}

void subtask3(char *entered_frame)
{

    char number[10];
    int frame_length;
    int i = 0, j = 0;

    if (!is_parentheses_valid(entered_frame))
    {
        print_terminal("invalid input!");
        return;
    }

    frame_length = strlen(entered_frame);

    for (i = 1; i < frame_length - 1; i++, j++)
    {
        number[j] = entered_frame[i];
    }

    if (has_letter(number))
    {
        print_lcd("Rx:Frame must be 5 integer");
        print_terminal("Rx:Frame must be 5 integer");
    }
    else
    {
        if (strlen(number) != 5)
        {
            print_lcd("Rx: Incorrect frame size");
            print_terminal("Rx: Incorrect frame size");
        }
        else
        {
            print_lcd("Rx: The frame is correct");
            print_terminal("Rx: The frame is correct");
        }
    }
}

bool is_parentheses_valid(char *entered_frame)
{
    int last_index = strlen(entered_frame) - 1;
    return entered_frame[0] == '(' && entered_frame[last_index] == ')';
}

bool has_letter(char entered_number[])
{
    int i = 0;
    for (i = 0; i < strlen(entered_number); i++)
    {
        if (isalpha(entered_number[i]))
        {
            return true;
        }
    }

    return false;
}

void print_lcd(char *message)
{
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_puts(message);
}

void print_terminal(char *message)
{
    printf("\r\n%s\r\n", message);
}
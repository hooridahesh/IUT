#ifndef _SUBTASKS_INCLUDED_
#define _SUBTASKS_INCLUDED_

#include "headers.h"

#define DATA_REGISTER_EMPTY (1 << UDRE)
#define RX_COMPLETE (1 << RXC)
#define FRAMING_ERROR (1 << FE)
#define PARITY_ERROR (1 << UPE)
#define DATA_OVERRUN (1 << DOR)

//* USART Receiver buffer
#define RX_BUFFER_SIZE 8

extern char buffer1[RX_BUFFER_SIZE];
// This flag is set on USART Receiver buffer overflow
extern bit buffer_overflow1;

#if RX_BUFFER_SIZE <= 256
extern unsigned char wr_index1, rd_index1;
#else
extern unsigned int wr_index1, rd_index1;
#endif

#if RX_BUFFER_SIZE < 256
extern unsigned char counter1;
#else
extern unsigned int counter1;
#endif

//* USART Transmitter buffer
#define TX_BUFFER_SIZE 8
extern char buffer2[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
extern unsigned char wr_index2, rd_index2;
#else
extern unsigned int wr_index2, rd_index2;
#endif

#if TX_BUFFER_SIZE < 256
extern unsigned char counter2;
#else
extern unsigned int counter2;
#endif

char getchar(void);
void putchar(char c);
int subtask2(char entered_character);
bool is_digit_valid(char entered_char);
void print_lcd(char *message);
bool is_parentheses_valid(char *entered_frame);
bool has_letter(char entered_number[]);
void print_terminal(char *message);
void subtask3(char *entered_frame);

#endif

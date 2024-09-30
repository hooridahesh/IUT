#ifndef _headers_INCLUDED_
#define _headers_INCLUDED_

#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 7
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

extern long int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
//extern char str[20];
#include <mega16.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>

#include <Q1.h>
#include <Q2.h>
#include <Q3.h>



#endif
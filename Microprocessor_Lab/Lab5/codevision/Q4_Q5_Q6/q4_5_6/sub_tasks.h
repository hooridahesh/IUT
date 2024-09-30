#ifndef _SUB_TASKS_INCLUDED_
#define _SUB_TASKS_INCLUDED_

#include "headers.h"


void q3_custom_pwm_wave(int custom_duty);
void q4_subTask();
void q5_subTask();
void q6_handle_timer1_capture();

void two_phase_step();
void two_phase_step_reverse();
void print_dc_motor_speed(int speed);
bool has_speeds_difference(int old_speed, int new_speed);


void init_program_configs();
void init_lcd();
void init_timers();
void init_interrupts();
void init_ports();

#endif

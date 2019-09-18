/****************************************************************
 *  Filename:        pedes-0.2.c                                *
 *  Author:          Aren Tyr                                   *
 *  Version:         0.2                                        *
 *  Description:     Initial version of pedestrian program.     *
 *                   This version has a fully functioning       * 
 *                   traffic light sequence operated by a       *
 *                   push button. Buzzer and wait light not     *
 *                   implemented yet.                           *
 *                                                              *
 *--------------------------------------------------------------*
 *  Pin mapping:                                                *
 *                                                              *
 *     PIN_B0:  Push Button                                     *
 *     PIN_B1:	Green traffic light                             *
 *     PIN_B2:  Amber traffic light                             *
 *     PIN_B3:  Red traffic light                               *
 *     PIN_B4:  Green man light                                 *
 *     PIN_B5:  Red man light                                   *
 *                                                              *
 ****************************************************************/

// Pre-processor directives section
#if defined(__PCM__)
	#include <16F84.h>
	#fuses XT, NOWDT, NOPROTECT, PUT
	#use delay(clock = 4000000)
#endif

#byte port_b = 6

#define trans_delay 750
// 0.75 second light transition delay

#define amber_delay 2000
// 2 second amber light delay

#define red_delay 10000
// 10 second red light delay

#define amber_flash 500
// 0.5 second amber flash delay

#define amber_cycles 10
// do 10 cycles


// forward declarations of functions
void default_lights();
void hold_state_no_input();
void light_sequence();
void green_man_buzzer();
void green_man_amber();


// default traffic light state function:
// 1. Green traffic light illuminated
// 2. Red man light illuminted
void default_lights()
{
	output_high(PIN_B1);
	output_high(PIN_B5);
}

// Prevent any the light sequence from being
// initiated for 10 seconds
void hold_state_no_input()
{
	default_lights();
	// don't allow any inputs for a while
	delay_ms(red_delay);

	// ...now return to main() loop
}

// Main traffic light sequence (green->amber->red)
void light_sequence()
{
	// light the LEDs
	output_low(PIN_B1);
	delay_ms(trans_delay);
	output_high(PIN_B2);
	delay_ms(amber_delay);	
	output_low(PIN_B2);
	delay_ms(trans_delay);
	output_high(PIN_B3);
	delay_ms(trans_delay);
	
        // call the green man & buzzer function
	green_man_buzzer();
}

// light green man and start buzzer (not implemented yet)
void green_man_buzzer()
{
	// suppress red man, light green man
	output_low(PIN_B5);
	delay_ms(trans_delay);
	output_high(PIN_B4);

        // wait for a specified length of time
	delay_ms(red_delay);
	
	green_man_amber();
}

// flash green man light and amber light simultaneously
void green_man_amber()
{
	int i = 0;

	// unlight the red traffic light
	output_low(PIN_B3);
	
	// flash the green man and amber light
	for(i = 0; i < amber_cycles; i++)
	{
		output_low(PIN_B4);
		output_low(PIN_B2);
		delay_ms(amber_flash);
		output_high(PIN_B4);
		output_high(PIN_B2);
		delay_ms(amber_flash);
	}
		
	output_low(PIN_B4);
	output_high(PIN_B5);
	delay_ms(amber_flash);
	output_high(PIN_B2);
	delay_ms(amber_flash);
	output_low(PIN_B2);

	// go to holding state
	hold_state_no_input();
}

void main()
{	
        // illuminate the initial (default) lights
        default_lights();
	
	setup_counters(RTCC_INTERNAL, WDT_18MS);
	
	do
	{					
	        // if button has been pressed
	        if(input(PIN_B0))
		{
			while(input(PIN_B0))
				delay_ms(1); // user held down button		
			// start off the light sequence
			light_sequence();
		}
		
	}while (TRUE);
}

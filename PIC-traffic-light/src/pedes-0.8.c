/****************************************************************
 *  Filename:        pedes-0.8.c                                *
 *  Author:          Aren Tyr                                   *
 *  Version:         0.8                                        *
 *  Description:     All major functions implemented. The push  *
 *                   button now generates an interrupt, and the *
 *                   wait light correspondingly illuminates     *
 *                   correctly. The buzzer correctly beeps, via *
 *                   a nested loop. Only outstanding issues are *
 *                   ones of precise timing demands and code    *
 *                   abstraction.                               *
 *                                                              *
 *--------------------------------------------------------------*
 *  Pin mapping:                                                *
 *                                                              *
 *     PIN_A0:  Green traffic light                             *
 *     PIN_A1:  Amber traffic light                             *
 *     PIN_A2:  Red traffic light                               *
 *     PIN_A3:  Green man light                                 *
 *                                                              *
 *     PIN_B0:  Buzzer                                          * 
 *     PIN_B1:  Red man light                                   *
 *     PIN_B2:  Wait notification light                         *
 *     PIN_B7:  Push Button                                     *
 *                                                              *
 ****************************************************************/

// Pre-processor directives section
#if defined(__PCM__)
    #include <16F84.h>
    #fuses XT, NOWDT, NOPROTECT, PUT
    #use delay(clock = 4000000)
#endif

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

// boolean used for masking the wait notification light 
boolean allowLight = 0;

// boolean regulates the light sequence (non-essential, though)
boolean startLights = 0;

// forward declarations of functions
void default_lights();
void hold_state_no_input();
void light_sequence();
void green_man_buzzer();
void green_man_amber();
void start_program();

// default traffic light state function:
// 1. Green traffic light illuminated
// 2. Red man light illuminted
void default_lights()
{
    output_high(PIN_A0);
    output_high(PIN_B1);
}

// Prevent any the light sequence from being
// initiated for 10 seconds
void hold_state_no_input()
{
    // allow the wait notification light
    allowLight = 1;

    default_lights();

    delay_ms(red_delay);

}

// Main traffic light sequence (green->amber->red)
void light_sequence()
{
    // boolean not strictly necessary, since the hardware 
    // protects against recursion
    startLights = 0;

    // light the LEDs
    output_low(PIN_A0);
    delay_ms(trans_delay);
    output_high(PIN_A1);
    delay_ms(amber_delay);
    output_low(PIN_A1);
    delay_ms(trans_delay);
    output_high(PIN_A2);
    delay_ms(trans_delay);


    // call the green man & buzzer function
    green_man_buzzer();
}

void green_man_buzzer()
{
    // local loop counters 
    int i, j = 0;
    
    // don't allow the wait light here
    allowLight = 0;

    // switch off the wait notification light
    output_low(PIN_B2);

    // suppress red man, light green man
    output_low(PIN_B1);
    delay_ms(trans_delay);
    output_high(PIN_A3);
    delay_ms(amber_delay);

    // beep the buzzer using a nested loop
    // (also indirectly delays)
    for(j=0; j<100; j++)
    {
        for(i = 0; i<100; i++)
        {
            output_high(PIN_B0);
            delay_us(200);
            output_low(PIN_B0);
        
        }

        delay_ms(100);
    }
    
    // just to ensure the buzzer is actually off
    output_low(PIN_B0);

    green_man_amber();
}

// flash green man light and amber light simultaneously
void green_man_amber()
{
    // local loop iterator
    int i = 0;

    // unlight the red traffic light
    output_low(PIN_A2);

    // flash the green man and amber light
    for(i = 0; i < amber_cycles; i++)
    {
        output_low(PIN_A3);
        output_low(PIN_A1);
        delay_ms(amber_flash);
        output_high(PIN_A3);
        output_high(PIN_A1);
        delay_ms(amber_flash);
    }

        output_low(PIN_A3);
        output_high(PIN_B1);
        delay_ms(amber_flash);
        output_high(PIN_A1);
        delay_ms(amber_flash);
        output_low(PIN_A1);

        hold_state_no_input();
}

// interrupt service routine for push button
// will set the light sequence off and
// wait light (where appropriate)
#int_RB 
button_isr()
{
    if(input(PIN_B7))
    {
        while(input(PIN_B7))
            delay_ms(1); // user held down button
            
        // wait light
        if(allowLight == 1)
            output_high(PIN_B2);
    
        // light sequence boolean 
        startLights = 1;    
    }

}

// the main part of the program
void start_program()
{
    do
    {
        if(startLights == 1)
            light_sequence();

    
    }
    while (TRUE);

}


void main()
{    
    // initialize real time clock
    set_rtcc(0);
    setup_counters(RTCC_INTERNAL, WDT_18MS);

    // enable interrupts for Pins B4-B7 (push button is on B7)
    enable_interrupts(int_RB);
    // enable global interrupts (make push button interrupt active)
    enable_interrupts(GLOBAL);

    // illuminate the initial (default) lights
    default_lights();

    // allow the light sequence initially
    allowLight = 1;

    // start the program off
    start_program();

}

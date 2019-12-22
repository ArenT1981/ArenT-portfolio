/****************************************************************
 *  Filename:        pedes-0.6.c                                *
 *  Author:          Aren Tyr                                   *
 *  Version:         0.6                                        *
 *  Description:     Slightly improved attempt for buzzer.      *
 *                   This buzzer beeps, periodically, but the   *
 *                   timing is inconsistent and the pitch       *
 *                   incorrect. The buzzer timing is no longer  *
 *                   controlled via an interrrupt.  The wait    *
 *                   light is partially implemented.            *
 *                                                              *
 *--------------------------------------------------------------*
 *  Pin mapping:                                                *
 *                                                              *
 *     PIN_B0:  Push Button                                     *
 *     PIN_B1:  Green traffic light                             *
 *     PIN_B2:  Amber traffic light                             *
 *     PIN_B3:  Red traffic light                               *
 *     PIN_B4:  Green man light                                 *
 *     PIN_B5:  Red man light                                   *
 *     PIN_B6:  Buzzer                                          *  
 *     PIN_B7:  Wait notification light                         *
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

#define sound_delay 122000 //1906

int delayCount = 0;
boolean soundOn = 0;
boolean soundControl = 0;

long soundCycles = 50000;

// forward declarations of functions
void default_lights();
void hold_state_no_input();
void light_sequence();
void green_man_buzzer();
void green_man_amber();
// void sound_buzzer();

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
    long k;

    default_lights();
    
    // holding loop that attempts to allow the 
    // wait notification light to be illuminated
    // whilst the appropriate delay is still 
    // maintained
    for(k = 0; k < 200; k = k + 0.5)
    {

        if(input(PIN_B0))
        {
            while(input(PIN_B0))
                delay_ms(1); // user held down button
            
            output_high(PIN_B7);
        }
    }

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

// light green man and start buzzer
void green_man_buzzer()
{        
        // local loop counters 
    int i, j = 0;

    // suppress red man, light green man
    output_low(PIN_B5);
    delay_ms(trans_delay);
    output_high(PIN_B4);

    output_low(PIN_B7);
    
    // switch the buzzer sound on
    soundOn = 1;

    // beep the buzzer using a nested loop
    // (also indirectly delays)
    for(j=0; j<100; j++)
    {
        for(i = 0; i<100; i++)
        {
            output_high(PIN_B6);
            delay_us(200);
            output_low(PIN_B6);
            --soundCycles;
        
        }

        delay_ms(100);
    }
    

    green_man_amber();
}

// flash green man light and amber light simultaneously
void green_man_amber()
{
    int i = 0;
    
    // switch the buzzer sound off
    soundOn = 0;

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

    hold_state_no_input();
}

/* 
   DEPRECATED: Now part of green_man_buzzer() function

void sound_buzzer()
{
    int i;
    
    soundControl = 1;


    for(i = 0; i<100; i++)
    {
        output_high(PIN_B6);
        delay_us(300);
        output_low(PIN_B6);
        --soundCycles;
        
    }

    delay_ms(100);
    soundControl = 0;
}
*/

/*
  DEPRECATED: Control structure is becoming too complex 
              too make any guarantees or control over 
          timing.
#int_rtcc
clock_isr()
{
    if(soundOn == 1 && soundControl == 0)
        sound_buzzer();

    if(soundOn == 1 && soundControl == 1)
    {
        sound_buzzer(); 
        soundOn = 0;
        soundCycles = 50000;
    
    }
    
    if(soundCycles <= 0 && soundOn == 1)
    {
        soundCycles = 50000;
        soundOn = 0;
    }

    if(soundCycles <= 0 && soundOn == 0)
    {
        soundCycles = 50000;
        soundOn = 1;
    }

    --soundCycles;
} 
*/


void main()
{            
        // initialize real time clock
    set_rtcc(0);
    setup_counters(RTCC_INTERNAL, WDT_18MS);
    
    // setup_counters(RTCC_INTERNAL, RTCC_DIV_256);
    // enable real time clock interrupt
    // enable_interrupts(INT_RTCC); 
    // enable global interrupts (make RTCC interrupt active)
    // enable_interrupts(GLOBAL);

    // illuminate the initial (default) lights
    default_lights();
    delayCount = sound_delay;

    do
    {                    
        if(input(PIN_B0))
        {
            while(input(PIN_B0))
                delay_ms(1); // user held down button
            
            // illuminate the wait notification light
            output_high(PIN_B7);
    
            // start off the light sequence
            light_sequence();
        }
        
    } while (TRUE);
}

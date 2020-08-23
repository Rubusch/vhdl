/*
 * main.c
 *
 *  Created on: Aug 23, 2020
 *      Author: user
 */

#include "io.h"  /* IOWR() */
#include "alt_types.h" /* alt_u8 */
#include "system.h"  /* LED_BASE */

#include <stdio.h>

int main(){
    static alt_u8 led = 0x01;

    //uncomment below line for visual verification of blinking LED
    int i, sw_delay, sw_value, wait_period=250;

    printf("Blinky is running!\n");
    while (1) {
        led = ~led;
        IOWR(LED_BASE, 0, led);

        sw_value = IORD(SW_BASE, 0);
        sw_delay = sw_value * 100;

        // some delay for
        for (i=0; i < wait_period * sw_delay; i++)
            ;
    }
}

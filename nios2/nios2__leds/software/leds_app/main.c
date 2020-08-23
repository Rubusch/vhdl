/*
 * main.c
 *
 *  Created on: Aug 23, 2020
 *      Author: Lothar Rubusch
 */

#include "io.h"  /* IOWR() */
#include "alt_types.h" /* alt_u8 */
#include "system.h"  /* LED_BASE */

int main(){
    alt_u8 led = 0x01;

    //uncomment below line for visual verification of blinking LED
    int i, wait_period=250000;

    printf("Blinky is running!\n");
    while (1) {
        led = ~led;
        IOWR(LED_BASE, 0, led);

        // some delay for
        for (i=0; i < wait_period; i++)
            ;
    }
}

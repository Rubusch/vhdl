/*
 * main.c
 *
 *  Created on: Aug 30, 2020
 *      Author: Lothar Rubusch
 */

#include <stdio.h>

#include "io.h"
#include "alt_types.h"
#include "system.h"
#include "math.h"

int main()
{
	printf("SINE WAVE\n");
	float i=0;
    float sin_value;
	float cos_value;

	alt_u8 amplitude;

    while (1) {
        amplitude = IORD(SW_BASE, 0);
        sin_value =  (int)amplitude * (float)sin(i);
        cos_value =  (int)amplitude * (float)cos(i);

        i = i + 0.01;
        i = (i > 65536) ? 0 : i;

        printf("%.3f,%.3f\n", sin_value, cos_value);
    }

    return 0;
}

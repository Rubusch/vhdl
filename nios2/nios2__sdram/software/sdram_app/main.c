/*
 * main.c
 *
 *  Created on: Aug 25, 2020
 *      Author: user
 */

#include "system.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// read io - TESTED
#define readio(addr) \
    (    {  unsigned char val; \
          asm volatile( "ldbio %0, 0(%1)" :"=r"(val) : "r" (addr)); val;} \
    )

// write io - TESTED
#define writeio(addr, val) \
    (    {  unsigned char dummy; \
          asm volatile( "stbio %1, 0(%2)" :"=r"(dummy) :  "r"(val), "r" (addr) : "memory"); } \
    )

// read/write io - TESTED
#define workio(addr_from, addr_to) \
    (    {  unsigned char dummy; \
          asm volatile( "ldbio %0, 0(%1); stbio %0, 0(%2)" :"=r"(dummy) : "r" (addr_from), "r" (addr_to)); } \
    )

// read/write ctl
#define CTL_STATUS    0  /* Processor status reg  */
# define CTL_ESTATUS    1  /* Exception status reg  */
# define CTL_BSTATUS    2  /* Break status reg  */
# define CTL_IENABLE    3  /* Interrupt enable reg  */
# define CTL_IPENDING    4  /* Interrupt pending reg  */

# define _str_(x)# x
# define rdctl(reg) \
    (    {unsigned int val; \
         asm volatile( "rdctl %0, ctl" _str_(reg) : "=r" (val) ); val;} \
)
# define wrctl(reg,val) \
    asm volatile( "wrctl ctl" _str_(reg) ",%0": : "r" (val))

/* E.g.: foo = rdctl(CTL_IENABLE);
 *          wrctl(CTL_IENABLE, foo | 1);
 */

int main()
{
	int sw=SW_BASE;
	int led=LED_BASE;

	unsigned char content = 0x0;

	printf("ASM read and write registers\n");
//*
	// combined approach
	while (1) {
		workio( sw, led);
		for (int i=0; i<100000; i ++){}
	}
/*/
	// separate approach: see what is happening
	while (1) {
		content = readio(sw);
		printf("DEBUG: '0x%02x'\n", content);
		printf("DEBUG: writeio( 0x%02x, 0x%02x) => stbio 0x%02x, 0(0x%02x)\n", led, content, led, content);
		writeio( led, content);

		// some sleep for visual verification
		for (int i=0; i<100000; i ++){}
	}
// */

    return 0;
}

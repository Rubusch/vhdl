/*
 * main.c
 *
 *  Created on: Aug 25, 2020
 *      Author: user
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// read io
#define readio(addr) \
    (    {  unsigned char val; \
          asm volatile( "ldbio %0, 0(%1)" :"=r"(val) : "r" (addr)); val;} \
    )

#define writeio(addr, val) \
    (    {  unsigned char dummy; \
          asm volatile( "stbio %0, 0(%1)" :"=r"(dummy) : "r" (addr)); } \
    )

// TODO
#define workio(addr_from, addr_to) \
    (    {  unsigned char dummy; \
          asm volatile( "loop: ldbio %0, 0(%2); stbio %0, 0(%1); br loop" :"=r"(dummy) : "r" (addr_from), "r" (addr_to)); } \
    )

// read/write ctl
#define CTL_STATUS    0  /* Processor status reg  */
# define CTL_ESTATUS    1  /* Exception status reg  */
# define CTL_BSTATUS    2  /* Break status reg  */
# define CTL_IENABLE    3  /* Interrut enable reg  */
# define CTL_IPENDING    4  /* Interrut pending reg  */

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
// NB: obtain addresses from qsys!!!
	int sw=0x08021000;
	int led=0x08021010;

	unsigned char content = 0x0;
	int i;


/*
	__asm__ __volatile__ (
		".equ        sw, 0x00002010\n\t"
		".equ        led, 0x00002000\n\t"
		".global     _start\n\t"
		"_start:\n\t"
					"movia    r2, sw\n\t"
					"movia    r3, led\n\t"

		"loop:       ldbio    r4, 0(r2)\n\t"
					"stbio    r4, 0(r3)\n\t"
					"br       loop\n\t"
*/

//	content = readio(sw);
//	writeio(led, content);

	printf("AAA\n");
	//while (1) {
		workio( sw, led);
//		content = readio(sw);
		printf("XXX '%x'\n", content);

		for (i=0; i<500000; i ++){}
//	}

	return 0;
}

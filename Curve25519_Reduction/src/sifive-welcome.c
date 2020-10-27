/* Copyright 2019 SiFive, Inc */
/* SPDX-License-Identifier: Apache-2.0 */

#include <stdio.h>
#include <metal/cpu.h>
#include <metal/led.h>
#include <metal/button.h>
#include <metal/switch.h>
#include <stdint.h>
#include <string.h>
#include "util.h"
#include "ECC.h"


#define RTC_FREQ    32768

struct metal_cpu *cpu;
struct metal_interrupt *cpu_intr, *tmr_intr;
int tmr_id;
volatile uint32_t timer_isr_flag;

extern void curve25519_reduction_asm(uint16_t* src, uint16_t* res);

extern void AES_128_encrypt(const uint8_t *, const uint8_t *, uint8_t *);

extern void present_enc_p4(unsigned char* plaintext, unsigned char* rkey, unsigned char* pbox_0, unsigned char* pbox_1, unsigned char* pbox_2, unsigned char* pbox_3);




void display_banner (void) {

    printf("\n");
    printf("\n");
    printf("                  SIFIVE, INC.\n");
    printf("\n");
    printf("           5555555555555555555555555\n");
    printf("          5555                   5555\n");
    printf("         5555                     5555\n");
    printf("        5555                       5555\n");
    printf("       5555       5555555555555555555555\n");
    printf("      5555       555555555555555555555555\n");
    printf("     5555                             5555\n");
    printf("    5555                               5555\n");
    printf("   5555                                 5555\n");
    printf("  5555555555555555555555555555          55555\n");
    printf("   55555           555555555           55555\n");
    printf("     55555           55555           55555\n");
    printf("       55555           5           55555\n");
    printf("         55555                   55555\n");
    printf("           55555               55555\n");
    printf("             55555           55555\n");
    printf("               55555       55555\n");
    printf("                 55555   55555\n");
    printf("                   555555555\n");
    printf("                     55555\n");
    printf("                       5\n");
    printf("\n");

    printf("\n");
    printf("               Welcome to SiFive!\n");

}

void timer_isr (int id, void *data) {

    // Disable Timer interrupt
    metal_interrupt_disable(tmr_intr, tmr_id);

    // Flag showing we hit timer isr
    timer_isr_flag = 1;
}

void wait_for_timer(struct metal_led *which_led) {

    // clear global timer isr flag
    timer_isr_flag = 0;

    // Turn on desired LED
    metal_led_on(which_led);

    // Set timer
    metal_cpu_set_mtimecmp(cpu, metal_cpu_get_mtime(cpu) + RTC_FREQ);

    // Enable Timer interrupt
    metal_interrupt_enable(tmr_intr, tmr_id);

    // wait till timer triggers and isr is hit
    while (timer_isr_flag == 0){};

    timer_isr_flag = 0;

    // Turn off this LED
    metal_led_off(which_led);
}

int main (void)
{
    int rc;
    struct metal_led *led0_red, *led0_green, *led0_blue;

    // This demo will toggle LEDs colors so we define them here
    led0_red = metal_led_get_rgb("LD0", "red");
    led0_green = metal_led_get_rgb("LD0", "green");
    led0_blue = metal_led_get_rgb("LD0", "blue");
    if ((led0_red == NULL) || (led0_green == NULL) || (led0_blue == NULL)) {
        printf("At least one of LEDs is null.\n");
        return 1;
    }

    // Enable each LED
    metal_led_enable(led0_red);
    metal_led_enable(led0_green);
    metal_led_enable(led0_blue);

    // All Off
    metal_led_off(led0_red);
    metal_led_off(led0_green);
    metal_led_off(led0_blue);

    // Lets get the CPU and and its interrupt
    cpu = metal_cpu_get(metal_cpu_get_current_hartid());
    if (cpu == NULL) {
        printf("CPU null.\n");
        return 2;
    }
    cpu_intr = metal_cpu_interrupt_controller(cpu);
    if (cpu_intr == NULL) {
        printf("CPU interrupt controller is null.\n");
        return 3;
    }
    metal_interrupt_init(cpu_intr);
    // display welcome banner
    //display_banner();
//////////////////////////////////////////////[our code section_start]///////////////////////////////////////////////////////////////

	int cnt_i = 0x00;
	int round = 1000;
	uint16_t src[32] = {0x00};
	uint16_t res[16] = {0x00};
	uint16_t temp = 0x1234;
	uint64_t oldcount = 0x00;
	uint64_t cyclecount = 0x00;


	/*for(cnt_i = 0 ;  cnt_i <16 ; cnt_i ++)
	{
		src[cnt_i] = 0x5678+cnt_i;
	}

	for(cnt_i = 16 ;  cnt_i <32 ; cnt_i ++)
	{
			src[cnt_i] = temp+cnt_i;
	}

	for(cnt_i = 31 ;  cnt_i >=0 ; cnt_i --)
	{
		printf("%04X", src[cnt_i]);
	}*/



//    printf("\n result \n");
//    for(cnt_i = 15 ;  cnt_i >=0 ; cnt_i --)
//    {
//    	printf("%04X", res[cnt_i]);
//    }


	 unsigned char plaintext4[32] = {0x00};
	 unsigned char pbox_0[256] = {0x00};
	 unsigned char pbox_1[256] = {0x00};
	 unsigned char pbox_2[256] = {0x00};
	 unsigned char pbox_3[256] = {0x00};
	 unsigned char rkey[330] = {0x00};


//	 oldcount = getcycles();
//	 for(cnt_i = 0 ; cnt_i <round ; cnt_i ++)
//	 {
//	 present_enc_p4(plaintext4, rkey, pbox_0, pbox_1, pbox_2, pbox_3);
//	 }
//	 cyclecount = getcycles();
//
//	 printf("present 4enc cyc: %d\n", (unsigned int)((cyclecount-oldcount)/round));



    const uint8_t key[16] = {4,5,6,7,4,5,6,8,4,5,6,9,4,5,6,10};
    uint8_t in[16] = {0,0,0,0,1,2,3,1,2,4,1,2,5,1,2,6};
    uint8_t out[16];
    uint8_t rk[11*16];

    memcpy(rk, key, 16);

    // Fill instruction cache and train branch predictors
    AES_128_encrypt(rk, in, out);
    AES_128_encrypt(rk, in, out);
    AES_128_encrypt(rk, in, out);
    AES_128_encrypt(rk, in, out);
    AES_128_encrypt(rk, in, out);


    oldcount = getcycles();
    for(cnt_i = 0 ; cnt_i <round ; cnt_i ++)
    {
    AES_128_encrypt(rk, in, out);
    }
    cyclecount = getcycles();
    printf("aes128 encryption final cyc: %d\n", (unsigned int)((cyclecount - oldcount)/round));


    curve25519_reduction_asm(src,res);
    curve25519_reduction_asm(src,res);
    curve25519_reduction_asm(src,res);
    curve25519_reduction_asm(src,res);
    curve25519_reduction_asm(src,res);


    oldcount = getcycles();
    for(cnt_i = 0 ; cnt_i <round ; cnt_i ++)
    {
    curve25519_reduction_asm(src,res);
    }
    cyclecount = getcycles();
    printf("curve25519 reduction cyc: %d\n", (unsigned int)((cyclecount - oldcount)/round));


    uint32_t curve_input[16] = {0x00,};
    uint32_t curve_res[8] = {0x00};
    uint32_t curve_prime[8] = {0x00};
    uint32_t temp2 = 0x77777777;
    unsigned char len_c = 0x00;
    for(cnt_i = 0 ; cnt_i < 8 ; cnt_i ++)
    {
    	curve_input[cnt_i] = temp2;
    }
    //r 결과, a 곱셈 넣어주는거, m 모듈러, len 0;

    //'0x 7fffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffed'

    curve_prime[0] = 0xffffffed;
    curve_prime[1] = 0xffffffff;
    curve_prime[2] = 0xffffffff;
    curve_prime[3] = 0xffffffff;
    curve_prime[4] = 0xffffffff;
    curve_prime[5] = 0xffffffff;
    curve_prime[6] = 0xffffffff;
    curve_prime[7] = 0x7fffffff;

    oldcount = getcycles();
    for(cnt_i = 0 ; cnt_i < round ; cnt_i ++)
    {
    	BN_modular(curve_res, curve_input,curve_prime, 0);
    }
    cyclecount = getcycles();
    printf("curve25519 C lang ver cyc: %d\n", (unsigned int)((cyclecount - oldcount)/round));






//////////////////////////////////////////////[our code section_end]///////////////////////////////////////////////////////////////
    //[this section is finial init RISC-V]
    // Setup Timer and its interrupt so we can toggle LEDs on 1s cadence
    tmr_intr = metal_cpu_timer_interrupt_controller(cpu);
    if (tmr_intr == NULL) {
        printf("TIMER interrupt controller is  null.\n");
        return 4;
    }
    metal_interrupt_init(tmr_intr);
    tmr_id = metal_cpu_timer_get_interrupt_id(cpu);
    rc = metal_interrupt_register_handler(tmr_intr, tmr_id, timer_isr, cpu);
    if (rc < 0) {
        printf("TIMER interrupt handler registration failed\n");
        return (rc * -1);
    }

    // Lastly CPU interrupt
    if (metal_interrupt_enable(cpu_intr, 0) == -1) {
        printf("CPU interrupt enable failed\n");
        return 6;
    }

    // Red -> Green -> Blue, repeat
    while (1) {

        // Turn on RED
        wait_for_timer(led0_red);

        // Turn on Green
        wait_for_timer(led0_green);

        // Turn on Blue
        wait_for_timer(led0_blue);
    }

    // return
    return 0;
}

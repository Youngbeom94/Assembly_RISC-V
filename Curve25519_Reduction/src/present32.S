.section .rodata

.section .text

.global present_enc_p4
.type present_enc_p4, @function

present_enc_p4:

	// 레지스터 스케줄링, 플래인텍스트, 템프, 주소값들
	//a0: plaintext[32] / a1: rkey[330] // a2: pbox_0 / a3: pbox_1 / a4: pbox_2 / a5: pbox_3
	//s2: cipher[0]/ s3: cipher[1]/ s4: cipher[2]/ s5: cipher[3]/ s6: cipher[4]/ s7: cipher[5]/ s8: cipher[6]/ s9: cipher[7]
	//temp : t3, t4

	//5개 추가하기
	//stack push

	addi    sp, sp, -8         // stack pointer handling
    sw      ra, 0(sp)

    addi    sp, sp, -8
    sw      gp, 0(sp)

    addi    sp, sp, -8
    sw      tp, 0(sp)

    addi    sp,sp,-8
    sw      t0, 0(sp)

  	addi    sp,sp,-8
    sw      t1, 0(sp)

    addi    sp,sp,-8
    sw      t2, 0(sp)

    addi    sp,sp,-8
    sw      s0, 0(sp)

    addi    sp,sp,-8
    sw      s1, 0(sp)

    addi    sp,sp,-8
    sw      a0, 0(sp)

    addi    sp,sp,-8
    sw      a1, 0(sp)

    addi    sp,sp,-8
    sw      a2, 0(sp)

    addi    sp,sp,-8
    sw      a3, 0(sp)

    addi    sp,sp,-8
    sw      a4, 0(sp)


/****************************/


	li		t5, 0xff


/****************call plaintext*********************/
	//s2
   lbu		t3, 0(a0)
   or		s2, t3, s2
   slli		s2, s2, 8

   lbu		t3, 8(a0)
   or		s2, t3, s2
   slli		s2, s2, 8

   lbu		t3, 16(a0)
   or		s2, t3, s2
   slli		s2, s2, 8

   lbu		t3, 24(a0)
   or		s2, t3, s2

   //s3
   lbu		t3, 1(a0)
   or		s3, t3, s3
   slli		s3, s3, 8

   lbu		t3, 9(a0)
   or		s3, t3, s3
   slli		s3, s3, 8

   lbu		t3, 17(a0)
   or		s3, t3, s3
   slli		s3, s3, 8

   lbu		t3, 25(a0)
   or		s3, t3, s3

   //s4
   lbu		t3, 2(a0)
   or		s4, t3, s4
   slli		s4, s4, 8

   lbu		t3, 10(a0)
   or		s4, t3, s4
   slli		s4, s4, 8

   lbu		t3, 18(a0)
   or		s4, t3, s4
   slli		s4, s4, 8

   lbu		t3, 26(a0)
   or		s4, t3, s4

   //s5
   lbu		t3, 3(a0)
   or		s5, t3, s5
   slli		s5, s5, 8

   lbu		t3, 11(a0)
   or		s5, t3, s5
   slli		s5, s5, 8

   lbu		t3, 19(a0)
   or		s5, t3, s5
   slli		s5, s5, 8

   lbu		t3, 27(a0)
   or		s5, t3, s5

   //s6
   lbu		t3, 4(a0)
   or		s6, t3, s6
   slli		s6, s6, 8

   lbu		t3, 12(a0)
   or		s6, t3, s6
   slli		s6, s6, 8

   lbu		t3, 20(a0)
   or		s6, t3, s6
   slli		s6, s6, 8

   lbu		t3, 28(a0)
   or		s6, t3, s6

   //s7
   lbu		t3, 5(a0)
   or		s7, t3, s7
   slli		s7, s7, 8

   lbu		t3, 13(a0)
   or		s7, t3, s7
   slli		s7, s7, 8

   lbu		t3, 21(a0)
   or		s7, t3, s7
   slli		s7, s7, 8

   lbu		t3, 29(a0)
   or		s7, t3, s7

   //s8
   lbu		t3, 6(a0)
   or		s8, t3, s8
   slli		s8, s8, 8

   lbu		t3, 14(a0)
   or		s8, t3, s8
   slli		s8, s8, 8

   lbu		t3, 22(a0)
   or		s8, t3, s8
   slli		s8, s8, 8

   lbu		t3, 30(a0)
   or		s8, t3, s8

   //s9
   lbu		t3, 7(a0)
   or		s9, t3, s9
   slli		s9, s9, 8

   lbu		t3, 15(a0)
   or		s9, t3, s9
   slli		s9, s9, 8

   lbu		t3, 23(a0)
   or		s9, t3, s9
   slli		s9, s9, 8

   lbu		t3, 31(a0)
   or		s9, t3, s9


	//0xc0c0c0c0
   li		a7, 0xc0c0c0c0
   //0x30303030
   li		s10, 0x30303030
   //0x0c0c0c0c
   li		s11, 0x0c0c0c0c
   //0x03030303
   li		a6, 0x03030303

   add		t6, zero, zero; //unsigned int round = 0;

    Loop:

	li		ra, 0x000
	li		gp, 0x000
	li		tp, 0x000
	li		t0, 0x000
	li		t1, 0x000
	li		t2, 0x000
	li		s0, 0x000
	li		s1, 0x000


	// addroundkey
	//state[0] = plaintext[0] ^ rkey[round_counter + 0];
	//rkey[round_counter + 0]
	add		t3, t6, a1
	lbu		t3, 0(t3)
	//rkey[round_counter + 0]||rkey[round_counter + 0]||rkey[round_counter + 0]||rkey[round_counter + 0]
	li		t4, 0x000
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s2, s2, t4

	//state[1] = plaintext[1] ^ rkey[round_counter + 1];
	li		t4, 0x000
	addi	t3, t6, 1
	add		t3, t3, a1
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s3, s3, t4

	//state[2] = plaintext[2] ^ rkey[round_counter + 2];
	li		t4, 0x000
	addi	t3, t6, 2
	add		t3, t3, a1
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s4, s4, t4

	//state[3] = plaintext[3] ^ rkey[round_counter + 3];
	li		t4, 0x000
	addi	t3, t6, 3
	add		t3, t3, a1
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s5, s5, t4

	//state[4] = plaintext[4] ^ rkey[round_counter + 4];
	li		t4, 0x000
	addi	t3, t6, 4
	add		t3, t3, a1
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s6, s6, t4

	//state[5] = plaintext[5] ^ rkey[round_counter + 5];
	li		t4, 0x000
	addi	t3, t6, 5
	add		t3, t3, a1
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s7, s7, t4

	//state[6] = plaintext[6] ^ rkey[round_counter + 6];
	li		t4, 0x000
	addi	t3, t6, 6
	add		t3, t3, a1
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s8, s8, t4

	//state[7] = plaintext[7] ^ rkey[round_counter + 7];
	li		t4, 0x000
	addi	t3, t6, 7
	add		t3, t3, a1
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s9, s9, t4

	//output[0] = (pbox_3[state[0]] & 0xC0) | (pbox_2[state[1]] & 0x30) | (pbox_1[state[2]] & 0x0C) | (pbox_0[state[3]] & 0x03);
	srli	t3, s2, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		ra, ra, t3
	slli	ra, ra, 8

	srli	t3, s2, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		ra, ra, t3
	slli	ra, ra, 8

	srli	t3, s2, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		ra, ra, t3
	slli	ra, ra, 8

	and		t3, s2, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		ra, ra, t3

	and		ra, ra, a7

	li		t4, 0x000
	srli	t3, s3, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		ra, ra, t4

	li		t4, 0x000
	srli	t3, s4, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s4, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		ra, ra, t4

	li		t4, 0x000
	srli	t3, s5, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s5, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		ra, ra, t4

	//output[1] = (pbox_3[state[4]] & 0xC0) | (pbox_2[state[5]] & 0x30) | (pbox_1[state[6]] & 0x0C) | (pbox_0[state[7]] & 0x03);
	srli	t3, s6, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		gp, gp, t3
	slli	gp, gp, 8

	srli	t3, s6, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		gp, gp, t3
	slli	gp, gp, 8

	srli	t3, s6, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		gp, gp, t3
	slli	gp, gp, 8

	and		t3, s6, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		gp, gp, t3

	and		gp, gp, a7

	li		t4, 0x000
	srli	t3, s7, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s7, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		gp, gp, t4

	li		t4, 0x000
	srli	t3, s8, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s8, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		gp, gp, t4

	li		t4, 0x000
	srli	t3, s9, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s9, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s9, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s9, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		gp, gp, t4

	//output[2] = (pbox_0[state[0]] & 0xC0) | (pbox_3[state[1]] & 0x30) | (pbox_2[state[2]] & 0x0C) | (pbox_1[state[3]] & 0x03);
	srli	t3, s2, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		tp, tp, t3
	slli	tp, tp, 8

	srli	t3, s2, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		tp, tp, t3
	slli	tp, tp, 8

	srli	t3, s2, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		tp, tp, t3
	slli	tp, tp, 8

	and		t3, s2, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		tp, tp, t3

	and		tp, tp, a7

	li		t4, 0x000
	srli	t3, s3, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		tp, tp, t4

	li		t4, 0x000
	srli	t3, s4, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s4, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		tp, tp, t4

	li		t4, 0x000
	srli	t3, s5, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s5, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		tp, tp, t4

	//output[3] = (pbox_0[state[4]] & 0xC0) | (pbox_3[state[5]] & 0x30) | (pbox_2[state[6]] & 0x0C) | (pbox_1[state[7]] & 0x03);
	srli	t3, s6, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t0, t0, t3
	slli	t0, t0, 8

	srli	t3, s6, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t0, t0, t3
	slli	t0, t0, 8

	srli	t3, s6, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t0, t0, t3
	slli	t0, t0, 8

	and		t3, s6, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t0, t0, t3

	and		t0, t0, a7

	li		t4, 0x000
	srli	t3, s7, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s7, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		t0, t0, t4

	li		t4, 0x000
	srli	t3, s8, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s8, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		t0, t0, t4

	li		t4, 0x000
	srli	t3, s9, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s9, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s9, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s9, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		t0, t0, t4

	//output[4] = (pbox_1[state[0]] & 0xC0) | (pbox_0[state[1]] & 0x30) | (pbox_3[state[2]] & 0x0C) | (pbox_2[state[3]] & 0x03);
	srli	t3, s2, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t1, t1, t3
	slli	t1, t1, 8

	srli	t3, s2, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t1, t1, t3
	slli	t1, t1, 8

	srli	t3, s2, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t1, t1, t3
	slli	t1, t1, 8

	and		t3, s2, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t1, t1, t3

	and		t1, t1, a7

	li		t4, 0x000
	srli	t3, s3, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		t1, t1, t4

	li		t4, 0x000
	srli	t3, s4, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s4, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		t1, t1, t4

	li		t4, 0x000
	srli	t3, s5, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s5, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		t1, t1, t4

	//output[5] = (pbox_1[state[4]] & 0xC0) | (pbox_0[state[5]] & 0x30) | (pbox_3[state[6]] & 0x0C) | (pbox_2[state[7]] & 0x03);
	srli	t3, s6, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t2, t2, t3
	slli	t2, t2, 8

	srli	t3, s6, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t2, t2, t3
	slli	t2, t2, 8

	srli	t3, s6, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t2, t2, t3
	slli	t2, t2, 8

	and		t3, s6, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t2, t2, t3

	and		t2, t2, a7

	li		t4, 0x000
	srli	t3, s7, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s7, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		t2, t2, t4

	li		t4, 0x000
	srli	t3, s8, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s8, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		t2, t2, t4

	li		t4, 0x000
	srli	t3, s9, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s9, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s9, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s9, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		t2, t2, t4

	//output[6] = (pbox_2[state[0]] & 0xC0) | (pbox_1[state[1]] & 0x30) | (pbox_0[state[2]] & 0x0C) | (pbox_3[state[3]] & 0x03);
	srli	t3, s2, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s0, s0, t3
	slli	s0, s0, 8

	srli	t3, s2, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s0, s0, t3
	slli	s0, s0, 8

	srli	t3, s2, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s0, s0, t3
	slli	s0, s0, 8

	and		t3, s2, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s0, s0, t3

	and		s0, s0, a7

	li		t4, 0x000
	srli	t3, s3, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s3, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		s0, s0, t4

	li		t4, 0x000
	srli	t3, s4, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s4, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s4, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		s0, s0, t4

	li		t4, 0x000
	srli	t3, s5, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s5, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s5, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		s0, s0, t4

	//output[7] = (pbox_2[state[4]] & 0xC0) | (pbox_1[state[5]] & 0x30) | (pbox_0[state[6]] & 0x0C) | (pbox_3[state[7]] & 0x03);
	srli	t3, s6, 24
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s1, s1, t3
	slli	s1, s1, 8

	srli	t3, s6, 16
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s1, s1, t3
	slli	s1, s1, 8

	srli	t3, s6, 8
	and		t3, t3, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s1, s1, t3
	slli	s1, s1, 8

	and		t3, s6, t5
	add		t3, a4, t3
	lbu		t3, 0(t3)
	or		s1, s1, t3

	and		s1, s1, a7

	li		t4, 0x000
	srli	t3, s7, 24
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 16
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s7, 8
	and		t3, t3, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s7, t5
	add		t3, a3, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s10
	or		s1, s1, t4

	li		t4, 0x000
	srli	t3, s8, 24
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 16
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s8, 8
	and		t3, t3, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s8, t5
	add		t3, a2, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, s11
	or		s1, s1, t4

	li		t4, 0x000
	srli	t3, s9, 24
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	srli	t3, s9, 16
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8
	and		t3, t3, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3
	slli	t4, t4, 8

	and		t3, s9, t5
	add		t3, a5, t3
	lbu		t3, 0(t3)
	or		t4, t4, t3

	and		t4, t4, a6
	or		s1, s1, t4

	/**************************/
	add		s2, zero, ra
	add		s3, zero, gp
	add		s4, zero, tp
	add		s5, zero, t0
	add		s6, zero, t1
	add		s7, zero, t2
	add		s8, zero, s0
	add		s9, zero, s1


	/**************************/
	addi	t6, t6, 10
	li		t4, 300
	bgeu 	t4, t6, Loop

	//END LOOP

	// addroundkey
	//state[0] = plaintext[0] ^ rkey[310];
	//rkey[310]
	addi	t3, a1, 310
	lbu		t3, 0(t3)
	//rkeyrkey[310]||rkeyrkey[310]||rkeyrkey[310]||rkeyrkey[310]
	li		t4, 0x000
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s2, s2, t4

	//state[1] = plaintext[1] ^ rkey[311];
	li		t4, 0x000
	addi	t3, a1, 311
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s3, s3, t4

	//state[2] = plaintext[2] ^ rkey[312];
	li		t4, 0x000
	addi	t3, a1, 312
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s4, s4, t4

	//state[3] = plaintext[3] ^ rkey[313];
	li		t4, 0x000
	addi	t3, a1, 313
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s5, s5, t4

	//state[4] = plaintext[4] ^ rkey[314];
	li		t4, 0x000
	addi	t3, a1, 314
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s6, s6, t4

	//state[5] = plaintext[5] ^ rkey[315];
	li		t4, 0x000
	addi	t3, a1, 315
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s7, s7, t4

	//state[6] = plaintext[6] ^ rkey[316];
	li		t4, 0x000
	addi	t3, a1, 316
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s8, s8, t4

	//state[7] = plaintext[7] ^ rkey[317];
	li		t4, 0x000
	addi	t3, a1, 317
	lbu		t3, 0(t3)

	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4
	slli	t4, t4, 8
	or		t4, t3, t4

	xor		s9, s9, t4

	//store byte
	and		t3, s2, t5
	sb		t3, 0(a0)
	and		t3, s3, t5
	sb		t3, 1(a0)
	and		t3, s4, t5
	sb		t3, 2(a0)
	and		t3, s5, t5
	sb		t3, 3(a0)
	and		t3, s6, t5
	sb		t3, 4(a0)
	and		t3, s7, t5
	sb		t3, 5(a0)
	and		t3, s8, t5
	sb		t3, 6(a0)
	and		t3, s9, t5
	sb		t3, 7(a0)

	srli	s2, s2, 8
	and		t3, s2, t5
	sb		t3, 8(a0)

	srli	s3, s3, 8
	and		t3, s3, t5
	sb		t3, 9(a0)

	srli	s4, s4, 8
	and		t3, s4, t5
	sb		t3, 10(a0)

	srli	s5, s5, 8
	and		t3, s5, t5
	sb		t3, 11(a0)

	srli	s6, s6, 8
	and		t3, s6, t5
	sb		t3, 12(a0)

	srli	s7, s7, 8
	and		t3, s7, t5
	sb		t3, 13(a0)

	srli	s8, s8, 8
	and		t3, s8, t5
	sb		t3, 14(a0)

	srli	s9, s9, 8
	and		t3, s9, t5
	sb		t3, 15(a0)

	srli	s2, s2, 8
	and		t3, s2, t5
	sb		t3, 16(a0)

	srli	s3, s3, 8
	and		t3, s3, t5
	sb		t3, 17(a0)

	srli	s4, s4, 8
	and		t3, s4, t5
	sb		t3, 18(a0)

	srli	s5, s5, 8
	and		t3, s5, t5
	sb		t3, 19(a0)

	srli	s6, s6, 8
	and		t3, s6, t5
	sb		t3, 20(a0)

	srli	s7, s7, 8
	and		t3, s7, t5
	sb		t3, 21(a0)

	srli	s8, s8, 8
	and		t3, s8, t5
	sb		t3, 22(a0)

	srli	s9, s9, 8
	and		t3, s9, t5
	sb		t3, 23(a0)

	srli	s2, s2, 8
	and		t3, s2, t5
	sb		t3, 24(a0)

	srli	s3, s3, 8
	and		t3, s3, t5
	sb		t3, 25(a0)

	srli	s4, s4, 8
	and		t3, s4, t5
	sb		t3, 26(a0)

	srli	s5, s5, 8
	and		t3, s5, t5
	sb		t3, 27(a0)

	srli	s6, s6, 8
	and		t3, s6, t5
	sb		t3, 28(a0)

	srli	s7, s7, 8
	and		t3, s7, t5
	sb		t3, 29(a0)

	srli	s8, s8, 8
	and		t3, s8, t5
	sb		t3, 30(a0)

	srli	s9, s9, 8
	and		t3, s9, t5
	sb		t3, 31(a0)


	//stack pop
	lw       a4, 0(sp)
 	addi    sp, sp, 8

   	lw       a3, 0(sp)
   	addi    sp, sp, 8

   	lw       a2, 0(sp)
   	addi    sp, sp, 8

   	lw       a1, 0(sp)
   	addi    sp, sp, 8

   	lw       a0, 0(sp)
   	addi      sp, sp, 8

   	lw       s1, 0(sp)
   	addi    sp, sp, 8

   	lw       s0, 0(sp)
   	addi    sp, sp, 8

   	lw       t2, 0(sp)
   	addi    sp, sp, 8

   	lw       t1, 0(sp)
   	addi    sp, sp, 8

   	lw       t0, 0(sp)
   	addi    sp, sp, 8

   	lw      tp, 0(sp)
   	addi    sp, sp, 8

   	lw      gp, 0(sp)
   	addi    sp, sp, 8

   	lw      ra, 0(sp)          // stack pointer handling
   	addi    sp, sp, 8

    ret

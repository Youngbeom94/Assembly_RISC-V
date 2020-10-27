/*
 * curve25519_asm.S
 *
 *  Created on: 2020. 10. 23.
 *      Author: ±è¿µ¹ü
 */


.section .text


.globl curve25519_reduction_asm
.type curve25519_reduction_asm, %function
.align 3

//a0 = src
//a1 = res
//x5 = t0 = 38
//x6 = t1 = 0xFFFF
//a2 = shift temp
//a3 = add temp (carry)
//a4 = add temp (add)
curve25519_reduction_asm:
	addi	t0,	x0,	0x26 //x5 = 38
	addi 	t1,	x0,	0xFF //x6 = 0xFFFF
	slli	t1,	t1,	8
	addi 	t1,	t1,	0xFF



	//[ Step 1 ]
	// load data of src from 2^256 ~ 2^511 and mul 0x 26
	// Consider 2^255 = 19 mod (2^255-19)
	// Therefore 2^256 = 38 mod (2^255-19)

	addi    sp, sp, -76
    sw      t0,  4(sp)
    sw      t1,  8(sp)
    sw      s0, 12(sp)
    sw      s1, 16(sp)
    sw      s2, 20(sp)
    sw      s3, 24(sp)
    sw      s4, 28(sp)
    sw      s5, 32(sp)
    sw      s6, 36(sp)
    sw      s7, 40(sp)
    sw      s8, 44(sp)
    sw      s9, 48(sp)
    sw      s10, 52(sp)
    sw      s11, 56(sp)
    sw      t3, 60(sp)
    sw      t4, 64(sp)
    sw      t5, 68(sp)
    sw      t6, 72(sp)



	lhu		a6,	32(a0)
	mul		a6,	a6, t0

	lhu		a7,	34(a0)
	mul		a7,	a7, t0

	lhu		s2,	36(a0)
	mul		s2,	s2, t0

	lhu		s3,	38(a0)
	mul		s3,	s3, t0

	lhu		s4,	40(a0)
	mul		s4,	s4, t0

	lhu		s5,	42(a0)
	mul		s5,	s5, t0

	lhu		s6,	44(a0)
	mul		s6,	s6, t0

	lhu		s7,	46(a0)
	mul		s7,	s7, t0

	lhu		s8,	48(a0)
	mul		s8,	s8, t0

	lhu		s9,	50(a0)
	mul		s9,	s9, t0

	lhu		s10,	52(a0)
	mul		s10,	s10, 	t0

	lhu		s11,	54(a0)
	mul		s11,	s11, 	t0

	lhu		t3,	56(a0)
	mul		t3,	t3, t0

	lhu		t4,	58(a0)
	mul		t4,	t4, t0

	lhu		t5,	60(a0)
	mul		t5,	t5, t0

	lhu		t6,	62(a0)
	mul		t6,	t6, t0


	//[ Step 2 ]
	//	mul- handling
	//	make 2nd block

	srli	a2,	a6,	16
	and		a6,	a6,	x6 //0

	add		a7,	a7,	a2
	srli	a2,	a7,	16
	and		a7,	a7,	x6 //1

	add		s2,	s2,	a2
	srli	a2,	s2,	16
	and		s2,	s2,	x6 //2

	add		s3,	s3,	a2
	srli	a2,	s3,	16
	and		s3,	s3,	x6 //3

	add		s4,	s4,	a2
	srli	a2,	s4,	16
	and		s4,	s4,	x6 //4

	add		s5,	s5,	a2
	srli	a2,	s5,	16
	and		s5,	s5,	x6 //5

	add		s6,	s6,	a2
	srli	a2,	s6,	16
	and		s6,	s6,	x6 //6

	add		s7,	s7,	a2
	srli	a2,	s7,	16
	and		s7,	s7,	x6 //7

	add		s8,	s8,	a2
	srli	a2,	s8,	16
	and		s8,	s8,	x6 //8

	add		s9,	s9,	a2
	srli	a2,	s9,	16
	and		s9,	s9,	x6 //9

	add		s10,	s10,	a2
	srli	a2,		s10,	16
	and		s10,	s10,	x6 //10

	add		s11,	s11,	a2
	srli	a2,		s11,	16
	and		s11,	s11,	x6 //11

	add		t3,	t3,	a2
	srli	a2,	t3,	16
	and		t3,	t3,	x6 //12

	add		t4,	t4,	a2
	srli	a2,	t4,	16
	and		t4,	t4,	x6 //13

	add		t5,	t5,	a2
	srli	a2,	t5,	16
	and		t5,	t5,	x6 //14

	add		t6,	t6,	a2
	srli	a2,	t6,	16
	and		t6,	t6,	x6 //15

	//[ Step 3 ]
	// cacluate 2nd block's carry * 38
	// add 1nd block + carry*38 + 2nd block

	mul		a3,	a2,	x5
	add		a6,	a6,	a3

	lhu		a4,	0(a0)
	add		a6,	a6,	a4
	srli	a2,	a6,	16
	and		a6,	a6,	x6 //0

	lhu		a4,	2(a0)
	add		a7,	a7,	a4
	add		a7,	a7,	a2
	srli	a2,	a7,	16
	and		a7,	a7,	x6 //1

	lhu		a4,	4(a0)
	add		s2,	s2,	a4
	add		s2,	s2,	a2
	srli	a2,	s2,	16
	and		s2,	s2,	x6 //2

	lhu		a4,	6(a0)
	add		s3,	s3,	a4
	add		s3,	s3,	a2
	srli	a2,	s3,	16
	and		s3,	s3,	x6 //3

	lhu		a4,	8(a0)
	add		s4,	s4,	a4
	add		s4,	s4,	a2
	srli	a2,	s4,	16
	and		s4,	s4,	x6 //4

	lhu		a4,	10(a0)
	add		s5,	s5,	a4
	add		s5,	s5,	a2
	srli	a2,	s5,	16
	and		s5,	s5,	x6 //5

	lhu		a4,	12(a0)
	add		s6,	s6,	a4
	add		s6,	s6,	a2
	srli	a2,	s6,	16
	and		s6,	s6,	x6 //6

	lhu		a4,	14(a0)
	add		s7,	s7,	a4
	add		s7,	s7,	a2
	srli	a2,	s7,	16
	and		s7,	s7,	x6 //7

	lhu		a4,	16(a0)
	add		s8,	s8,	a4
	add		s8,	s8,	a2
	srli	a2,	s8,	16
	and		s8,	s8,	x6 //8

	lhu		a4,	18(a0)
	add		s9,	s9,	a4
	add		s9,	s9,	a2
	srli	a2,	s9,	16
	and		s9,	s9,	x6 //9

	lhu		a4,	20(a0)
	add		s10,	s10,	a4
	add		s10,	s10,	a2
	srli	a2,		s10,	16
	and		s10,	s10,	x6 //10

	lhu		a4,	22(a0)
	add		s11,	s11,	a4
	add		s11,	s11,	a2
	srli	a2,		s11,	16
	and		s11,	s11,	x6 //11

	lhu		a4,	24(a0)
	add		t3,	t3,	a4
	add		t3,	t3,	a2
	srli	a2,	t3,	16
	and		t3,	t3,	x6 //12

	lhu		a4,	26(a0)
	add		t4,	t4,	a4
	add		t4,	t4,	a2
	srli	a2,	t4,	16
	and		t4,	t4,	x6 //13

	lhu		a4,	28(a0)
	add		t5,	t5,	a4
	add		t5,	t5,	a2
	srli	a2,	t5,	16
	and		t5,	t5,	x6 //14

	lhu		a4,	30(a0)
	add		t6,	t6,	a4
	add		t6,	t6,	a2
	srli	a2,	t6,	16
	and		t6,	t6,	x6 //15


	beq		a2,	x0,finial_step

	//[ Step 4 ]
	// if it has carry, handling!
	mul		a3,	a2,	x5
	add		a6,	a6,	a3
	srli	a2,	a6,	16
	beq		a2,	x0,finial_step
	and		a6,	a6,	x6 //0

	add		a7,	a7,	a2
	srli	a2,	a7,	16
	beq		a2,	x0,finial_step
	and		a7,	a7,	x6 //1

	add		s2,	s2,	a2
	srli	a2,	s2,	16
	beq		a2,	x0,finial_step
	and		s2,	s2,	x6 //2

	add		s3,	s3,	a2
	srli	a2,	s3,	16
	beq		a2,	x0,finial_step
	and		s3,	s3,	x6 //3

	add		s4,	s4,	a2
	srli	a2,	s4,	16
	beq		a2,	x0,finial_step
	and		s4,	s4,	x6 //4

	add		s5,	s5,	a2
	srli	a2,	s5,	16
	beq		a2,	x0,finial_step
	and		s5,	s5,	x6 //5

	add		s6,	s6,	a2
	srli	a2,	s6,	16
	beq		a2,	x0,finial_step
	and		s6,	s6,	x6 //6

	add		s7,	s7,	a2
	srli	a2,	s7,	16
	beq		a2,	x0,finial_step
	and		s7,	s7,	x6 //7

	add		s8,	s8,	a2
	srli	a2,	s8,	16
	beq		a2,	x0,finial_step
	and		s8,	s8,	x6 //8

	add		s9,	s9,	a2
	srli	a2,	s9,	16
	beq		a2,	x0,finial_step
	and		s9,	s9,	x6 //9

	add		s10,	s10,	a2
	srli	a2,		s10,	16
	beq		a2,	x0,finial_step
	and		s10,	s10,	x6 //10

	add		s11,	s11,	a2
	srli	a2,		s11,	16
	beq		a2,	x0,finial_step
	and		s11,	s11,	x6 //11

	add		t3,	t3,	a2
	srli	a2,	t3,	16
	beq		a2,	x0,finial_step
	and		t3,	t3,	x6 //12

	add		t4,	t4,	a2
	srli	a2,	t4,	16
	beq		a2,	x0,finial_step
	and		t4,	t4,	x6 //13

	add		t5,	t5,	a2
	srli	a2,	t5,	16
	beq		a2,	x0,finial_step
	and		t5,	t5,	x6 //14

	add		t6,	t6,	a2
	srli	a2,	t6,	16
	beq		a2,	x0,finial_step
	and		t6,	t6,	x6 //15


finial_step:
	sh		a6,		0(a1)
	sh		a7,		2(a1)
	sh		s2,		4(a1)
	sh		s3,		6(a1)
	sh		s4,		8(a1)
	sh		s5,		10(a1)
	sh		s6,		12(a1)
	sh		s7,		14(a1)
	sh		s8,		16(a1)
	sh		s9,		18(a1)
	sh		s10,	20(a1)
	sh		s11,	22(a1)
	sh		t3,		24(a1)
	sh		t4,		26(a1)
	sh		t5,		28(a1)
	sh		t6,		30(a1)

	// pop
    lw      t0,  4(sp)
    lw      t1,  8(sp)
    lw      s0, 12(sp)
    lw      s1, 16(sp)
    lw      s2, 20(sp)
    lw      s3, 24(sp)
    lw      s4, 28(sp)
    lw      s5, 32(sp)
    lw      s6, 36(sp)
    lw      s7, 40(sp)
    lw      s8, 44(sp)
    lw      s9, 48(sp)
    lw      s10, 52(sp)
    lw      s11, 56(sp)
    lw      t3, 60(sp)
    lw      t4, 64(sp)
    lw      t5, 68(sp)
    lw      t6, 72(sp)
    addi    sp, sp, 76

	ret

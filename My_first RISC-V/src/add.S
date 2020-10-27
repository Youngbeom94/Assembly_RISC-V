.section .rodata

prompt: .asciz "Value of t0 = 0x%02X\n"

.section .text


.global mul
.type mul, @function

mul:
	lb		s3,		0(a0)
	lb		s4,		2(a0)
	mul		s7,		s3,s4
	andi	s7,	s7,	0x12


	lui		s3,		0x1234
	lui		s4,		0x5678
	mulh	s7,		s3,s4


	ret


.global test
.type test, @function

test:

	addi    sp, sp, -8         // stack pointer handling
    sw      ra, 0(sp)

    addi    sp, sp, -8
    sw      gp, 0(sp)

    addi    sp, sp, -8
    sw      tp, 0(sp)

   	addi 	sp,sp,-8
   	sw   	t0, 0(sp)

	addi 	sp,sp,-8
   	sw   	t1, 0(sp)

   	addi 	sp,sp,-8
   	sw   	t2, 0(sp)

   	addi 	sp,sp,-8
   	sw   	s0, 0(sp)

   	addi 	sp,sp,-8
   	sw   	s1, 0(sp)

   	addi 	sp,sp,-8
   	sw   	a0, 0(sp)

   	addi 	sp,sp,-8
   	sw   	a1, 0(sp)

   	addi 	sp,sp,-8
   	sw   	a2, 0(sp)

   	addi 	sp,sp,-8
   	sw   	a3, 0(sp)

   	addi 	sp,sp,-8
   	sw   	a4, 0(sp)



	li		a3,	3              //  a3 = 3
	add 	a0, a0, a3         //  SBOX address + 3(a3)
	lb		a4, 0(a0)          //  a4 = SBOX[3]

    la      a0, prompt         // load prompt adrress
    mv      a1, a4             // a1 = a4, for funcion argument
    call    printf             // call printf




   lw 		a4, 0(sp)
   addi 	sp, sp, 8

   lw 		a3, 0(sp)
   addi 	sp, sp, 8

   lw 		a2, 0(sp)
   addi 	sp, sp, 8

   lw 		a1, 0(sp)
   addi 	sp, sp, 8

   lw 		a0, 0(sp)
   addi		sp, sp, 8

   lw 		s1, 0(sp)
   addi 	sp, sp, 8

   lw 		s0, 0(sp)
   addi 	sp, sp, 8

   lw 		t2, 0(sp)
   addi 	sp, sp, 8

   lw 		t1, 0(sp)
   addi 	sp, sp, 8

   lw 		t0, 0(sp)
   addi 	sp, sp, 8

   lw      tp, 0(sp)
   addi    sp, sp, 8

   lw      gp, 0(sp)
   addi    sp, sp, 8

   lw      ra, 0(sp)          // stack pointer handling
   addi    sp, sp, 8

    ret

   //test function end---------------------------------------------------------------------------------------

.section .rodata
prompt2: .asciz "t0 is zero"
prompt3: .asciz "t1 is zero"
prompt4: .asciz "else condition"

.section .text

.global test_branch
.type test_branch, @function

test_branch:
	addi    sp, sp, -8 	       // stack pointer handling
    sw      ra, 0(sp)

	li		t0,	7
	xor		t0, t0,	t0


	// branch start!

	bne     t0, zero, 1f		  // if (!t0)
	# Code goes here if t0 == 0
	la      a0, prompt2        // load prompt adrress
    call    printf             // call printf
	j       2f


1:								  // elif(!t1)
	bne     t1, zero, 1f
	# Code goes here if t1 == 0
	la      a0, prompt3         // load prompt adrress
    call    printf             // call printf
	j       2f


1:								  // else ()
	# Code goes here if t0 != 0 and t1 != 0
	la      a0, prompt4        // load prompt adrress
    call    printf             // call printf

2:

	// branch end!

	lw      ra, 0(sp)          // stack pointer handling
    addi    sp, sp, 8

    ret
	lw      ra, 0(sp)          // stack pointer handling
    addi    sp, sp, 8

    ret

    //test_branch function end---------------------------------------------------------------------------------------

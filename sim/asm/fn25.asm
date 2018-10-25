;---------------------------
; test for mul/muls/mulsu
;---------------------------
    ldi  r16,0x1f
    ldi  r24,0x3f
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x8f
    ldi  r24,0xaf

    ldi  r17,0xb0
    ldi  r25,0x40
    mov  r6 ,r17
    mov  r9 ,r25
    ldi  r17,0x90
    ldi  r25,0x20

    mul  r7 ,r25
    movw r14,r0
    mul  r8 ,r17
    movw r12,r0
    mul  r16,r9
    movw r10,r0
    mul  r24,r6
    movw r8 ,r0
;-------------------
    ldi  r16,0x1f
    ldi  r18,0x3f
    ldi  r20,0x8f
    ldi  r25,0xaf

    ldi  r17,0xb0
    ldi  r19,0x40
    ldi  r21,0x90
    ldi  r24,0x20

    muls r16,r24
    movw r30,r0
    muls r18,r21
    movw r28,r0
    muls r20,r19
    movw r26,r0
    muls r25,r17
    movw r24,r0
;-------------------
   ;ldi  r16,0x1f
   ;ldi  r18,0x3f
   ;ldi  r20,0x8f
    ldi  r23,0xaf

   ;ldi  r17,0xb0
   ;ldi  r19,0x40
   ;ldi  r21,0x90
    ldi  r22,0x20

    mulsu r16,r22
    movw  r6 ,r0
    mulsu r18,r21
    movw  r4 ,r0
    mulsu r20,r19
    movw  r2 ,r0
    mulsu r23,r17
;-------------------
    sts  0x0100,r16     ; (ldi) 0x1f
    sts  0x0101,r22     ; (ldi) 0x20
    sts  0x0102,r14     ; (mul) 0x1f 0x20
    sts  0x0103,r15
    sts  0x0104,r30     ; (muls) 0x1f 0x20
    sts  0x0105,r31
    sts  0x0106,r6      ; (mulsu) 0x1f 0x20
    sts  0x0107,r7

    sts  0x0108,r18     ; (ldi) 0x2f
    sts  0x0109,r21     ; (ldi) 0xa0
    sts  0x010a,r12     ; (mul) 0x2f 0xa0
    sts  0x010b,r13
    sts  0x010c,r28     ; (muls) 0x2f 0xa0
    sts  0x010d,r29
    sts  0x010e,r4      ; (mulsu) 0x2f 0xa0
    sts  0x010f,r5

    sts  0x0110,r20     ; (ldi) 0x9f
    sts  0x0111,r19     ; (ldi) 0x40
    sts  0x0112,r10     ; (mul) 0x9f 0x40
    sts  0x0113,r11
    sts  0x0114,r26     ; (muls) 0x9f 0x40
    sts  0x0115,r27
    sts  0x0116,r2      ; (mulsu) 0x9f 0x40
    sts  0x0117,r3

    sts  0x0118,r23     ; (ldi) 0xaf
    sts  0x0119,r17     ; (ldi) 0xc0
    sts  0x011a,r8      ; (mul) 0xaf 0xc0
    sts  0x011b,r9
    sts  0x011c,r24     ; (muls) 0xaf 0xc0
    sts  0x011d,r25
    sts  0x011e,r0      ; (mulsu) 0xaf 0xc0
    sts  0x011f,r1
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

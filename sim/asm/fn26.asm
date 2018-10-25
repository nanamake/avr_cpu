;---------------------------
; test for fmul/fmuls/fmulsu
;---------------------------
    ldi  r16,0x1f
    ldi  r18,0x3f
    ldi  r20,0x8f
    ldi  r23,0xaf

    ldi  r17,0xb0
    ldi  r19,0x40
    ldi  r21,0x90
    ldi  r22,0x20

    fmul r16,r22
    movw r14,r0
    fmul r18,r21
    movw r12,r0
    fmul r20,r19
    movw r10,r0
    fmul r23,r17
    movw r8 ,r0
;-------------------
    fmuls r16,r22
    movw  r30,r0
    fmuls r18,r21
    movw  r28,r0
    fmuls r20,r19
    movw  r26,r0
    fmuls r23,r17
    movw  r24,r0
;-------------------
    fmulsu r16,r22
    movw   r6 ,r0
    fmulsu r18,r21
    movw   r4 ,r0
    fmulsu r20,r19
    movw   r2 ,r0
    fmulsu r23,r17
;-------------------
    sts  0x0100,r16     ; (ldi) 0x1f
    sts  0x0101,r22     ; (ldi) 0x20
    sts  0x0102,r14     ; (fmul) 0x1f 0x20
    sts  0x0103,r15
    sts  0x0104,r30     ; (fmuls) 0x1f 0x20
    sts  0x0105,r31
    sts  0x0106,r6      ; (fmulsu) 0x1f 0x20
    sts  0x0107,r7

    sts  0x0108,r18     ; (ldi) 0x2f
    sts  0x0109,r21     ; (ldi) 0xa0
    sts  0x010a,r12     ; (fmul) 0x2f 0xa0
    sts  0x010b,r13
    sts  0x010c,r28     ; (fmuls) 0x2f 0xa0
    sts  0x010d,r29
    sts  0x010e,r4      ; (fmulsu) 0x2f 0xa0
    sts  0x010f,r5

    sts  0x0110,r20     ; (ldi) 0x9f
    sts  0x0111,r19     ; (ldi) 0x40
    sts  0x0112,r10     ; (fmul) 0x9f 0x40
    sts  0x0113,r11
    sts  0x0114,r26     ; (fmuls) 0x9f 0x40
    sts  0x0115,r27
    sts  0x0116,r2      ; (fmulsu) 0x9f 0x40
    sts  0x0117,r3

    sts  0x0118,r23     ; (ldi) 0xaf
    sts  0x0119,r17     ; (ldi) 0xc0
    sts  0x011a,r8      ; (fmul) 0xaf 0xc0
    sts  0x011b,r9
    sts  0x011c,r24     ; (fmuls) 0xaf 0xc0
    sts  0x011d,r25
    sts  0x011e,r0      ; (fmulsu) 0xaf 0xc0
    sts  0x011f,r1
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

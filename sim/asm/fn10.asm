;-------------------------------
; test for mov/movw/ldi/lds/sts
;-------------------------------
    ldi  r16,0xff
    ldi  r24,0x10
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x20
    ldi  r24,0x30

    sts  0x0100,r7
    sts  0x0101,r8
    sts  0x0102,r16
    sts  0x0103,r24

    lds  r6 ,0x0100
    lds  r9 ,0x0101
    lds  r17,0x0102
    lds  r25,0x0103

    dec  r6
    inc  r9
    inc  r17
    inc  r25
;-------------------
    mov  r26,r6
    mov  r18,r9
    mov  r10,r17
    mov  r5 ,r25

    dec  r26
    inc  r18
    inc  r10
    inc  r5

    mov  r4 ,r26
    mov  r11,r18
    mov  r19,r10
    mov  r27,r5

    dec  r4
    inc  r11
    inc  r19
    inc  r27
;-------------------
    movw r30,r4
    movw r28,r6
    movw r22,r8
    movw r20,r10
    movw r14,r16
    movw r12,r18
    movw r2 ,r24
    movw r0 ,r26
;-------------------
    sts  0x0110,r0
    sts  0x0111,r1
    sts  0x0112,r2
    sts  0x0113,r3
    sts  0x0114,r4
    sts  0x0115,r5
    sts  0x0116,r6
    sts  0x0117,r7
    sts  0x0118,r8
    sts  0x0119,r9
    sts  0x011a,r10
    sts  0x011b,r11
    sts  0x011c,r12
    sts  0x011d,r13
    sts  0x011e,r14
    sts  0x011f,r15
    sts  0x0120,r16
    sts  0x0121,r17
    sts  0x0122,r18
    sts  0x0123,r19
    sts  0x0124,r20
    sts  0x0125,r21
    sts  0x0126,r22
    sts  0x0127,r23
    sts  0x0128,r24
    sts  0x0129,r25
    sts  0x012a,r26
    sts  0x012b,r27
    sts  0x012c,r28
    sts  0x012d,r29
    sts  0x012e,r30
    sts  0x012f,r31
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

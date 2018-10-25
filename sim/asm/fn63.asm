;-------------------
; test for adiw/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r24,0x00
    ldi  r25,0x00
    ldi  r26,0x01
    ldi  r27,0x00
    ldi  r28,0xff
    ldi  r29,0x7f
    ldi  r30,0xff
    ldi  r31,0xff

    movw r0 ,r24
    movw r2 ,r26
    movw r4 ,r28
    movw r6 ,r30
;-------------------
    out  sreg,r7
    adiw r26,0x00
    in   r8 ,sreg

    out  sreg,r0
    adiw r24,0x00
    in   r9 ,sreg

    adiw r28,0x01
    in   r10,sreg

    adiw r30,0x01
    in   r11,sreg

    movw r16,r24
    movw r18,r26
    movw r20,r28
    movw r22,r30
;-------------------
    out  sreg,r7
    sbiw r26,0x00
    in   r12,sreg

    out  sreg,r0
    sbiw r24,0x00
    in   r13,sreg

    sbiw r28,0x01
    in   r14,sreg

    sbiw r30,0x01
    in   r15,sreg
;-------------------
    sts  0x0100,r2      ; (ldi) 0x01
    sts  0x0101,r3      ; (ldi) 0x00
    sts  0x0102,r0      ; (ldi) 0x00
    sts  0x0103,r8      ; (adiw) 0x0001 0x00 ith-----

    sts  0x0104,r0      ; (ldi) 0x00
    sts  0x0105,r1      ; (ldi) 0x00
    sts  0x0106,r0      ; (ldi) 0x00
    sts  0x0107,r9      ; (adiw) 0x0000 0x00 ------z-

    sts  0x0108,r4      ; (ldi) 0xff
    sts  0x0109,r5      ; (ldi) 0x7f
    sts  0x010a,r2      ; (ldi) 0x01
    sts  0x010b,r10     ; (adiw) 0x7fff 0x01 ----vn--

    sts  0x010c,r6      ; (ldi) 0xff
    sts  0x010d,r7      ; (ldi) 0xff
    sts  0x010e,r2      ; (ldi) 0x01
    sts  0x010f,r11     ; (adiw) 0xffff 0x01 ------zc

    sts  0x0110,r18     ; (ldi) 0x01
    sts  0x0111,r19     ; (ldi) 0x00
    sts  0x0112,r0      ; (ldi) 0x00
    sts  0x0113,r12     ; (sbiw) 0x0001 0x00 ith-----

    sts  0x0114,r16     ; (ldi) 0x00
    sts  0x0115,r17     ; (ldi) 0x00
    sts  0x0116,r0      ; (ldi) 0x00
    sts  0x0117,r13     ; (sbiw) 0x0000 0x00 ------z-

    sts  0x0118,r20     ; (ldi) 0x00
    sts  0x0119,r21     ; (ldi) 0x80
    sts  0x011a,r2      ; (ldi) 0x01
    sts  0x011b,r14     ; (sbiw) 0x8000 0x01 ---sv---

    sts  0x011c,r22     ; (ldi) 0x00
    sts  0x011d,r23     ; (ldi) 0x00
    sts  0x011e,r2      ; (ldi) 0x01
    sts  0x011f,r15     ; (sbiw) 0x0000 0x01 ---s-n-c

    sts  0x0120,r18     ; (adiw) 0x0001 0x00
    sts  0x0121,r19
    sts  0x0122,r16     ; (adiw) 0x0000 0x00
    sts  0x0123,r17
    sts  0x0124,r20     ; (adiw) 0x7fff 0x01
    sts  0x0125,r21
    sts  0x0126,r22     ; (adiw) 0xffff 0x01
    sts  0x0127,r23

    sts  0x0128,r26     ; (sbiw) 0x0001 0x00
    sts  0x0129,r27
    sts  0x012a,r24     ; (sbiw) 0x0000 0x00
    sts  0x012b,r25
    sts  0x012c,r28     ; (sbiw) 0x8000 0x01
    sts  0x012d,r29
    sts  0x012e,r30     ; (sbiw) 0x0000 0x01
    sts  0x012f,r31
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

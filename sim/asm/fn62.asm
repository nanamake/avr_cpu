;-------------------
; test for subi/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x28
    ldi  r17,0x70
    ldi  r18,0xc0
    ldi  r19,0xd8

    ldi  r20,0x00
    ldi  r21,0x7f
    ldi  r22,0x80
    ldi  r23,0xff
;-------------------
    mov  r24,r16
    subi r24,0x28
    in   r0 ,sreg
    mov  r25,r17
    subi r25,0x28
    in   r1 ,sreg
    mov  r26,r16
    subi r26,0x70
    in   r2 ,sreg

    sez
    mov  r27,r20
    subi r27,0xff
    in   r3 ,sreg
    mov  r28,r16
    subi r28,0xd8
    in   r4 ,sreg
    mov  r29,r17
    subi r29,0xc0
    in   r5 ,sreg

    sez
    mov  r30,r22
    subi r30,0x7f
    in   r6 ,sreg
    mov  r31,r18
    subi r31,0x70
    in   r7 ,sreg
    mov  r24,r19
    subi r24,0x28
    in   r8 ,sreg

    sez
    mov  r25,r18
    subi r25,0xc0
    in   r9 ,sreg
    mov  r26,r19
    subi r26,0xc0
    in   r10,sreg
    mov  r27,r18
    subi r27,0xd8
    in   r11,sreg
;-------------------
    clc
    mov  r28,r16
    sbci r28,0x28
    in   r12,sreg
    mov  r29,r17
    sbci r29,0x28
    in   r13,sreg
    mov  r30,r16
    sbci r30,0x70
    in   r14,sreg

    sez
    mov  r31,r20
    sbci r31,0xff
    in   r15,sreg
    mov  r24,r16
    sbci r24,0xd8
    in   r24,sreg
    mov  r25,r17
    sbci r25,0xc0
    in   r25,sreg

    sez
    mov  r26,r22
    sbci r26,0x7f
    in   r26,sreg
    mov  r27,r18
    sbci r27,0x70
    in   r27,sreg
    mov  r28,r19
    sbci r28,0x28
    in   r28,sreg

    sez
    mov  r29,r18
    sbci r29,0xc0
    in   r29,sreg
    mov  r30,r19
    sbci r30,0xc0
    in   r30,sreg
    mov  r31,r18
    sbci r31,0xd8
    in   r31,sreg
;-------------------
    sts  0x0100,r16     ; (ldi) 0x28
    sts  0x0101,r16     ; (ldi) 0x28
    sts  0x0102,r0      ; (subi) 0x28 0x28 (cf=0 zf=0) ----z-
    sts  0x0103,r12     ; (sbci) 0x28 0x28 (cf=0 zf=0) ------

    sts  0x0104,r17     ; (ldi) 0x70
    sts  0x0105,r16     ; (ldi) 0x28
    sts  0x0106,r1      ; (subi) 0x70 0x28 (cf=0) h-----
    sts  0x0107,r13     ; (sbci) 0x70 0x28 (cf=0) h-----

    sts  0x0108,r16     ; (ldi) 0x28
    sts  0x0109,r17     ; (ldi) 0x70
    sts  0x010a,r2      ; (subi) 0x28 0x70 (cf=0) -s-n-c
    sts  0x010b,r14     ; (sbci) 0x28 0x70 (cf=0) -s-n-c
;-------------------
    sts  0x0110,r20     ; (ldi) 0x00
    sts  0x0111,r23     ; (ldi) 0xff
    sts  0x0112,r3      ; (subi) 0x00 0xff (cf=1 zf=1) h----c
    sts  0x0113,r15     ; (sbci) 0x00 0xff (cf=1 zf=1) h---zc

    sts  0x0114,r16     ; (ldi) 0x28
    sts  0x0115,r19     ; (ldi) 0xd8
    sts  0x0116,r4      ; (subi) 0x28 0xd8 (cf=1) -----c
    sts  0x0117,r24     ; (sbci) 0x28 0xd8 (cf=1) h----c

    sts  0x0118,r17     ; (ldi) 0x70
    sts  0x0119,r18     ; (ldi) 0xc0
    sts  0x011a,r5      ; (subi) 0x70 0xc0 (cf=1) --vn-c
    sts  0x011b,r25     ; (sbci) 0x70 0xc0 (cf=1) h-vn-c
;-------------------
    sts  0x0120,r22     ; (ldi) 0x80
    sts  0x0121,r21     ; (ldi) 0x7f
    sts  0x0122,r6      ; (subi) 0x80 0x7f (cf=1 zf=1) hsv---
    sts  0x0123,r26     ; (sbci) 0x80 0x7f (cf=1 zf=1) hsv-z-

    sts  0x0124,r18     ; (ldi) 0xc0
    sts  0x0125,r17     ; (ldi) 0x70
    sts  0x0126,r7      ; (subi) 0xc0 0x70 (cf=0) -sv---
    sts  0x0127,r27     ; (sbci) 0xc0 0x70 (cf=0) -sv---

    sts  0x0128,r19     ; (ldi) 0xd8
    sts  0x0129,r16     ; (ldi) 0x28
    sts  0x012a,r8      ; (subi) 0xd8 0x28 (cf=0) -s-n--
    sts  0x012b,r28     ; (sbci) 0xd8 0x28 (cf=0) -s-n--
;-------------------
    sts  0x0130,r18     ; (ldi) 0xc0
    sts  0x0131,r18     ; (ldi) 0xc0
    sts  0x0132,r9      ; (subi) 0xc0 0xc0 (cf=0 zf=1) ----z-
    sts  0x0133,r29     ; (sbci) 0xc0 0xc0 (cf=0 zf=1) ----z-

    sts  0x0134,r19     ; (ldi) 0xd8
    sts  0x0135,r18     ; (ldi) 0xc0
    sts  0x0136,r10     ; (subi) 0xd8 0xc0 (cf=0) ------
    sts  0x0137,r30     ; (sbci) 0xd8 0xc0 (cf=0) ------

    sts  0x0138,r18     ; (ldi) 0xc0
    sts  0x0139,r19     ; (ldi) 0xd8
    sts  0x013a,r11     ; (subi) 0xc0 0xd8 (cf=0) hs-n-c
    sts  0x013b,r31     ; (sbci) 0xc0 0xd8 (cf=0) hs-n-c
;-------------------
    out  sreg,r23
    mov  r30,r19
    subi r30,0xc0
    in   r10,sreg

    out  sreg,r23
    mov  r30,r19
    sbci r30,0xc0
    in   r30,sreg

    sts  0x013c,r19     ; (ldi) 0xd8
    sts  0x013d,r18     ; (ldi) 0xc0
    sts  0x013e,r10     ; (subi) 0xd8 0xc0 (cf=1) it------
    sts  0x013f,r30     ; (sbci) 0xd8 0xc0 (cf=1) it------
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

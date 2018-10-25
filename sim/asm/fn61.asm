;-------------------
; test for sub/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x28
    ldi  r24,0x70
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0xc0
    ldi  r24,0xd8

    ldi  r17,0x00
    ldi  r25,0x7f
    mov  r6 ,r17
    mov  r9 ,r25
    ldi  r17,0x80
    ldi  r25,0xff
;-------------------
    mov  r5 ,r7
    sub  r5 ,r7
    in   r5 ,sreg
    mov  r4 ,r8
    sub  r4 ,r7
    in   r4 ,sreg
    mov  r3 ,r7
    sub  r3 ,r8
    in   r3 ,sreg

    sez
    mov  r2 ,r6
    sub  r2 ,r25
    in   r2 ,sreg
    mov  r1 ,r7
    sub  r1 ,r24
    in   r1 ,sreg
    mov  r0 ,r8
    sub  r0 ,r16
    in   r0 ,sreg

    sez
    mov  r10,r17
    sub  r10,r9
    in   r10,sreg
    mov  r11,r16
    sub  r11,r8
    in   r11,sreg
    mov  r12,r24
    sub  r12,r7
    in   r12,sreg

    sez
    mov  r13,r16
    sub  r13,r16
    in   r13,sreg
    mov  r14,r24
    sub  r14,r16
    in   r14,sreg
    mov  r15,r16
    sub  r15,r24
    in   r15,sreg
;-------------------
    clc
    mov  r18,r7
    sbc  r18,r7
    in   r18,sreg
    mov  r19,r8
    sbc  r19,r7
    in   r19,sreg
    mov  r20,r7
    sbc  r20,r8
    in   r20,sreg

    sez
    mov  r21,r6
    sbc  r21,r25
    in   r21,sreg
    mov  r22,r7
    sbc  r22,r24
    in   r22,sreg
    mov  r23,r8
    sbc  r23,r16
    in   r23,sreg

    sez
    mov  r26,r17
    sbc  r26,r9
    in   r26,sreg
    mov  r27,r16
    sbc  r27,r8
    in   r27,sreg
    mov  r28,r24
    sbc  r28,r7
    in   r28,sreg

    sez
    mov  r29,r16
    sbc  r29,r16
    in   r29,sreg
    mov  r30,r24
    sbc  r30,r16
    in   r30,sreg
    mov  r31,r16
    sbc  r31,r24
    in   r31,sreg
;-------------------
    sts  0x0100,r7      ; (ldi) 0x28
    sts  0x0101,r7      ; (ldi) 0x28
    sts  0x0102,r5      ; (sub) 0x28 0x28 (cf=0 zf=0) ----z-
    sts  0x0103,r18     ; (sbc) 0x28 0x28 (cf=0 zf=0) ------

    sts  0x0104,r8      ; (ldi) 0x70
    sts  0x0105,r7      ; (ldi) 0x28
    sts  0x0106,r4      ; (sub) 0x70 0x28 (cf=0) h-----
    sts  0x0107,r19     ; (sbc) 0x70 0x28 (cf=0) h-----

    sts  0x0108,r7      ; (ldi) 0x28
    sts  0x0109,r8      ; (ldi) 0x70
    sts  0x010a,r3      ; (sub) 0x28 0x70 (cf=0) -s-n-c
    sts  0x010b,r20     ; (sbc) 0x28 0x70 (cf=0) -s-n-c
;-------------------
    sts  0x0110,r6      ; (ldi) 0x00
    sts  0x0111,r25     ; (ldi) 0xff
    sts  0x0112,r2      ; (sub) 0x00 0xff (cf=1 zf=1) h----c
    sts  0x0113,r21     ; (sbc) 0x00 0xff (cf=1 zf=1) h---zc

    sts  0x0114,r7      ; (ldi) 0x28
    sts  0x0115,r24     ; (ldi) 0xd8
    sts  0x0116,r1      ; (sub) 0x28 0xd8 (cf=1) -----c
    sts  0x0117,r22     ; (sbc) 0x28 0xd8 (cf=1) h----c

    sts  0x0118,r8      ; (ldi) 0x70
    sts  0x0119,r16     ; (ldi) 0xc0
    sts  0x011a,r0      ; (sub) 0x70 0xc0 (cf=1) --vn-c
    sts  0x011b,r23     ; (sbc) 0x70 0xc0 (cf=1) h-vn-c
;-------------------
    sts  0x0120,r17     ; (ldi) 0x80
    sts  0x0121,r9      ; (ldi) 0x7f
    sts  0x0122,r10     ; (sub) 0x80 0x7f (cf=1 zf=1) hsv---
    sts  0x0123,r26     ; (sbc) 0x80 0x7f (cf=1 zf=1) hsv-z-

    sts  0x0124,r16     ; (ldi) 0xc0
    sts  0x0125,r8      ; (ldi) 0x70
    sts  0x0126,r11     ; (sub) 0xc0 0x70 (cf=0) -sv---
    sts  0x0127,r27     ; (sbc) 0xc0 0x70 (cf=0) -sv---

    sts  0x0128,r24     ; (ldi) 0xd8
    sts  0x0129,r7      ; (ldi) 0x28
    sts  0x012a,r12     ; (sub) 0xd8 0x28 (cf=0) -s-n--
    sts  0x012b,r28     ; (sbc) 0xd8 0x28 (cf=0) -s-n--
;-------------------
    sts  0x0130,r16     ; (ldi) 0xc0
    sts  0x0131,r16     ; (ldi) 0xc0
    sts  0x0132,r13     ; (sub) 0xc0 0xc0 (cf=0 zf=1) ----z-
    sts  0x0133,r29     ; (sbc) 0xc0 0xc0 (cf=0 zf=1) ----z-

    sts  0x0134,r24     ; (ldi) 0xd8
    sts  0x0135,r16     ; (ldi) 0xc0
    sts  0x0136,r14     ; (sub) 0xd8 0xc0 (cf=0) ------
    sts  0x0137,r30     ; (sbc) 0xd8 0xc0 (cf=0) ------

    sts  0x0138,r16     ; (ldi) 0xc0
    sts  0x0139,r24     ; (ldi) 0xd8
    sts  0x013a,r15     ; (sub) 0xc0 0xd8 (cf=0) hs-n-c
    sts  0x013b,r31     ; (sbc) 0xc0 0xd8 (cf=0) hs-n-c
;-------------------
    out  sreg,r25
    mov  r14,r24
    sub  r14,r16
    in   r14,sreg

    out  sreg,r25
    mov  r30,r24
    sbc  r30,r16
    in   r30,sreg

    sts  0x013c,r24     ; (ldi) 0xd8
    sts  0x013d,r16     ; (ldi) 0xc0
    sts  0x013e,r14     ; (sub) 0xd8 0xc0 (cf=1) it------
    sts  0x013f,r30     ; (sbc) 0xd8 0xc0 (cf=1) it------
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

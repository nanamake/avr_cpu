;-------------------
; test for cp/cpc
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
    cp   r7 ,r7
    in   r5 ,sreg
    cp   r8 ,r7
    in   r4 ,sreg
    cp   r7 ,r8
    in   r3 ,sreg

    sez
    cp   r6 ,r25
    in   r2 ,sreg
    cp   r7 ,r24
    in   r1 ,sreg
    cp   r8 ,r16
    in   r0 ,sreg

    sez
    cp   r17,r9
    in   r10,sreg
    cp   r16,r8
    in   r11,sreg
    cp   r24,r7
    in   r12,sreg

    sez
    cp   r16,r16
    in   r13,sreg
    cp   r24,r16
    in   r14,sreg
    cp   r16,r24
    in   r15,sreg
;-------------------
    clc
    cpc  r7 ,r7
    in   r18,sreg
    cpc  r8 ,r7
    in   r19,sreg
    cpc  r7 ,r8
    in   r20,sreg

    sez
    cpc  r6 ,r25
    in   r21,sreg
    cpc  r7 ,r24
    in   r22,sreg
    cpc  r8 ,r16
    in   r23,sreg

    sez
    cpc  r17,r9
    in   r26,sreg
    cpc  r16,r8
    in   r27,sreg
    cpc  r24,r7
    in   r28,sreg

    sez
    cpc  r16,r16
    in   r29,sreg
    cpc  r24,r16
    in   r30,sreg
    cpc  r16,r24
    in   r31,sreg
;-------------------
    sts  0x0100,r7      ; (ldi) 0x28
    sts  0x0101,r7      ; (ldi) 0x28
    sts  0x0102,r5      ; (cp)  0x28 0x28 (cf=0 zf=0) ----z-
    sts  0x0103,r18     ; (cpc) 0x28 0x28 (cf=0 zf=0) ------

    sts  0x0104,r8      ; (ldi) 0x70
    sts  0x0105,r7      ; (ldi) 0x28
    sts  0x0106,r4      ; (cp)  0x70 0x28 (cf=0) h-----
    sts  0x0107,r19     ; (cpc) 0x70 0x28 (cf=0) h-----

    sts  0x0108,r7      ; (ldi) 0x28
    sts  0x0109,r8      ; (ldi) 0x70
    sts  0x010a,r3      ; (cp)  0x28 0x70 (cf=0) -s-n-c
    sts  0x010b,r20     ; (cpc) 0x28 0x70 (cf=0) -s-n-c
;-------------------
    sts  0x0110,r6      ; (ldi) 0x00
    sts  0x0111,r25     ; (ldi) 0xff
    sts  0x0112,r2      ; (cp)  0x00 0xff (cf=1 zf=1) h----c
    sts  0x0113,r21     ; (cpc) 0x00 0xff (cf=1 zf=1) h---zc

    sts  0x0114,r7      ; (ldi) 0x28
    sts  0x0115,r24     ; (ldi) 0xd8
    sts  0x0116,r1      ; (cp)  0x28 0xd8 (cf=1) -----c
    sts  0x0117,r22     ; (cpc) 0x28 0xd8 (cf=1) h----c

    sts  0x0118,r8      ; (ldi) 0x70
    sts  0x0119,r16     ; (ldi) 0xc0
    sts  0x011a,r0      ; (cp)  0x70 0xc0 (cf=1) --vn-c
    sts  0x011b,r23     ; (cpc) 0x70 0xc0 (cf=1) h-vn-c
;-------------------
    sts  0x0120,r17     ; (ldi) 0x80
    sts  0x0121,r9      ; (ldi) 0x7f
    sts  0x0122,r10     ; (cp)  0x80 0x7f (cf=1 zf=1) hsv---
    sts  0x0123,r26     ; (cpc) 0x80 0x7f (cf=1 zf=1) hsv-z-

    sts  0x0124,r16     ; (ldi) 0xc0
    sts  0x0125,r8      ; (ldi) 0x70
    sts  0x0126,r11     ; (cp)  0xc0 0x70 (cf=0) -sv---
    sts  0x0127,r27     ; (cpc) 0xc0 0x70 (cf=0) -sv---

    sts  0x0128,r24     ; (ldi) 0xd8
    sts  0x0129,r7      ; (ldi) 0x28
    sts  0x012a,r12     ; (cp)  0xd8 0x28 (cf=0) -s-n--
    sts  0x012b,r28     ; (cpc) 0xd8 0x28 (cf=0) -s-n--
;-------------------
    sts  0x0130,r16     ; (ldi) 0xc0
    sts  0x0131,r16     ; (ldi) 0xc0
    sts  0x0132,r13     ; (cp)  0xc0 0xc0 (cf=0 zf=1) ----z-
    sts  0x0133,r29     ; (cpc) 0xc0 0xc0 (cf=0 zf=1) ----z-

    sts  0x0134,r24     ; (ldi) 0xd8
    sts  0x0135,r16     ; (ldi) 0xc0
    sts  0x0136,r14     ; (cp)  0xd8 0xc0 (cf=0) ------
    sts  0x0137,r30     ; (cpc) 0xd8 0xc0 (cf=0) ------

    sts  0x0138,r16     ; (ldi) 0xc0
    sts  0x0139,r24     ; (ldi) 0xd8
    sts  0x013a,r15     ; (cp)  0xc0 0xd8 (cf=0) hs-n-c
    sts  0x013b,r31     ; (cpc) 0xc0 0xd8 (cf=0) hs-n-c
;-------------------
    out  sreg,r25
    cp   r24,r16
    in   r14,sreg

    out  sreg,r25
    cpc  r24,r16
    in   r30,sreg

    sts  0x013c,r24     ; (ldi) 0xd8
    sts  0x013d,r16     ; (ldi) 0xc0
    sts  0x013e,r14     ; (cp)  0xd8 0xc0 (cf=1) it------
    sts  0x013f,r30     ; (cpc) 0xd8 0xc0 (cf=1) it------
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

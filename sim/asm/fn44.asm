;-------------------
; test for cpi
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x28
    ldi  r20,0x70
    ldi  r24,0xc0
    ldi  r31,0xd8

    ldi  r17,0x00
    ldi  r21,0x7f
    ldi  r25,0x80
    ldi  r30,0xff
;-------------------
    cpi  r16,0x28
    in   r5 ,sreg
    cpi  r20,0x28
    in   r4 ,sreg
    cpi  r16,0x70
    in   r3 ,sreg

    sez
    cpi  r17,0xff
    in   r2 ,sreg
    cpi  r16,0xd8
    in   r1 ,sreg
    cpi  r20,0xc0
    in   r0 ,sreg

    sez
    cpi  r25,0x7f
    in   r10,sreg
    cpi  r24,0x70
    in   r11,sreg
    cpi  r31,0x28
    in   r12,sreg

    sez
    cpi  r24,0xc0
    in   r13,sreg
    cpi  r31,0xc0
    in   r14,sreg
    cpi  r24,0xd8
    in   r15,sreg
;-------------------
    sts  0x0100,r16     ; (ldi) 0x28
    sts  0x0101,r16     ; (ldi) 0x28
    sts  0x0102,r5      ; (cpi) 0x28 0x28 (cf=0 zf=0) ----z-

    sts  0x0104,r20     ; (ldi) 0x70
    sts  0x0105,r16     ; (ldi) 0x28
    sts  0x0106,r4      ; (cpi) 0x70 0x28 (cf=0) h-----

    sts  0x0108,r16     ; (ldi) 0x28
    sts  0x0109,r20     ; (ldi) 0x28
    sts  0x010a,r3      ; (cpi) 0x28 0x70 (cf=0) -s-n-c
;-------------------
    sts  0x0110,r17     ; (ldi) 0x00
    sts  0x0111,r30     ; (ldi) 0xff
    sts  0x0112,r2      ; (cpi) 0x00 0xff (cf=1 zf=1) h----c

    sts  0x0114,r16     ; (ldi) 0x28
    sts  0x0115,r31     ; (ldi) 0xd8
    sts  0x0116,r1      ; (cpi) 0x28 0xd8 (cf=1) -----c

    sts  0x0118,r20     ; (ldi) 0x70
    sts  0x0119,r24     ; (ldi) 0xc0
    sts  0x011a,r0      ; (cpi) 0x70 0xc0 (cf=1) --vn-c
;-------------------
    sts  0x0120,r25     ; (ldi) 0x80
    sts  0x0121,r21     ; (ldi) 0x7f
    sts  0x0122,r10     ; (cpi) 0x80 0x7f (cf=1 zf=1) hsv---

    sts  0x0124,r24     ; (ldi) 0xc0
    sts  0x0125,r20     ; (ldi) 0x70
    sts  0x0126,r11     ; (cpi) 0xc0 0x70 (cf=0) -sv---

    sts  0x0128,r31     ; (ldi) 0xd8
    sts  0x0129,r16     ; (ldi) 0x28
    sts  0x012a,r12     ; (cpi) 0xd8 0x28 (cf=0) -s-n--
;-------------------
    sts  0x0130,r24     ; (ldi) 0xc0
    sts  0x0131,r24     ; (ldi) 0xc0
    sts  0x0132,r13     ; (cpi) 0xc0 0xc0 (cf=0 zf=1) ----z-

    sts  0x0134,r31     ; (ldi) 0xd8
    sts  0x0135,r24     ; (ldi) 0xc0
    sts  0x0136,r14     ; (cpi) 0xd8 0xc0 (cf=0) ------

    sts  0x0138,r24     ; (ldi) 0xc0
    sts  0x0139,r31     ; (ldi) 0xd8
    sts  0x013a,r15     ; (cpi) 0xc0 0xd8 (cf=0) hs-n-c
;-------------------
    out  sreg,r30
    cpi  r31,0xc0
    in   r14,sreg

    sts  0x013c,r31     ; (ldi) 0xd8
    sts  0x013d,r24     ; (ldi) 0xc0
    sts  0x013e,r14     ; (cpi) 0xd8 0xc0 (cf=1) it------
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

;-------------------
; test for add/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x00
    ldi  r24,0x40
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x80
    ldi  r24,0xc0

    ldi  r17,0x28
    ldi  r25,0x5f
    mov  r6 ,r17
    mov  r9 ,r25
    ldi  r17,0xa8
    ldi  r25,0xdf
;-------------------
    mov  r5 ,r7
    add  r5 ,r7
    in   r5 ,sreg
    mov  r4 ,r8
    add  r4 ,r6
    in   r4 ,sreg
    mov  r3 ,r8
    add  r3 ,r9
    in   r3 ,sreg

    mov  r2 ,r8
    add  r2 ,r24
    in   r2 ,sreg
    mov  r1 ,r8
    add  r1 ,r25
    in   r1 ,sreg
    mov  r0 ,r8
    add  r0 ,r17
    in   r0 ,sreg

    mov  r10,r24
    add  r10,r8
    in   r10,sreg
    mov  r11,r25
    add  r11,r9
    in   r11,sreg
    mov  r12,r17
    add  r12,r6
    in   r12,sreg

    mov  r13,r16
    add  r13,r16
    in   r13,sreg
    mov  r14,r17
    add  r14,r24
    in   r14,sreg
    mov  r15,r25
    add  r15,r24
    in   r15,sreg
;-------------------
    clc
    mov  r18,r7
    adc  r18,r7
    in   r18,sreg
    mov  r19,r8
    adc  r19,r6
    in   r19,sreg
    mov  r20,r8
    adc  r20,r9
    in   r20,sreg

    mov  r21,r8
    adc  r21,r24
    in   r21,sreg
    mov  r22,r8
    adc  r22,r25
    in   r22,sreg
    mov  r23,r8
    adc  r23,r17
    in   r23,sreg

    mov  r26,r24
    adc  r26,r8
    in   r26,sreg
    mov  r27,r25
    adc  r27,r9
    in   r27,sreg
    mov  r28,r17
    adc  r28,r6
    in   r28,sreg

    mov  r29,r16
    adc  r29,r16
    in   r29,sreg
    mov  r30,r17
    adc  r30,r24
    in   r30,sreg
    mov  r31,r25
    adc  r31,r24
    in   r31,sreg
;-------------------
    sts  0x0100,r7      ; (ldi) 0x00
    sts  0x0101,r7      ; (ldi) 0x00
    sts  0x0102,r5      ; (add) 0x00 0x00 (cf=0) ----z-
    sts  0x0103,r18     ; (adc) 0x00 0x00 (cf=0) ----z-

    sts  0x0104,r8      ; (ldi) 0x40
    sts  0x0105,r6      ; (ldi) 0x28
    sts  0x0106,r4      ; (add) 0x40 0x28 (cf=0) ------
    sts  0x0107,r19     ; (adc) 0x40 0x28 (cf=0) ------

    sts  0x0108,r8      ; (ldi) 0x40
    sts  0x0109,r9      ; (ldi) 0x5f
    sts  0x010a,r3      ; (add) 0x40 0x5f (cf=0) --vn--
    sts  0x010b,r20     ; (adc) 0x40 0x5f (cf=0) --vn--
;-------------------
    sts  0x0110,r8      ; (ldi) 0x40
    sts  0x0111,r24     ; (ldi) 0xc0
    sts  0x0112,r2      ; (add) 0x40 0xc0 (cf=0) ----zc
    sts  0x0113,r21     ; (adc) 0x40 0xc0 (cf=0) ----zc

    sts  0x0114,r8      ; (ldi) 0x40
    sts  0x0115,r25     ; (ldi) 0xdf
    sts  0x0116,r1      ; (add) 0x40 0xdf (cf=1) -----c
    sts  0x0117,r22     ; (adc) 0x40 0xdf (cf=1) h----c

    sts  0x0118,r8      ; (ldi) 0x40
    sts  0x0119,r17     ; (ldi) 0xa8
    sts  0x011a,r0      ; (add) 0x40 0xa8 (cf=1) -s-n--
    sts  0x011b,r23     ; (adc) 0x40 0xa8 (cf=1) -s-n--
;-------------------
    sts  0x0120,r24     ; (ldi) 0xc0
    sts  0x0121,r8      ; (ldi) 0x40
    sts  0x0122,r10     ; (add) 0xc0 0x40 (cf=0) ----zc
    sts  0x0123,r26     ; (adc) 0xc0 0x40 (cf=0) ----zc

    sts  0x0124,r25     ; (ldi) 0xdf
    sts  0x0125,r9      ; (ldi) 0x5f
    sts  0x0126,r11     ; (add) 0xdf 0x5f (cf=1) h----c
    sts  0x0127,r27     ; (adc) 0xdf 0x5f (cf=1) h----c

    sts  0x0128,r17     ; (ldi) 0xa8
    sts  0x0129,r6      ; (ldi) 0x28
    sts  0x012a,r12     ; (add) 0xa8 0x28 (cf=1) hs-n--
    sts  0x012b,r28     ; (adc) 0xa8 0x28 (cf=1) hs-n--
;-------------------
    sts  0x0130,r16     ; (ldi) 0x80
    sts  0x0131,r16     ; (ldi) 0x80
    sts  0x0132,r13     ; (add) 0x80 0x80 (cf=0) -sv-zc
    sts  0x0133,r29     ; (adc) 0x80 0x80 (cf=0) -sv-zc

    sts  0x0134,r17     ; (ldi) 0xa8
    sts  0x0135,r24     ; (ldi) 0xc0
    sts  0x0136,r14     ; (add) 0xa8 0xc0 (cf=1) -sv--c
    sts  0x0137,r30     ; (adc) 0xa8 0xc0 (cf=1) -sv--c

    sts  0x0138,r25     ; (ldi) 0xdf
    sts  0x0139,r24     ; (ldi) 0xc0
    sts  0x013a,r15     ; (add) 0xdf 0xc0 (cf=1) -s-n-c
    sts  0x013b,r31     ; (adc) 0xdf 0xc0 (cf=1) hs-n-c
;-------------------
    ldi  r16,0xff

    out  sreg,r16
    mov  r4 ,r8
    add  r4 ,r6
    in   r4 ,sreg

    out  sreg,r16
    mov  r19,r8
    adc  r19,r6
    in   r19,sreg

    sts  0x010c,r8      ; (ldi) 0x40
    sts  0x010d,r6      ; (ldi) 0x28
    sts  0x010e,r4      ; (add) 0x40 0x28 (cf=1) it------
    sts  0x010f,r19     ; (adc) 0x40 0x28 (cf=1) it------

    sts  0xffff,r16
halt:
    rjmp halt

;---------------------------
; test for add/adc/sub/sbc
;---------------------------
    ldi  r16,0xb0
    ldi  r24,0xa0
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x90
    ldi  r24,0x80

    ldi  r17,0x40
    ldi  r25,0x50
    mov  r6 ,r17
    mov  r9 ,r25
    ldi  r17,0x60
    ldi  r25,0x70
;-------------------
    mov  r5 ,r7
    mov  r10,r8
    mov  r18,r16
    mov  r26,r24

    add  r5 ,r25
    adc  r10,r17
    adc  r18,r9
    adc  r26,r6

    mov  r4 ,r7
    mov  r11,r8
    mov  r19,r16
    mov  r27,r24

    adc  r4 ,r25
    add  r11,r17
    add  r19,r9
    add  r27,r6
;-------------------
    ldi  r20,0x30
    ldi  r28,0x10
    mov  r3 ,r20
    mov  r12,r28
    ldi  r20,0xf0
    ldi  r28,0xd0
;-------------------
    mov  r1 ,r3
    mov  r14,r12
    mov  r22,r20
    mov  r30,r28

    sub  r1 ,r25
    sbc  r14,r17
    sbc  r22,r9
    sbc  r30,r6

    mov  r0 ,r3
    mov  r15,r12
    mov  r23,r20
    mov  r31,r28

    sbc  r0 ,r25
    sub  r15,r17
    sub  r23,r9
    sub  r31,r6
;-------------------
    mov  r2 ,r25
    mov  r13,r17
    mov  r21,r9
    mov  r29,r6

    mov  r6 ,r2
    mov  r9 ,r13
    mov  r17,r21
    mov  r25,r29
;-------------------
    sts  0x0100,r7      ; (ldi) 0xb0
    sts  0x0101,r6      ; (ldi) 0x70
    sts  0x0102,r5      ; (add) 0xb0 0x70 (cf=0)
    sts  0x0103,r4      ; (adc) 0xb0 0x70 (cf=0)

    sts  0x0104,r3      ; (ldi) 0x30
    sts  0x0105,r2      ; (ldi) 0x70
    sts  0x0106,r1      ; (sub) 0x30 0x70 (cf=0)
    sts  0x0107,r0      ; (sbc) 0x30 0x70 (cf=0)

    sts  0x0108,r8      ; (ldi) 0xa0
    sts  0x0109,r9      ; (ldi) 0x60
    sts  0x010a,r10     ; (adc) 0xa0 0x60 (cf=1)
    sts  0x010b,r11     ; (add) 0xa0 0x60 (cf=1)

    sts  0x010c,r12     ; (ldi) 0x10
    sts  0x010d,r13     ; (ldi) 0x60
    sts  0x010e,r14     ; (sbc) 0x10 0x60 (cf=1)
    sts  0x010f,r15     ; (sub) 0x10 0x60 (cf=1)

    sts  0x0110,r16     ; (ldi) 0x90
    sts  0x0111,r17     ; (ldi) 0x50
    sts  0x0112,r18     ; (adc) 0x90 0x50 (cf=1)
    sts  0x0113,r19     ; (add) 0x90 0x50 (cf=1)

    sts  0x0114,r20     ; (ldi) 0xf0
    sts  0x0115,r21     ; (ldi) 0x50
    sts  0x0116,r22     ; (sbc) 0xf0 0x50 (cf=1)
    sts  0x0117,r23     ; (sub) 0xf0 0x50 (cf=1)

    sts  0x0118,r24     ; (ldi) 0x80
    sts  0x0119,r25     ; (ldi) 0x40
    sts  0x011a,r26     ; (adc) 0x80 0x40 (cf=0)
    sts  0x011b,r27     ; (add) 0x80 0x40 (cf=0)

    sts  0x011c,r28     ; (ldi) 0xd0
    sts  0x011d,r29     ; (ldi) 0x40
    sts  0x011e,r30     ; (sbc) 0xd0 0x40 (cf=0)
    sts  0x011f,r31     ; (sub) 0xd0 0x40 (cf=0)
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

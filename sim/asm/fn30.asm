;---------------------------
; test for asr/lsr/ror/swap
;---------------------------
    ldi  r16,0xc3
    ldi  r24,0x43
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0xc2
    ldi  r24,0x42

    mov  r6 ,r7
    mov  r9 ,r8
    mov  r17,r16
    mov  r25,r24

    asr  r6
    asr  r9
    asr  r17
    asr  r25
;-------------------
    mov  r5 ,r7
    mov  r10,r8
    mov  r18,r16
    mov  r26,r24

    lsr  r5
    lsr  r10
    lsr  r18
    lsr  r26
;-------------------
    mov  r4 ,r7
    mov  r11,r8
    mov  r19,r16
    mov  r27,r24

    ror  r4
    ror  r11
    ror  r19
    ror  r27
;-------------------
    mov  r3 ,r7
    mov  r2 ,r24
    mov  r1 ,r16
    mov  r0 ,r24

    asr  r3
    ror  r2
    asr  r1
    ror  r0
;-------------------
    mov  r12,r7
    mov  r13,r24
    mov  r14,r16
    mov  r15,r24

    lsr  r12
    ror  r13
    lsr  r14
    ror  r15
;-------------------
    ldi  r20,0x42
    ldi  r21,0x7e
    ldi  r22,0x81
    ldi  r23,0xbd

    mov  r7 ,r20
    mov  r8 ,r21
    mov  r16,r22
    mov  r24,r23

    swap r7
    swap r8
    swap r16
    swap r24

    mov  r28,r7
    mov  r29,r8
    mov  r30,r16
    mov  r31,r24
;-------------------
    ldi  r16,0xc3
    ldi  r24,0x43
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0xc2
    ldi  r24,0x42
;-------------------
    sts  0x0100,r7      ; (ldi) 0xc3
    sts  0x0101,r6      ; (asr) 0xc3 (cf=0)
    sts  0x0102,r5      ; (lsr) 0xc3 (cf=0)
    sts  0x0103,r4      ; (ror) 0xc3 (cf=0)

    sts  0x0104,r8      ; (ldi) 0x43
    sts  0x0105,r9      ; (asr) 0x43 (cf=1)
    sts  0x0106,r10     ; (lsr) 0x43 (cf=1)
    sts  0x0107,r11     ; (ror) 0x43 (cf=1)

    sts  0x0108,r16     ; (ldi) 0xc2
    sts  0x0109,r17     ; (asr) 0xc2 (cf=1)
    sts  0x010a,r18     ; (lsr) 0xc2 (cf=1)
    sts  0x010b,r19     ; (ror) 0xc2 (cf=1)

    sts  0x010c,r24     ; (ldi) 0x42
    sts  0x010d,r25     ; (asr) 0x42 (cf=0)
    sts  0x010e,r26     ; (lsr) 0x42 (cf=0)
    sts  0x010f,r27     ; (ror) 0x42 (cf=0)

    sts  0x0110,r3      ; (asr) 0xc3 (cf=0)
    sts  0x0111,r2      ; (ror) 0x42 (cf=1)
    sts  0x0112,r1      ; (asr) 0xc2 (cf=0)
    sts  0x0113,r0      ; (ror) 0x42 (cf=0)

    sts  0x0114,r12     ; (lsr) 0xc3 (cf=0)
    sts  0x0115,r13     ; (ror) 0x42 (cf=1)
    sts  0x0116,r14     ; (lsr) 0xc2 (cf=0)
    sts  0x0117,r15     ; (ror) 0x42 (cf=0)

    sts  0x0118,r20     ; (ldi) 0x42
    sts  0x0119,r21     ; (ldi) 0x7e
    sts  0x011a,r22     ; (ldi) 0x81
    sts  0x011b,r23     ; (ldi) 0xbd

    sts  0x011c,r28     ; (swap) 0x42
    sts  0x011d,r29     ; (swap) 0x7e
    sts  0x011e,r30     ; (swap) 0x81
    sts  0x011f,r31     ; (swap) 0xbd
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

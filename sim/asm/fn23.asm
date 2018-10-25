;-------------------------------
; test for and/andi/or/ori/eor
;-------------------------------
    ldi  r16,0x33
    ldi  r24,0x66
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x99
    ldi  r24,0xcc

    ldi  r17,0x55
    ldi  r25,0x5a
    mov  r6 ,r17
    mov  r9 ,r25
    ldi  r17,0xa5
    ldi  r25,0xaa
;-------------------
    mov  r5 ,r7
    mov  r10,r8
    mov  r18,r16
    mov  r26,r24

    and  r5 ,r25
    and  r10,r17
    and  r18,r9
    and  r26,r6
;-------------------
    mov  r4 ,r7
    mov  r11,r8
    mov  r19,r16
    mov  r27,r24

    or   r4 ,r25
    or   r11,r17
    or   r19,r9
    or   r27,r6
;-------------------
    mov  r3 ,r7
    mov  r12,r8
    mov  r20,r16
    mov  r28,r24

    eor  r3 ,r25
    eor  r12,r17
    eor  r20,r9
    eor  r28,r6
;-------------------
    ldi  r17,0x33
    ldi  r25,0x33
    ldi  r30,0x66
    ldi  r31,0x66

    andi r17,0xaa
    ori  r25,0xaa
    andi r31,0xa5
    ori  r30,0xa5

    mov  r1 ,r17
    mov  r0 ,r25
    mov  r14,r31
    mov  r15,r30
;-------------------
    ldi  r22,0x99
    ldi  r23,0x99
    ldi  r30,0xcc
    ldi  r31,0xcc

    andi r22,0x5a
    ori  r23,0x5a
    andi r30,0x55
    ori  r31,0x55
;-------------------
    ldi  r17,0xaa
    ldi  r25,0xa5
    mov  r6 ,r17
    mov  r9 ,r25
    ldi  r17,0x5a
    ldi  r25,0x55
;-------------------
    sts  0x0100,r7      ; (ldi) 0x33
    sts  0x0101,r6      ; (ldi) 0xaa
    sts  0x0102,r5      ; (and) 0x33,0xaa
    sts  0x0103,r4      ; (or)  0x33,0xaa
    sts  0x0104,r3      ; (eor) 0x33,0xaa
   ;sts  0x0105,r2
    sts  0x0106,r1      ; (andi) 0x33,0xaa
    sts  0x0107,r0      ; (ori)  0x33,0xaa

    sts  0x0108,r8      ; (ldi) 0x66
    sts  0x0109,r9      ; (ldi) 0xa5
    sts  0x010a,r10     ; (and) 0x66,0xa5
    sts  0x010b,r11     ; (or)  0x66,0xa5
    sts  0x010c,r12     ; (eor) 0x66,0xa5
   ;sts  0x010d,r13
    sts  0x010e,r14     ; (andi) 0x66,0xa5
    sts  0x010f,r15     ; (ori)  0x66,0xa5

    sts  0x0110,r16     ; (ldi) 0x99
    sts  0x0111,r17     ; (ldi) 0x5a
    sts  0x0112,r18     ; (and) 0x99,0x5a
    sts  0x0113,r19     ; (or)  0x99,0x5a
    sts  0x0114,r20     ; (eor) 0x99,0x5a
   ;sts  0x0115,r21
    sts  0x0116,r22     ; (andi) 0x99,0x5a
    sts  0x0117,r23     ; (ori)  0x99,0x5a

    sts  0x0118,r24     ; (ldi) 0xcc
    sts  0x0119,r25     ; (ldi) 0x55
    sts  0x011a,r26     ; (and) 0xcc,0x55
    sts  0x011b,r27     ; (or)  0xcc,0x55
    sts  0x011c,r28     ; (eor) 0xcc,0x55
   ;sts  0x011d,r29
    sts  0x011e,r30     ; (andi) 0xcc,0x55
    sts  0x011f,r31     ; (ori)  0xcc,0x55
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

;-------------------
; test for sbrs
;-------------------
    ldi  r28,0xff
    ldi  r29,0xff

    movw r2 ,r28
    movw r4 ,r28
    movw r10,r28
    movw r12,r28
    movw r18,r28
    movw r20,r28
    movw r26,r28

    ldi  r16,0x01
    ldi  r17,0x02
    ldi  r24,0x04
    ldi  r25,0x08
    mov  r7 ,r16
    mov  r6 ,r17
    mov  r8 ,r24
    mov  r9 ,r25
    ldi  r16,0x10
    ldi  r17,0x20
    ldi  r24,0x40
    ldi  r25,0x80
;-------------------
    sbrs r7 ,0
    mov  r5 ,r7
    sbrs r7 ,1
    mov  r4 ,r7

    sbrs r6 ,1
    mov  r3 ,r6
    sbrs r6 ,0
    mov  r2 ,r6

    sbrs r8 ,2
    mov  r10,r8
    sbrs r8 ,3
    mov  r11,r8

    sbrs r9 ,3
    mov  r12,r9
    sbrs r9 ,2
    mov  r13,r9

    sbrs r16,4
    mov  r18,r16
    sbrs r16,5
    mov  r19,r16

    sbrs r17,5
    mov  r20,r17
    sbrs r17,4
    mov  r21,r17

    sbrs r24,6
    mov  r26,r24
    sbrs r24,7
    mov  r27,r24

    sbrs r25,7
    mov  r28,r25
    sbrs r25,6
    mov  r29,r25
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r5      ; (sbrs) 0x01 b0
    st   z+,r4      ; (sbrs) 0x01 b1
    st   z+,r3      ; (sbrs) 0x02 b1
    st   z+,r2      ; (sbrs) 0x02 b0

    st   z+,r10     ; (sbrs) 0x04 b2
    st   z+,r11     ; (sbrs) 0x04 b3
    st   z+,r12     ; (sbrs) 0x08 b3
    st   z+,r13     ; (sbrs) 0x08 b2

    st   z+,r18     ; (sbrs) 0x10 b4
    st   z+,r19     ; (sbrs) 0x10 b5
    st   z+,r20     ; (sbrs) 0x20 b5
    st   z+,r21     ; (sbrs) 0x20 b4

    st   z+,r26     ; (sbrs) 0x40 b6
    st   z+,r27     ; (sbrs) 0x40 b7
    st   z+,r28     ; (sbrs) 0x80 b7
    st   z+,r29     ; (sbrs) 0x80 b6
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

;-------------------
; test for sbis
;-------------------
    .equ ioreg0 = 0x00  ; i/o register dummy
    .equ ioreg1 = 0x01  ; i/o register dummy
    .equ ioreg2 = 0x02  ; i/o register dummy
    .equ ioreg3 = 0x1f  ; i/o register dummy
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

    ldi  r16,0x11
    ldi  r17,0x22
    ldi  r24,0x44
    ldi  r25,0x88

    out  ioreg0,r16
    out  ioreg1,r17
    out  ioreg2,r24
    out  ioreg3,r25
;-------------------
    sbis ioreg0,0
    in   r5 ,ioreg0
    sbis ioreg0,1
    in   r4 ,ioreg0

    sbis ioreg1,1
    in   r3 ,ioreg1
    sbis ioreg1,0
    in   r2 ,ioreg1

    sbis ioreg2,2
    in   r10,ioreg2
    sbis ioreg2,3
    in   r11,ioreg2

    sbis ioreg3,3
    in   r12,ioreg3
    sbis ioreg3,2
    in   r13,ioreg3

    sbis ioreg0,4
    in   r18,ioreg0
    sbis ioreg0,5
    in   r19,ioreg0

    sbis ioreg1,5
    in   r20,ioreg1
    sbis ioreg1,4
    in   r21,ioreg1

    sbis ioreg2,6
    in   r26,ioreg2
    sbis ioreg2,7
    in   r27,ioreg2

    sbis ioreg3,7
    in   r28,ioreg3
    sbis ioreg3,6
    in   r29,ioreg3
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r5      ; (sbis) 0x11 b0
    st   z+,r4      ; (sbis) 0x11 b1
    st   z+,r3      ; (sbis) 0x22 b1
    st   z+,r2      ; (sbis) 0x22 b0

    st   z+,r10     ; (sbis) 0x44 b2
    st   z+,r11     ; (sbis) 0x44 b3
    st   z+,r12     ; (sbis) 0x88 b3
    st   z+,r13     ; (sbis) 0x88 b2

    st   z+,r18     ; (sbis) 0x11 b4
    st   z+,r19     ; (sbis) 0x11 b5
    st   z+,r20     ; (sbis) 0x22 b5
    st   z+,r21     ; (sbis) 0x22 b4

    st   z+,r26     ; (sbis) 0x44 b6
    st   z+,r27     ; (sbis) 0x44 b7
    st   z+,r28     ; (sbis) 0x88 b7
    st   z+,r29     ; (sbis) 0x88 b6
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

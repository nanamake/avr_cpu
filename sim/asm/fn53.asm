;-------------------
; test for sbic
;-------------------
    .equ ioreg0 = 0x00  ; i/o register dummy
    .equ ioreg1 = 0x01  ; i/o register dummy
    .equ ioreg2 = 0x02  ; i/o register dummy
    .equ ioreg3 = 0x1f  ; i/o register dummy
;-------------------
    ldi  r28,0x00
    ldi  r29,0x00

    movw r2 ,r28
    movw r4 ,r28
    movw r10,r28
    movw r12,r28
    movw r18,r28
    movw r20,r28
    movw r26,r28

    ldi  r16,0xee
    ldi  r17,0xdd
    ldi  r24,0xbb
    ldi  r25,0x77

    out  ioreg0,r16
    out  ioreg1,r17
    out  ioreg2,r24
    out  ioreg3,r25
;-------------------
    sbic ioreg0,0
    in   r5 ,ioreg0
    sbic ioreg0,1
    in   r4 ,ioreg0

    sbic ioreg1,1
    in   r3 ,ioreg1
    sbic ioreg1,0
    in   r2 ,ioreg1

    sbic ioreg2,2
    in   r10,ioreg2
    sbic ioreg2,3
    in   r11,ioreg2

    sbic ioreg3,3
    in   r12,ioreg3
    sbic ioreg3,2
    in   r13,ioreg3

    sbic ioreg0,4
    in   r18,ioreg0
    sbic ioreg0,5
    in   r19,ioreg0

    sbic ioreg1,5
    in   r20,ioreg1
    sbic ioreg1,4
    in   r21,ioreg1

    sbic ioreg2,6
    in   r26,ioreg2
    sbic ioreg2,7
    in   r27,ioreg2

    sbic ioreg3,7
    in   r28,ioreg3
    sbic ioreg3,6
    in   r29,ioreg3
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r5      ; (sbic) 0xee b0
    st   z+,r4      ; (sbic) 0xee b1
    st   z+,r3      ; (sbic) 0xdd b1
    st   z+,r2      ; (sbic) 0xdd b0

    st   z+,r10     ; (sbic) 0xbb b2
    st   z+,r11     ; (sbic) 0xbb b3
    st   z+,r12     ; (sbic) 0x77 b3
    st   z+,r13     ; (sbic) 0x77 b2

    st   z+,r18     ; (sbic) 0xee b4
    st   z+,r19     ; (sbic) 0xee b5
    st   z+,r20     ; (sbic) 0xdd b5
    st   z+,r21     ; (sbic) 0xdd b4

    st   z+,r26     ; (sbic) 0xbb b6
    st   z+,r27     ; (sbic) 0xbb b7
    st   z+,r28     ; (sbic) 0x77 b7
    st   z+,r29     ; (sbic) 0x77 b6
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

;-------------------
; test for sbrc
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

    ldi  r16,0xfe
    ldi  r17,0xfd
    ldi  r24,0xfb
    ldi  r25,0xf7
    mov  r7 ,r16
    mov  r6 ,r17
    mov  r8 ,r24
    mov  r9 ,r25
    ldi  r16,0xef
    ldi  r17,0xdf
    ldi  r24,0xbf
    ldi  r25,0x7f
;-------------------
    sbrc r7 ,0
    mov  r5 ,r7
    sbrc r7 ,1
    mov  r4 ,r7

    sbrc r6 ,1
    mov  r3 ,r6
    sbrc r6 ,0
    mov  r2 ,r6

    sbrc r8 ,2
    mov  r10,r8
    sbrc r8 ,3
    mov  r11,r8

    sbrc r9 ,3
    mov  r12,r9
    sbrc r9 ,2
    mov  r13,r9

    sbrc r16,4
    mov  r18,r16
    sbrc r16,5
    mov  r19,r16

    sbrc r17,5
    mov  r20,r17
    sbrc r17,4
    mov  r21,r17

    sbrc r24,6
    mov  r26,r24
    sbrc r24,7
    mov  r27,r24

    sbrc r25,7
    mov  r28,r25
    sbrc r25,6
    mov  r29,r25
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r5      ; (sbrc) 0xfe b0
    st   z+,r4      ; (sbrc) 0xfe b1
    st   z+,r3      ; (sbrc) 0xfd b1
    st   z+,r2      ; (sbrc) 0xfd b0

    st   z+,r10     ; (sbrc) 0xfb b2
    st   z+,r11     ; (sbrc) 0xfb b3
    st   z+,r12     ; (sbrc) 0xf7 b3
    st   z+,r13     ; (sbrc) 0xf7 b2

    st   z+,r18     ; (sbrc) 0xef b4
    st   z+,r19     ; (sbrc) 0xef b5
    st   z+,r20     ; (sbrc) 0xdf b5
    st   z+,r21     ; (sbrc) 0xdf b4

    st   z+,r26     ; (sbrc) 0xbf b6
    st   z+,r27     ; (sbrc) 0xbf b7
    st   z+,r28     ; (sbrc) 0x7f b7
    st   z+,r29     ; (sbrc) 0x7f b6
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

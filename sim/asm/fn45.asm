;-------------------
; test for cpse
;-------------------
    .equ sreg = 0x3f
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

    ldi  r16,0xff
    out  sreg,r16

    ldi  r16,0x20
    ldi  r24,0x50
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0xc0
    ldi  r24,0xd0

    mov  r6 ,r24
    mov  r9 ,r16
    mov  r17,r8
    mov  r25,r7
;-------------------
    cpse r7 ,r6
    in   r5 ,sreg
    cpse r7 ,r9
    in   r4 ,sreg
    cpse r7 ,r17
    in   r3 ,sreg
    cpse r7 ,r25
    in   r2 ,sreg

    cpse r8 ,r6
    in   r10,sreg
    cpse r8 ,r9
    in   r11,sreg
    cpse r8 ,r17
    in   r12,sreg
    cpse r8 ,r25
    in   r13,sreg

    cpse r16,r6
    in   r18,sreg
    cpse r16,r9
    in   r19,sreg
    cpse r16,r17
    in   r20,sreg
    cpse r16,r25
    in   r21,sreg

    cpse r24,r6
    in   r26,sreg
    cpse r24,r9
    in   r27,sreg
    cpse r24,r17
    in   r28,sreg
    cpse r24,r25
    in   r29,sreg
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r5      ; (cpse) 0x20 0xd0
    st   z+,r4      ; (cpse) 0x20 0xc0
    st   z+,r3      ; (cpse) 0x20 0x50
    st   z+,r2      ; (cpse) 0x20 0x20

    st   z+,r10     ; (cpse) 0x50 0xd0
    st   z+,r11     ; (cpse) 0x50 0xc0
    st   z+,r12     ; (cpse) 0x50 0x50
    st   z+,r13     ; (cpse) 0x50 0x20

    st   z+,r18     ; (cpse) 0xc0 0xd0
    st   z+,r19     ; (cpse) 0xc0 0xc0
    st   z+,r20     ; (cpse) 0xc0 0x50
    st   z+,r21     ; (cpse) 0xc0 0x20

    st   z+,r26     ; (cpse) 0xd0 0xd0
    st   z+,r27     ; (cpse) 0xd0 0xc0
    st   z+,r28     ; (cpse) 0xd0 0x50
    st   z+,r29     ; (cpse) 0xd0 0x20
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

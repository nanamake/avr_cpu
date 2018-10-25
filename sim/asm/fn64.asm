;-------------------
; test for and/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x00
    ldi  r17,0x01
    ldi  r18,0x80
    ldi  r19,0xff
;-------------------
    out  sreg,r19
    mov  r2 ,r17
    and  r2 ,r17
    in   r3 ,sreg

    out  sreg,r16
    mov  r4 ,r17
    and  r4 ,r16
    in   r5 ,sreg

    mov  r6 ,r18
    and  r6 ,r18
    in   r7 ,sreg
;-------------------
    out  sreg,r19
    mov  r8 ,r17
    or   r8 ,r16
    in   r9 ,sreg

    out  sreg,r16
    mov  r10,r16
    or   r10,r16
    in   r11,sreg

    mov  r12,r18
    or   r12,r16
    in   r13,sreg
;-------------------
    out  sreg,r19
    mov  r14,r17
    eor  r14,r16
    in   r15,sreg

    out  sreg,r16
    mov  r20,r17
    eor  r20,r17
    in   r21,sreg

    mov  r22,r18
    eor  r22,r16
    in   r23,sreg
;-------------------
    out  sreg,r19
    mov  r24,r17
    andi r24,0x01
    in   r25,sreg

    out  sreg,r19
    mov  r26,r17
    ori  r26,0x00
    in   r27,sreg
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r17     ; (ldi) 0x01
    st   z+,r17     ; (ldi) 0x01
    st   z+,r2      ; (and) 0x01 0x01
    st   z+,r3      ; (in)  sreg ith----c
    st   z+,r17     ; (ldi) 0x01
    st   z+,r16     ; (ldi) 0x00
    st   z+,r4      ; (and) 0x01 0x00
    st   z+,r5      ; (in)  sreg ------z-
    st   z+,r18     ; (ldi) 0x80
    st   z+,r18     ; (ldi) 0x80
    st   z+,r6      ; (and) 0x80 0x80
    st   z+,r7      ; (in)  sreg ---s-n--

    st   z+,r17     ; (ldi) 0x01
    st   z+,r17     ; (ldi) 0x01
    st   z+,r24     ; (andi)0x01 0x01
    st   z+,r25     ; (in)  sreg ith----c

    st   z+,r17     ; (ldi) 0x01
    st   z+,r16     ; (ldi) 0x00
    st   z+,r8      ; (or)  0x01 0x00
    st   z+,r9      ; (in)  sreg ith----c
    st   z+,r16     ; (ldi) 0x00
    st   z+,r16     ; (ldi) 0x00
    st   z+,r10     ; (or)  0x00 0x00
    st   z+,r11     ; (in)  sreg ------z-
    st   z+,r18     ; (ldi) 0x80
    st   z+,r16     ; (ldi) 0x00
    st   z+,r12     ; (or)  0x80 0x00
    st   z+,r13     ; (in)  sreg ---s-n--

    st   z+,r17     ; (ldi) 0x01
    st   z+,r16     ; (ldi) 0x00
    st   z+,r26     ; (ori) 0x01 0x00
    st   z+,r27     ; (in)  sreg ith----c

    st   z+,r17     ; (ldi) 0x01
    st   z+,r16     ; (ldi) 0x00
    st   z+,r14     ; (eor) 0x01 0x00
    st   z+,r15     ; (in)  sreg ith----c
    st   z+,r17     ; (ldi) 0x01
    st   z+,r17     ; (ldi) 0x01
    st   z+,r20     ; (eor) 0x01 0x01
    st   z+,r21     ; (in)  sreg ------z-
    st   z+,r18     ; (ldi) 0x80
    st   z+,r16     ; (ldi) 0x00
    st   z+,r22     ; (eor) 0x80 0x00
    st   z+,r23     ; (in)  sreg ---s-n--
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

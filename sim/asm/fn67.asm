;-------------------
; test for asr/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r24,0x00
    ldi  r25,0x01
    ldi  r26,0x80
    ldi  r27,0x81

    movw r0 ,r24
    movw r2 ,r26
    movw r8 ,r24
    movw r10,r26
    movw r16,r24
    movw r18,r26
;-------------------
    out  sreg,r24
    asr  r0
    in   r4 ,sreg
    asr  r1
    in   r5 ,sreg
    asr  r2
    in   r6 ,sreg
    asr  r3
    in   r7 ,sreg
;-------------------
    out  sreg,r24
    lsr  r8
    in   r12,sreg
    lsr  r9
    in   r13,sreg
    lsr  r10
    in   r14,sreg
    lsr  r11
    in   r15,sreg
;-------------------
    out  sreg,r24
    ror  r16
    in   r20,sreg
    ror  r17
    in   r21,sreg
    ror  r18
    in   r22,sreg
    ror  r19
    in   r23,sreg
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r24     ; (ldi) 0x00
    st   z+,r0      ; (asr) 0x00 (cf=0)
    st   z+,r8      ; (lsr) 0x00 (cf=0)
    st   z+,r16     ; (ror) 0x00 (cf=0)

    st   z+,r25     ; (ldi) 0x01
    st   z+,r1      ; (asr) 0x01 (cf=0)
    st   z+,r9      ; (lsr) 0x01 (cf=0)
    st   z+,r17     ; (ror) 0x01 (cf=0)

    st   z+,r26     ; (ldi) 0x80
    st   z+,r2      ; (asr) 0x80 (cf=1)
    st   z+,r10     ; (lsr) 0x80 (cf=1)
    st   z+,r18     ; (ror) 0x80 (cf=1)

    st   z+,r27     ; (ldi) 0x81
    st   z+,r3      ; (asr) 0x81 (cf=0)
    st   z+,r11     ; (lsr) 0x81 (cf=0)
    st   z+,r19     ; (ror) 0x81 (cf=0)
;-------------------
    st   z+,r24     ; (ldi) 0x00
    st   z+,r4      ; (asr) 0x00 (cf=0) ---z-
    st   z+,r12     ; (lsr) 0x00 (cf=0) ---z-
    st   z+,r20     ; (ror) 0x00 (cf=0) ---z-

    st   z+,r25     ; (ldi) 0x01
    st   z+,r5      ; (asr) 0x01 (cf=0) sv-zc
    st   z+,r13     ; (lsr) 0x01 (cf=0) sv-zc
    st   z+,r21     ; (ror) 0x01 (cf=0) sv-zc

    st   z+,r26     ; (ldi) 0x80
    st   z+,r6      ; (asr) 0x80 (cf=1) -vn--
    st   z+,r14     ; (lsr) 0x80 (cf=1) -----
    st   z+,r22     ; (ror) 0x80 (cf=1) -vn--

    st   z+,r27     ; (ldi) 0x81
    st   z+,r7      ; (asr) 0x81 (cf=0) s-n-c
    st   z+,r15     ; (lsr) 0x81 (cf=0) sv--c
    st   z+,r23     ; (ror) 0x81 (cf=0) sv--c
;-------------------
    mov  r0 ,r24
    mov  r8 ,r24
    mov  r16,r24
    ldi  r28,0xff

    out  sreg,r28
    asr  r0
    in   r4 ,sreg
    out  sreg,r28
    lsr  r8
    in   r12,sreg
    out  sreg,r28
    ror  r16
    in   r20,sreg

    st   z+,r24     ; (ldi) 0x00
    st   z+,r0      ; (asr) 0x00 (cf=1)
    st   z+,r8      ; (lsr) 0x00 (cf=1)
    st   z+,r16     ; (ror) 0x00 (cf=1)

    ldi  zh,0x01
    ldi  zl,0x30

    st   z+,r24     ; (ldi) 0x00
    st   z+,r4      ; (asr) 0x00 (cf=1) ith---z-
    st   z+,r12     ; (lsr) 0x00 (cf=1) ith---z-
    st   z+,r20     ; (ror) 0x00 (cf=1) ith-vn--
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

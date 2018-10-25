;-------------------
; test for mul/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x00
    ldi  r17,0x90
    ldi  r18,0xf0
    ldi  r19,0xff
;-------------------
    out  sreg,r16
    mul  r17,r17
    in   r2 ,sreg

    out  sreg,r19
    mul  r17,r17
    in   r3 ,sreg

    movw r4 ,r0
;-------------------
    out  sreg,r16
    muls r16,r19
    in   r6 ,sreg

    out  sreg,r19
    muls r16,r19
    in   r7 ,sreg

    movw r8 ,r0
;-------------------
    out  sreg,r16
    mulsu r17,r18
    in   r10,sreg

    out  sreg,r19
    mulsu r17,r18
    in   r11,sreg

    movw r12,r0
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r17     ; (ldi) 0x90
    st   z+,r17     ; (ldi) 0x90
    st   z+,r4      ; (mul) 0x90 0x90
    st   z+,r5
    st   z+,r2      ; (in) sreg --------
    st   z+,r3      ; (in) sreg ithsvn--

    ldi  zh,0x01
    ldi  zl,0x10

    st   z+,r16     ; (ldi) 0x00
    st   z+,r19     ; (ldi) 0xff
    st   z+,r8      ; (muls) 0x00 0xff
    st   z+,r9
    st   z+,r6      ; (in) sreg ------z-
    st   z+,r7      ; (in) sreg ithsvnz-

    ldi  zh,0x01
    ldi  zl,0x20

    st   z+,r17     ; (ldi) 0x90
    st   z+,r18     ; (ldi) 0xf0
    st   z+,r12     ; (mulsu) 0x90 0xf0
    st   z+,r13
    st   z+,r10     ; (in) sreg -------c
    st   z+,r11     ; (in) sreg ithsvn-c
;-------------------
    out  sreg,r16
    fmul r17,r17
    in   r2 ,sreg

    out  sreg,r19
    fmul r17,r17
    in   r3 ,sreg

    movw r4 ,r0
;-------------------
    out  sreg,r16
    fmuls r16,r19
    in   r6 ,sreg

    out  sreg,r19
    fmuls r16,r19
    in   r7 ,sreg

    movw r8 ,r0
;-------------------
    out  sreg,r16
    fmulsu r17,r18
    in   r10,sreg

    out  sreg,r19
    fmulsu r17,r18
    in   r11,sreg

    movw r12,r0
;-------------------
    ldi  zh,0x01
    ldi  zl,0x08

    st   z+,r17     ; (ldi) 0x90
    st   z+,r17     ; (ldi) 0x90
    st   z+,r4      ; (fmul) 0x90 0x90
    st   z+,r5
    st   z+,r2      ; (in) sreg --------
    st   z+,r3      ; (in) sreg ithsvn--

    ldi  zh,0x01
    ldi  zl,0x18

    st   z+,r16     ; (ldi) 0x00
    st   z+,r19     ; (ldi) 0xff
    st   z+,r8      ; (fmuls) 0x00 0xff
    st   z+,r9
    st   z+,r6      ; (in) sreg ------z-
    st   z+,r7      ; (in) sreg ithsvnz-

    ldi  zh,0x01
    ldi  zl,0x28

    st   z+,r17     ; (ldi) 0x90
    st   z+,r18     ; (ldi) 0xf0
    st   z+,r12     ; (fmulsu) 0x90 0xf0
    st   z+,r13
    st   z+,r10     ; (in) sreg -------c
    st   z+,r11     ; (in) sreg ithsvn-c
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

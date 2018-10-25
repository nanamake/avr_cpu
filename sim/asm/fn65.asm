;-------------------
; test for com/sreg
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x00
    ldi  r17,0x01
    ldi  r18,0x7e
    ldi  r19,0x7f
    ldi  r20,0x80
    ldi  r21,0x81
    ldi  r23,0xff
;-------------------
    out  sreg,r16
    mov  r24,r16
    com  r24
    in   r24,sreg
    mov  r25,r19
    com  r25
    in   r25,sreg
    mov  r2 ,r20
    com  r2
    in   r2 ,sreg
    mov  r3 ,r23
    com  r3
    in   r3 ,sreg
;-------------------
    out  sreg,r16
    mov  r4 ,r16
    neg  r4
    in   r4 ,sreg
    mov  r5 ,r19
    neg  r5
    in   r5 ,sreg
    mov  r6 ,r20
    neg  r6
    in   r6 ,sreg
    mov  r7 ,r23
    neg  r7
    in   r7 ,sreg
;-------------------
    out  sreg,r16
    mov  r8 ,r16
    inc  r8
    in   r8 ,sreg
    mov  r9 ,r19
    inc  r9
    in   r9 ,sreg
    mov  r10,r20
    inc  r10
    in   r10,sreg
    mov  r11,r23
    inc  r11
    in   r11,sreg
;-------------------
    out  sreg,r16
    mov  r12,r16
    dec  r12
    in   r12,sreg
    mov  r13,r19
    dec  r13
    in   r13,sreg
    mov  r14,r20
    dec  r14
    in   r14,sreg
    mov  r15,r17
    dec  r15
    in   r15,sreg
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r16     ; (ldi) 0x00
    st   z+,r19     ; (ldi) 0x7f
    st   z+,r20     ; (ldi) 0x80
    st   z+,r23     ; (ldi) 0xff

    st   z+,r16     ; (ldi) 0x00
    st   z+,r19     ; (ldi) 0x7f
    st   z+,r20     ; (ldi) 0x80
    st   z+,r23     ; (ldi) 0xff

    st   z+,r16     ; (ldi) 0x00
    st   z+,r19     ; (ldi) 0x7f
    st   z+,r20     ; (ldi) 0x80
    st   z+,r23     ; (ldi) 0xff

    st   z+,r16     ; (ldi) 0x00
    st   z+,r19     ; (ldi) 0x7f
    st   z+,r20     ; (ldi) 0x80
    st   z+,r17     ; (ldi) 0x01
;-------------------
    st   z+,r23     ; (com) 0x00
    st   z+,r20     ; (com) 0x7f
    st   z+,r19     ; (com) 0x80
    st   z+,r16     ; (com) 0xff

    st   z+,r16     ; (neg) 0x00
    st   z+,r21     ; (neg) 0x7f
    st   z+,r20     ; (neg) 0x80
    st   z+,r17     ; (neg) 0xff

    st   z+,r17     ; (inc) 0x00
    st   z+,r20     ; (inc) 0x7f
    st   z+,r21     ; (inc) 0x80
    st   z+,r16     ; (inc) 0xff

    st   z+,r23     ; (dec) 0x00
    st   z+,r18     ; (dec) 0x7f
    st   z+,r19     ; (dec) 0x80
    st   z+,r16     ; (dec) 0x01
;-------------------
    st   z+,r24     ; (com) 0x00 -s-n-c
    st   z+,r25     ; (com) 0x7f -s-n-c
    st   z+,r2      ; (com) 0x80 -----c
    st   z+,r3      ; (com) 0xff ----zc

    st   z+,r4      ; (neg) 0x00 ----z-
    st   z+,r5      ; (neg) 0x7f hs-n-c
    st   z+,r6      ; (neg) 0x80 --vn-c
    st   z+,r7      ; (neg) 0xff h----c

    st   z+,r8      ; (inc) 0x00 ------
    st   z+,r9      ; (inc) 0x7f --vn--
    st   z+,r10     ; (inc) 0x80 -s-n--
    st   z+,r11     ; (inc) 0xff ----z-

    st   z+,r12     ; (dec) 0x00 -s-n--
    st   z+,r13     ; (dec) 0x7f ------
    st   z+,r14     ; (dec) 0x80 -sv---
    st   z+,r15     ; (dec) 0x01 ----z-
;-------------------
    out  sreg,r23
    mov  r3 ,r23
    com  r3
    in   r3 ,sreg

    out  sreg,r23
    mov  r4 ,r16
    neg  r4
    in   r4 ,sreg

    out  sreg,r23
    mov  r11,r23
    inc  r11
    in   r11,sreg

    out  sreg,r23
    mov  r15,r17
    dec  r15
    in   r15,sreg

    sts  0x0133,r3      ; (com) 0xff ith---zc
    sts  0x0134,r4      ; (neg) 0x00 it----z-
    sts  0x013b,r11     ; (inc) 0xff ith---zc
    sts  0x013f,r15     ; (dec) 0x01 ith---zc
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

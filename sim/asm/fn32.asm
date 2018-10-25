;-------------------
; test for sbi/cbi
;-------------------
    .equ ioreg0 = 0x00  ; i/o register dummy
    .equ ioreg1 = 0x01  ; i/o register dummy
    .equ ioreg2 = 0x02  ; i/o register dummy
    .equ ioreg3 = 0x1f  ; i/o register dummy
;-------------------
    in   r0 ,ioreg0
    in   r1 ,ioreg1
    in   r2 ,ioreg2
    in   r3 ,ioreg3

    sbi  ioreg0,0
    sbi  ioreg1,1
    sbi  ioreg2,2
    sbi  ioreg3,3

    in   r4 ,ioreg0
    in   r5 ,ioreg1
    in   r6 ,ioreg2
    in   r7 ,ioreg3

    sbi  ioreg3,4
    sbi  ioreg2,5
    sbi  ioreg1,6
    sbi  ioreg0,7

    in   r8 ,ioreg0
    in   r9 ,ioreg1
    in   r10,ioreg2
    in   r11,ioreg3
;-------------------
    ldi  r24,0xff
    out  ioreg0,r24
    out  ioreg1,r24
    out  ioreg2,r24
    out  ioreg3,r24

    in   r12,ioreg0
    in   r13,ioreg1
    in   r14,ioreg2
    in   r15,ioreg3

    cbi  ioreg3,0
    cbi  ioreg2,1
    cbi  ioreg1,2
    cbi  ioreg0,3

    in   r16,ioreg0
    in   r17,ioreg1
    in   r18,ioreg2
    in   r19,ioreg3

    cbi  ioreg0,4
    cbi  ioreg1,5
    cbi  ioreg2,6
    cbi  ioreg3,7

    in   r20,ioreg0
    in   r21,ioreg1
    in   r22,ioreg2
    in   r23,ioreg3
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r0      ; (in) ioreg0 (reset=0x00)
    st   z+,r1      ; (in) ioreg1 (reset=0x00)
    st   z+,r2      ; (in) ioreg2 (reset=0x00)
    st   z+,r3      ; (in) ioreg3 (reset=0x00)

    st   z+,r4      ; (sbi) ioreg0 b0
    st   z+,r5      ; (sbi) ioreg1 b1
    st   z+,r6      ; (sbi) ioreg2 b2
    st   z+,r7      ; (sbi) ioreg3 b3

    st   z+,r8      ; (sbi) ioreg0 b7
    st   z+,r9      ; (sbi) ioreg1 b6
    st   z+,r10     ; (sbi) ioreg2 b5
    st   z+,r11     ; (sbi) ioreg3 b4

    ldi  zh,0x01
    ldi  zl,0x10

    st   z+,r12     ; (in) ioreg0 (out=0xff)
    st   z+,r13     ; (in) ioreg1 (out=0xff)
    st   z+,r14     ; (in) ioreg2 (out=0xff)
    st   z+,r15     ; (in) ioreg3 (out=0xff)

    st   z+,r16     ; (cbi) ioreg0 b3
    st   z+,r17     ; (cbi) ioreg1 b2
    st   z+,r18     ; (cbi) ioreg2 b1
    st   z+,r19     ; (cbi) ioreg3 b0

    st   z+,r20     ; (cbi) ioreg0 b4
    st   z+,r21     ; (cbi) ioreg1 b5
    st   z+,r22     ; (cbi) ioreg2 b6
    st   z+,r23     ; (cbi) ioreg3 b7
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

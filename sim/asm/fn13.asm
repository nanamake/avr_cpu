;-------------------
; test for in/out
;-------------------
    .equ ioreg0 = 0x00  ; i/o register dummy
    .equ ioreg1 = 0x01  ; i/o register dummy
    .equ ioreg2 = 0x02  ; i/o register dummy
    .equ ioreg3 = 0x1f  ; i/o register dummy

    .equ ioreg4 = 0x3c  ; i/o register dummy
    .equ spl    = 0x3d  ; stack pointer low byte
    .equ sph    = 0x3e  ; stack pointer high byte
    .equ sreg   = 0x3f  ; status register

    .equ extio0 = 0x9e  ; extended i/o dummy
    .equ extio1 = 0x9f  ; extended i/o dummy
    .equ extio2 = 0xa0  ; extended i/o dummy
    .equ extio3 = 0xa1  ; extended i/o dummy

    .def zl = r30
    .def zh = r31
    ldi  zh ,0x00
;-------------------
    ldi  r16,0x10
    ldi  r24,0x20
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x30
    ldi  r24,0x40

    out  ioreg0,r7
    out  ioreg1,r8
    out  ioreg2,r16
    out  ioreg3,r24

    inc  r7
    inc  r8
    inc  r16
    inc  r24

    out  ioreg4,r7
    out  spl   ,r8
    out  sph   ,r16
    out  sreg  ,r24

    in   r26,sreg

    inc  r7
    inc  r8
    inc  r16
    inc  r24

    sts  extio0,r7
    ldi  zl ,extio1
    st   z+ ,r8
    st   z+ ,r16
    st   z  ,r24
;-------------------
    in   r6 ,ioreg0
    in   r9 ,ioreg1
    in   r17,ioreg2
    in   r25,ioreg3

    in   r5 ,ioreg4
    in   r10,spl
    in   r18,sph
   ;in   r26,sreg

    lds  r4 ,extio0
    ldi  zl ,extio1
    ld   r11,z+
    ld   r19,z+
    ld   r27,z
;-------------------
    com  r24
    com  r16
    com  r8
    com  r7

    sts  extio3,r24
    ldi  zl ,extio2
    st   z  ,r16
    st   -z ,r8
    st   -z ,r7

    inc  r24
    inc  r16
    inc  r8
    inc  r7

    out  sreg  ,r24
    out  sph   ,r16
    out  spl   ,r8
    out  ioreg4,r7

    in   r29,sreg

    inc  r24
    inc  r16
    inc  r8
    inc  r7

    out  ioreg3,r24
    out  ioreg2,r16
    out  ioreg1,r8
    out  ioreg0,r7
;-------------------
    in   r3 ,ioreg0
    in   r12,ioreg1
    in   r20,ioreg2
    in   r28,ioreg3

    in   r2 ,ioreg4
    in   r13,spl
    in   r21,sph
   ;in   r29,sreg

    lds  r23,extio3
    ldi  zl ,extio2
    ld   r22,z
    ld   r14,-z
    ld   r15,-z
;-------------------
    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r6      ; (in) ioreg0
    st   z+,r9      ; (in) ioreg1
    st   z+,r17     ; (in) ioreg2
    st   z+,r25     ; (in) ioreg3

    st   z+,r5      ; (in) ioreg4
    st   z+,r10     ; (in) spl
    st   z+,r18     ; (in) sph
    st   z+,r26     ; (in) sreg

    st   z+,r4      ; (ld) extio0
    st   z+,r11     ; (ld) extio1
    st   z+,r19     ; (ld) extio2
    st   z+,r27     ; (ld) extio3

    ldi  zh,0x01
    ldi  zl,0x10

    st   z+,r3      ; (in) ioreg0
    st   z+,r12     ; (in) ioreg1
    st   z+,r20     ; (in) ioreg2
    st   z+,r28     ; (in) ioreg3

    st   z+,r2      ; (in) ioreg4
    st   z+,r13     ; (in) spl
    st   z+,r21     ; (in) sph
    st   z+,r29     ; (in) sreg

    st   z+,r15     ; (ld) extio0
    st   z+,r14     ; (ld) extio1
    st   z+,r22     ; (ld) extio2
    st   z+,r23     ; (ld) extio3
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

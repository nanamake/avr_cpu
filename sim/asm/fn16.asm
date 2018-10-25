;---------------------------
; test for ld/st i/o space
;---------------------------
    .equ ioreg0 = 0x00  ; i/o register dummy
    .equ ioreg1 = 0x01  ; i/o register dummy
    .equ ioreg2 = 0x02  ; i/o register dummy
    .equ ioreg3 = 0x1f  ; i/o register dummy

    .equ ioreg4 = 0x3c  ; i/o register dummy
    .equ spl    = 0x3d  ; stack pointer low byte
    .equ sph    = 0x3e  ; stack pointer high byte
    .equ sreg   = 0x3f  ; status register

    .def zl = r30
    .def zh = r31
    ldi  zh ,0x00
;-------------------
    ldi  r16,0x01
    ldi  r17,0x02
    ldi  r18,0x04
    ldi  r19,0x08
    ldi  r20,0x10
    ldi  r21,0x20
    ldi  r22,0x40
    ldi  r23,0x80

    ldi  zl ,ioreg0+0x20
    st   z+ ,r16
    st   z+ ,r17
    st   z  ,r18
    sts  ioreg3+0x20,r19

    sts  sreg+0x20,r23
    ldi  zl ,sph+0x20
    st   z  ,r22
    st   -z ,r21
    st   -z ,r20

    in   r0 ,ioreg0
    in   r1 ,ioreg1
    in   r2 ,ioreg2
    in   r3 ,ioreg3
    in   r4 ,ioreg4
    in   r5 ,spl
    in   r6 ,sph
    in   r7 ,sreg
;-------------------
    com  r16
    com  r17
    com  r18
    com  r19
    com  r20
    com  r21
    com  r22
    com  r23

    out  ioreg0,r16
    out  ioreg1,r17
    out  ioreg2,r18
    out  ioreg3,r19
    out  ioreg4,r20
    out  spl   ,r21
    out  sph   ,r22
    out  sreg  ,r23

    ldi  zl ,ioreg0+0x20
    ld   r8 ,z+
    ld   r9 ,z+
    ld   r10,z
    lds  r11,ioreg3+0x20

    lds  r15,sreg+0x20
    ldi  zl ,sph+0x20
    ld   r14,z
    ld   r13,-z
    ld   r12,-z
;-------------------
    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r0      ; (st) ioreg0
    st   z+,r1      ; (st) ioreg1
    st   z+,r2      ; (st) ioreg2
    st   z+,r3      ; (st) ioreg3
    st   z+,r4      ; (st) ioreg4
    st   z+,r5      ; (st) spl
    st   z+,r6      ; (st) sph
    st   z+,r7      ; (st) sreg

    st   z+,r8      ; (ld) ioreg0
    st   z+,r9      ; (ld) ioreg1
    st   z+,r10     ; (ld) ioreg2
    st   z+,r11     ; (ld) ioreg3
    st   z+,r12     ; (ld) ioreg4
    st   z+,r13     ; (ld) spl
    st   z+,r14     ; (ld) sph
    st   z+,r15     ; (ld) sreg
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

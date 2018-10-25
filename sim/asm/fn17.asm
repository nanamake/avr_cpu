;---------------------------
; test for memory mapped rf
;---------------------------
    .equ mmreg4  = 4;
    .equ mmreg5  = 5;
    .equ mmreg6  = 6;
    .equ mmreg7  = 7;
    .equ mmreg24 = 24;
    .equ mmreg25 = 25;
    .equ mmreg26 = 26;
    .equ mmreg27 = 27;

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

    sts  mmreg4,r16
    ldi  zl ,mmreg5
    st   z+ ,r17
    st   z+ ,r18
    st   z  ,r19

    sts  mmreg27,r23
    ldi  zl ,mmreg26
    st   z  ,r22
    st   -z ,r21
    st   -z ,r20
;-------------------
    com  r4
    com  r5
    com  r6
    com  r7
    com  r24
    com  r25
    com  r26
    com  r27

    lds  r8 ,mmreg4
    ldi  zl ,mmreg5
    ld   r9 ,z+
    ld   r10,z+
    ld   r11,z

    lds  r15,mmreg27
    ldi  zl ,mmreg26
    ld   r14,z
    ld   r13,-z
    ld   r12,-z
;-------------------
    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r8      ; (st/ld) mmreg4
    st   z+,r9      ; (st/ld) mmreg5
    st   z+,r10     ; (st/ld) mmreg6
    st   z+,r11     ; (st/ld) mmreg7
    st   z+,r12     ; (st/ld) mmreg24
    st   z+,r13     ; (st/ld) mmreg25
    st   z+,r14     ; (st/ld) mmreg26
    st   z+,r15     ; (st/ld) mmreg27
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

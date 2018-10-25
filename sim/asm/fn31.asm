;-------------------
; test for bset/bclr
;-------------------
    .equ sreg = 0x3f
;-------------------
    in   r7 ,sreg
;-------------------
    sec
    in   r8 ,sreg
    sez
    in   r9 ,sreg
    sen
    in   r10,sreg
    sev
    in   r11,sreg
    ses
    in   r12,sreg
    seh
    in   r13,sreg
    set
    in   r14,sreg
    sei
    in   r15,sreg
;-------------------
    clc
    in   r16,sreg
    clz
    in   r17,sreg
    cln
    in   r18,sreg
    clv
    in   r19,sreg
    cls
    in   r20,sreg
    clh
    in   r21,sreg
    clt
    in   r22,sreg
    cli
    in   r23,sreg
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x0f

    st   z+,r7      ; (in) sreg

    st   z+,r8      ; (sec)
    st   z+,r9      ; (sez)
    st   z+,r10     ; (sen)
    st   z+,r11     ; (sev)
    st   z+,r12     ; (ses)
    st   z+,r13     ; (seh)
    st   z+,r14     ; (set)
    st   z+,r15     ; (sei)

    st   z+,r16     ; (clc)
    st   z+,r17     ; (clz)
    st   z+,r18     ; (cln)
    st   z+,r19     ; (clv)
    st   z+,r20     ; (cls)
    st   z+,r21     ; (clh)
    st   z+,r22     ; (clt)
    st   z+,r23     ; (cli)
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

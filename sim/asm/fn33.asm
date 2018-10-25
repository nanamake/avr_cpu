;-------------------
; test for bld/bst
;-------------------
    .equ sreg = 0x3f
;-------------------
    ldi  r16,0x00
    ldi  r24,0x00
    mov  r7 ,r16
    mov  r8 ,r24

    ldi  r17,0xff
    ldi  r25,0xff
    mov  r6 ,r17
    mov  r9 ,r25

    set

    bld  r7 ,0
    bld  r8 ,1
    bld  r16,2
    bld  r24,3

    clt

    bld  r6 ,7
    bld  r9 ,6
    bld  r17,5
    bld  r25,4
;-------------------
    in   r0 ,sreg

    bst  r7 ,0
    in   r5 ,sreg
    bst  r6 ,7
    in   r4 ,sreg

    bst  r8 ,1
    in   r10,sreg
    bst  r9 ,6
    in   r11,sreg

    bst  r16,2
    in   r18,sreg
    bst  r17,5
    in   r19,sreg

    bst  r24,3
    in   r26,sreg
    bst  r25,4
    in   r27,sreg
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r7      ; (bld) b0 <- 1
    st   z+,r8      ; (bld) b1 <- 1
    st   z+,r16     ; (bld) b2 <- 1
    st   z+,r24     ; (bld) b3 <- 1

    st   z+,r6      ; (bld) b7 <- 0
    st   z+,r9      ; (bld) b6 <- 0
    st   z+,r17     ; (bld) b5 <- 0
    st   z+,r25     ; (bld) b4 <- 0

    st   z+,r0      ; (in) sreg (reset=0x00)

    st   z+,r5      ; (bst) tf <- b0
    st   z+,r4      ; (bst) tf <- b7
    st   z+,r10     ; (bst) tf <- b1
    st   z+,r11     ; (bst) tf <- b6
    st   z+,r18     ; (bst) tf <- b2
    st   z+,r19     ; (bst) tf <- b5
    st   z+,r26     ; (bst) tf <- b3
    st   z+,r27     ; (bst) tf <- b4

;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

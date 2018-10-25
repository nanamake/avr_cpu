;-------------------
; test for push/pop
;-------------------
    .equ spl = 0x3d
    .equ sph = 0x3e
;-------------------
    in   r20,spl
    in   r21,sph

    ldi  r16,0x10
    ldi  r24,0x20
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x30
    ldi  r24,0x40

    push r7
    push r8
    push r16
    push r24

    in   r22,spl
    in   r23,sph

    pop  r6
    pop  r9
    pop  r17
    pop  r25
;-------------------
    mov  r5 ,r7
    mov  r10,r8
    mov  r18,r16
    mov  r26,r24

    com  r5
    com  r10
    com  r18
    com  r26

    push r5
    push r10
    push r18
    push r26

    .def yl = r28
    .def yh = r29
    in   yl ,spl
    in   yh ,sph

    ldd  r4 ,y+1
    ldd  r11,y+2
    adiw yl ,2
    out  spl,yl
    pop  r19
    pop  r27
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r7      ; (ldi) 0x10
    st   z+,r8      ; (ldi) 0x20
    st   z+,r16     ; (ldi) 0x30
    st   z+,r24     ; (ldi) 0x40

    st   z+,r6      ; (pop) 0x40
    st   z+,r9      ; (pop) 0x30
    st   z+,r17     ; (pop) 0x20
    st   z+,r25     ; (pop) 0x10

    st   z+,r5      ; (ldi) ~0x10
    st   z+,r10     ; (ldi) ~0x20
    st   z+,r18     ; (ldi) ~0x30
    st   z+,r26     ; (ldi) ~0x40

    st   z+,r4      ; (ldd) ~0x40
    st   z+,r11     ; (ldd) ~0x30
    st   z+,r19     ; (pop) ~0x20
    st   z+,r27     ; (pop) ~0x10

    st   z+,r20     ; (in) spl (reset value)
    st   z+,r21     ; (in) sph (reset value)
    st   z+,r22     ; (in) spl (after push)
    st   z+,r23     ; (in) sph (after push)
    st   z+,yl      ; (in) spl (after adiw)
    st   z+,yh      ; (in) sph (after adiw)
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

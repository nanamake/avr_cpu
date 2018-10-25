;-------------------
; test for ldd/std
;-------------------
    .def yl = r28
    .def yh = r29
    .def zl = r30
    .def zh = r31
;-------------------
    ldi  r16,0xff
    ldi  r24,0x10
    mov  r7 ,r16
    mov  r8 ,r24
    ldi  r16,0x20
    ldi  r24,0x30
;-------------------
    ldi  yh,0x01
    ldi  yl,0x10

    std  y+0,r7
    std  y+1,r8
    std  y+2,r16
    std  y+3,r24

    ldd  r6 ,y+0
    ldd  r9 ,y+1
    ldd  r17,y+2
    ldd  r25,y+3

    dec  r6
    inc  r9
    inc  r17
    inc  r25
;-------------------
    std  y+60,r6
    std  y+61,r9
    std  y+62,r17
    std  y+63,r25

    ldd  r5 ,y+60
    ldd  r10,y+61
    ldd  r18,y+62
    ldd  r26,y+63

    dec  r5
    inc  r10
    inc  r18
    inc  r26
;-------------------
    ldi  zh,0x00
    ldi  zl,0xff

    std  z+21,r5
    std  z+22,r10
    std  z+23,r18
    std  z+24,r26

    ldd  r4 ,z+21
    ldd  r11,z+22
    ldd  r19,z+23
    ldd  r27,z+24

    dec  r4
    inc  r11
    inc  r19
    inc  r27
;-------------------
    std  z+41,r4
    std  z+42,r11
    std  z+43,r19
    std  z+44,r27

    ldd  r3 ,z+41
    ldd  r12,z+42
    ldd  r20,z+43
    ldd  r28,z+44

    dec  r3
    inc  r12
    inc  r20
    inc  r28
;-------------------
    std  z+60,r3
    std  z+61,r12
    std  z+62,r20
    std  z+63,r28
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

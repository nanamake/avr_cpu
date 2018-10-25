;-------------------
; test for ld/st
;-------------------
    .def xl = r26
    .def xh = r27
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

    ldi  xh,0x01
    ldi  xl,0x00
    st   x ,r7
    ldi  xl,0x01
    st   x ,r8
    ldi  xl,0x02
    st   x ,r16
    ldi  xl,0x03
    st   x ,r24
;-------------------
    ldi  xh,0x01
    ldi  xl,0x00

    ld   r6 ,x+
    ld   r9 ,x+
    ld   r17,x+
    ld   r25,x+

    dec  r6
    inc  r9
    inc  r17
    inc  r25

    st   x+,r6
    st   x+,r9
    st   x+,r17
    st   x+,r25
;-------------------
    ldi  yh,0x01
    ldi  yl,0x04

    ld   r5 ,y+
    ld   r10,y+
    ld   r18,y+
    ld   r24,y+

    dec  r5
    inc  r10
    inc  r18
    inc  r24

    st   y+,r5
    st   y+,r10
    st   y+,r18
    st   y+,r24
;-------------------
    ldi  zh,0x01
    ldi  zl,0x08

    ld   r4 ,z+
    ld   r11,z+
    ld   r19,z+
    ld   r25,z+

    dec  r4
    inc  r11
    inc  r19
    inc  r25

    st   z+,r4
    st   z+,r11
    st   z+,r19
    st   z+,r25
;-------------------
    ldi  xh,0x01
    ldi  xl,0x10

    ld   r24,-x
    ld   r20,-x
    ld   r12,-x
    ld   r3 ,-x

    inc  r24
    inc  r20
    inc  r12
    dec  r3

    ldi  xh,0x01
    ldi  xl,0x20

    st   -x,r24
    st   -x,r20
    st   -x,r12
    st   -x,r3
;-------------------
    ldi  yh,0x01
    ldi  yl,0x20

    ld   r25,-y
    ld   r21,-y
    ld   r13,-y
    ld   r2 ,-y

    inc  r25
    inc  r21
    inc  r13
    dec  r2

    st   -y,r25
    st   -y,r21
    st   -y,r13
    st   -y,r2
;-------------------
    ldi  zh,0x01
    ldi  zl,0x1c

    ld   r24,-z
    ld   r22,-z
    ld   r14,-z
    ld   r1 ,-z

    inc  r24
    inc  r22
    inc  r14
    dec  r1

    st   -z,r24
    st   -z,r22
    st   -z,r14
    st   -z,r1
;-------------------
    ldi  xh ,0x01
    ldi  xl ,0x17
    ld   r25,x
    ldi  xl ,0x16
    ld   r23,x
    ldi  xl ,0x15
    ld   r15,x
    ldi  xl ,0x14
    ld   r0 ,x

    inc  r25
    inc  r23
    inc  r15
    dec  r0

    st   -x,r25
    st   -x,r23
    st   -x,r15
    st   -x,r0
;-------------------
    ldi  zh,0x01
    ldi  zl,0x20

    st   z+,r0
    st   z+,r1
    st   z+,r2
    st   z+,r3
    st   z+,r4
    st   z+,r5
    st   z+,r6
    st   z+,r7
    st   z+,r8
    st   z+,r9
    st   z+,r10
    st   z+,r11
    st   z+,r12
    st   z+,r13
    st   z+,r14
    st   z+,r15
    st   z+,r16
    st   z+,r17
    st   z+,r18
    st   z+,r19
    st   z+,r20
    st   z+,r21
    st   z+,r22
    st   z+,r23
    st   z+,r24
    st   z+,r25
    st   z+,r26
    st   z+,r27
    st   z+,r28
    st   z+,r29
    st   z ,r30
    ldi  zl,0x3f
    st   z ,r31
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

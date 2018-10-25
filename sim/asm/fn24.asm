;---------------------------
; test for com/neg/inc/dec
;---------------------------
    ldi  r20,0x00
    ldi  r21,0x7f
    ldi  r22,0x80
    ldi  r23,0xff
;-------------------
    mov  r7 ,r20
    mov  r8 ,r21
    mov  r16,r22
    mov  r24,r23

    com  r7
    com  r8
    com  r16
    com  r24
;-------------------
    mov  r6 ,r20
    mov  r9 ,r21
    mov  r17,r22
    mov  r25,r23

    neg  r6
    neg  r9
    neg  r17
    neg  r25
;-------------------
    mov  r5 ,r20
    mov  r10,r21
    mov  r18,r22
    mov  r26,r23

    inc  r5
    inc  r10
    inc  r18
    inc  r26
;-------------------
    mov  r4 ,r20
    mov  r11,r21
    mov  r19,r22
    mov  r27,r23

    dec  r4
    dec  r11
    dec  r19
    dec  r27
;-------------------
    .def zl = r30
    .def zh = r31

    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r20     ; (ldi) 0x00
    st   z+,r21     ; (ldi) 0x7f
    st   z+,r22     ; (ldi) 0x80
    st   z+,r23     ; (ldi) 0xff

    ldi  zh,0x01
    ldi  zl,0x10

    st   z+,r7      ; (com) 0x00
    st   z+,r8      ; (com) 0x7f
    st   z+,r16     ; (com) 0x80
    st   z+,r24     ; (com) 0xff

    st   z+,r6      ; (neg) 0x00
    st   z+,r9      ; (neg) 0x7f
    st   z+,r17     ; (neg) 0x80
    st   z+,r25     ; (neg) 0xff

    st   z+,r5      ; (inc) 0x00
    st   z+,r10     ; (inc) 0x7f
    st   z+,r18     ; (inc) 0x80
    st   z+,r26     ; (inc) 0xff

    st   z+,r4      ; (dec) 0x00
    st   z+,r11     ; (dec) 0x7f
    st   z+,r19     ; (dec) 0x80
    st   z+,r27     ; (dec) 0xff
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

;-------------------
; test for subi/sbci
;-------------------
    ldi  r16,0x30
    ldi  r20,0x10
    ldi  r24,0xf0
    ldi  r31,0xd0

    ldi  r17,0x80
    ldi  r21,0x70
    ldi  r25,0x60
    ldi  r30,0x4f
;-------------------
    ldi  r18,0x30
    ldi  r22,0x10
    ldi  r26,0xf0
    ldi  r29,0xd0

    subi r18,0x80
    sbci r22,0x70
    sbci r26,0x60
    sbci r29,0x4f
;-------------------
    ldi  r19,0x30
    ldi  r23,0x10
    ldi  r27,0xf0
    ldi  r28,0xd0

    sbci r19,0x80
    subi r23,0x70
    subi r27,0x60
    subi r28,0x4f
;-------------------
    sts  0x0100,r16     ; (ldi) 0x30
    sts  0x0101,r17     ; (ldi) 0x80
    sts  0x0102,r18     ; (subi) 0x30 0x80 (cf=0)
    sts  0x0103,r19     ; (sbci) 0x30 0x80 (cf=0)

    sts  0x0104,r20     ; (ldi) 0x10
    sts  0x0105,r21     ; (ldi) 0x70
    sts  0x0106,r22     ; (sbci) 0x10 0x70 (cf=1)
    sts  0x0107,r23     ; (subi) 0x10 0x70 (cf=1)

    sts  0x0108,r24     ; (ldi) 0xf0
    sts  0x0109,r25     ; (ldi) 0x60
    sts  0x010a,r26     ; (sbci) 0xf0 0x60 (cf=1)
    sts  0x010b,r27     ; (subi) 0xf0 0x60 (cf=1)

    sts  0x010c,r31     ; (ldi) 0xd0
    sts  0x010d,r30     ; (ldi) 0x4f
    sts  0x010e,r29     ; (sbci) 0xd0 0x4f (cf=0)
    sts  0x010f,r28     ; (subi) 0xd0 0x4f (cf=0)
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

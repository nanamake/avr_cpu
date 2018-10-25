;-------------------
; test for adiw/sbiw
;-------------------
    ldi  r25,0x02
    ldi  r24,0xd8

    adiw r24,0x30

    ldi  r27,0x02
    ldi  r26,0xd8

    adiw r26,0x0f
;-------------------
    ldi  r29,0x02
    ldi  r28,0x18

    sbiw r28,0x30

    ldi  r31,0x02
    ldi  r30,0x18

    sbiw r30,0x0f
;-------------------
    ldi  r16,0xd8
    ldi  r17,0x02
    ldi  r18,0x30
    ldi  r19,0x0f

    ldi  r20,0x18
    ldi  r21,0x02
    ldi  r22,0x30
    ldi  r23,0x0f
;-------------------
    sts  0x0100,r16     ; (ldi) 0xd8
    sts  0x0101,r17     ; (ldi) 0x02
    sts  0x0102,r18     ; (ldi) 0x30
    sts  0x0103,r19     ; (ldi) 0x0f

    sts  0x0104,r20     ; (ldi) 0x18
    sts  0x0105,r21     ; (ldi) 0x02
    sts  0x0106,r22     ; (ldi) 0x30
    sts  0x0107,r23     ; (ldi) 0x0f

    sts  0x0108,r24     ; (adiw) 0x02d8 0x30
    sts  0x0109,r25
    sts  0x010a,r26     ; (adiw) 0x02d8 0x0f
    sts  0x010b,r27
    sts  0x010c,r28     ; (sbiw) 0x0218 0x30
    sts  0x010d,r29
    sts  0x010e,r30     ; (sbiw) 0x0218 0x0f
    sts  0x010f,r31
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

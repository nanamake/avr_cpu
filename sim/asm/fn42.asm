;---------------------------
; test for interrupt/reti
;---------------------------
; In this test IRQ input is required. See testbench stimuli.
    jmp  reset
    jmp  hand1
    jmp  hand2
;-------------------
reset:
    sei

    ldi  r16,0x00
    inc  r16
    sts  0x0100,r16 ; (inc) 0x00
    inc  r16
    sts  0x0101,r16 ; (inc)
    inc  r16
    sts  0x0102,r16 ; (inc)
    inc  r16
    sts  0x0103,r16 ; (inc)
    sts  0x0104,r0  ; (inc)
    sts  0x0105,r1  ; (inc)

    ldi  r16,0x00
    inc  r16
    sts  0x0110,r16 ; (inc) 0x00
    inc  r16
    sts  0x0111,r16 ; (inc)
    inc  r16
    sts  0x0112,r16 ; (inc)
    inc  r16
    sts  0x0113,r16 ; (inc)
    sts  0x0114,r0  ; (inc)
    sts  0x0115,r1  ; (inc)

    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt
;-------------------
    .org 0x0110
hand1:
    inc  r16
    mov  r0 ,r16
    reti
;-------------------
    .org 0x0220
hand2:
    inc  r16
    mov  r1 ,r16
    reti

;-----------------------
; test for jmp/rjmp/ijmp
;-----------------------
    ldi  r16,0x00
    jmp  label2
;-------------------
finish:
    inc  r16
    mov  r3 ,r16

    sts  0x0100,r0  ; (inc) 0x00
    sts  0x0101,r1  ; (inc)
    sts  0x0102,r2  ; (inc)
    sts  0x0103,r3  ; (inc)

    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt
;-------------------
    .org 0x0110
label1:
    inc  r16
    mov  r1 ,r16
    rjmp label3
;-------------------
    .org 0x0220
label2:
    inc  r16
    mov  r0 ,r16
    rjmp label1
;-------------------
    .org 0x0330
label3:
    inc  r16
    mov  r2 ,r16

    .def zl = r30
    .def zh = r31
    ldi  zl,low(finish)
    ldi  zh,high(finish)
    ijmp

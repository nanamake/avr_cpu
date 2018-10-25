;---------------------------
; test for call/rcall/icall
;---------------------------
    ldi  r16,0x00
    call func2

    .def zl = r30
    .def zh = r31
    ldi  zl,low(func4)
    ldi  zh,high(func4)
    icall

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
func1:
    inc  r16
    mov  r1 ,r16
    rcall func3
    ret
;-------------------
    .org 0x0220
func2:
    inc  r16
    mov  r0 ,r16
    rcall func1
    ret
;-------------------
    .org 0x0330
func3:
    inc  r16
    mov  r2 ,r16
    ret
;-------------------
func4:
    inc  r16
    mov  r3 ,r16
    ret

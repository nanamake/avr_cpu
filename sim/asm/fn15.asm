;-------------------
; test for lpm/spm
;-------------------
    .def yl = r28
    .def yh = r29
    .def zl = r30
    .def zh = r31
;-------------------
    ldi  zl ,low (halt)
    ldi  zh ,high(halt)

    ldi  r20,0x10
    ldi  r21,0x20
    ldi  r22,0x30
    ldi  r23,0x40

    movw r0 ,r20
    adiw zl ,1
    spm

    movw r0 ,r22
    adiw zl ,1
    spm

    com  r20
    com  r21
    com  r22
    com  r23

    movw r0 ,r20
    adiw zl ,1
    spm

    movw r0 ,r22
    adiw zl ,1
    spm
;-------------------
    ldi  zl ,low (halt)
    ldi  zh ,high(halt)
    adiw zl ,1
    lsl  zl
    rol  zh

    lpm  r7 ,z
    adiw zl ,1
    lpm  r8 ,z
    adiw zl ,1
    lpm  r16,z
    adiw zl ,1
    lpm  r24,z
    adiw zl ,1

    lpm  r6 ,z+
    lpm  r9 ,z+
    lpm  r17,z+
    lpm  r25,z+
;-------------------
    ldi  yl ,low (loop)
    ldi  yh ,high(loop)
    lsl  yl
    rol  yh

    movw zl ,yl
    lpm
    mov  r12,r0
    adiw zl ,1
    lpm
    mov  r13,r0

    ldi  zl ,low (loop)
    ldi  zh ,high(loop)
    ldi  r20,0x00
    ldi  r21,0x00
    movw r0 ,r20
    spm

    movw zl ,yl
    lpm  r14,z+
    lpm  r15,z+

    rjmp loop
    .org 0x01c0
loop:
    rjmp loop   ; Replaced with NOP opcode by SPM instruction
;-------------------
    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r7      ; (lpm) 0x10
    st   z+,r8      ; (lpm) 0x20
    st   z+,r16     ; (lpm) 0x30
    st   z+,r24     ; (lpm) 0x40

    st   z+,r6      ; (lpm) ~0x10
    st   z+,r9      ; (lpm) ~0x20
    st   z+,r17     ; (lpm) ~0x30
    st   z+,r25     ; (lpm) ~0x40

    st   z+,r12     ; (lpm) low (rjmp loop)
    st   z+,r13     ; (lpm) high(rjmp loop)
    st   z+,r14     ; (lpm) low (nop)
    st   z+,r15     ; (lpm) high(nop)
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

;-----------------------
; test for skip enable
;-----------------------
    ; In this test IRQ input is required. See testbench stimuli.
    jmp  reset
    jmp  hand1
;-------------------
reset:
    .equ spl  = 0x3d    ; stack pointer low byte
    .equ sreg = 0x3f    ; status register

    ; Test for net skp_det/irq_det
    sei
    in   r8 ,spl
    sts  0x0100,r8

    ; Test for net skp_2nd_det/pc_new
    ldi  r16,0x00
    cpse r16,r16
    jmp  halt

    ; Interrupt here
    sts  0x0101,r8

    ; Test for net skp_2nd_det/tim_sr_en
    in   r8 ,spl
    cpse r16,r16
    call halt
    in   r9 ,spl

    sts  0x0102,r8
    sts  0x0103,r9
;-------------------
    ; Test for net skp_det
    ldi  r16,0xff
    cpse r16,r16
    cpse r16,r16
    ldi  r16,0x00
    sts  0x0104,r16

    ; Test for net skp_2nd_det/tim_dm_re
    ldi  r16,0xff
    sts  0x0105,r16
    ldi  r17,0x00
    cpse r17,r17
    lds  r17,0x0105
    sts  0x0106,r17

    ; Test for net skp_2nd_det/tim_dm_we
    cpse r17,r17
    sts  0x0107,r17
;-------------------
    ; Test for net tim_rf_we/tim_sr_en
    in   r8 ,sreg
    ldi  r16,0x00
    cpse r16,r16
    com  r16
    in   r9 ,sreg

    sts  0x0108,r8
    sts  0x0109,r9
    sts  0x010a,r16
;-------------------
    ; Test for net pm_wd_new
    .def zl = r30
    .def zh = r31

    ldi  zl ,low (halt)
    ldi  zh ,high(halt)
    adiw zl ,1

    ldi  r20,0x10
    ldi  r21,0x20
    ldi  r22,0x30
    ldi  r23,0x40

    movw r0 ,r20
    spm
    movw r0 ,r22
    cpse r16,r16
    spm

    ; Test for net lpm_re_l/lpm_re_h
    lsl  zl
    rol  zh

    cpse r16,r16
    lpm  r0 ,z
    adiw zl ,1
    cpse r16,r16
    lpm  r1 ,z

    sts  0x010c,r0
    sts  0x010d,r1

    lpm  r1 ,z
    sbiw zl ,1
    lpm  r0 ,z

    sts  0x010e,r0
    sts  0x010f,r1
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt
;-------------------
    .org 0x0110
hand1:
    in   r8 ,spl
    reti

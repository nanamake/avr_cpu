;-------------------
; test for brbc
;-------------------
    .def zl = r30
    .def zh = r31
    .equ sreg = 0x3f
;-------------------
    ldi  r28,0x00
    ldi  r29,0x00

    movw r2 ,r28
    movw r4 ,r28
    movw r10,r28
    movw r12,r28
    movw r18,r28
    movw r20,r28
    movw r26,r28

    rjmp test0_t
;-------------------
    .org 0x0040
test0_t:
    bset 1
    bset 2
    bset 3
    bset 4
    bset 5
    bset 6
    bset 7
    brbc 0,test0_f
    in   r5 ,sreg
    rjmp test0_f

test1_f:
    bset 0
    bclr 1
    brbc 0,test1_t
    in   r3 ,sreg
    rjmp test1_t

test2_t:
    bset 1
    bclr 2
    brbc 2,test2_f
    in   r10,sreg
    rjmp test2_f

test3_f:
    bset 2
    bclr 3
    brbc 2,test3_t
    in   r12,sreg
    rjmp test3_t

test4_t:
    bset 3
    bclr 4
    brbc 4,test4_f
    in   r18,sreg
    rjmp test4_f

test5_f:
    bset 4
    bclr 5
    brbc 4,test5_t
    in   r20,sreg
    rjmp test5_t

test6_t:
    bset 5
    bclr 6
    brbc 6,test6_f
    in   r26,sreg
    rjmp test6_f

test7_f:
    bset 6
    bclr 7
    brbc 6,test7_t
    in   r28,sreg
    rjmp test7_t
;-------------------
    .org 0x0080
test0_f:
    brbc 1,test1_f
    in   r4 ,sreg
    rjmp test1_f

test1_t:
    brbc 1,test2_t
    in   r2 ,sreg
    rjmp test2_t

test2_f:
    brbc 3,test3_f
    in   r11,sreg
    rjmp test3_f

test3_t:
    brbc 3,test4_t
    in   r13,sreg
    rjmp test4_t

test4_f:
    brbc 5,test5_f
    in   r19,sreg
    rjmp test5_f

test5_t:
    brbc 5,test6_t
    in   r21,sreg
    rjmp test6_t

test6_f:
    brbc 7,test7_f
    in   r27,sreg
    rjmp test7_f

test7_t:
    brbc 7,test_end
    in   r29,sreg
    rjmp test_end
;-------------------
    .org 0x00c0
test_end:
    ldi  zh,0x01
    ldi  zl,0x00

    st   z+,r5      ; (brbc) b0 (true)
    st   z+,r4      ; (brbc) b1 (false)
    st   z+,r3      ; (brbc) b0 (false)
    st   z+,r2      ; (brbc) b1 (true)

    st   z+,r10     ; (brbc) b2 (true)
    st   z+,r11     ; (brbc) b3 (false)
    st   z+,r12     ; (brbc) b2 (false)
    st   z+,r13     ; (brbc) b3 (true)

    st   z+,r18     ; (brbc) b4 (true)
    st   z+,r19     ; (brbc) b5 (false)
    st   z+,r20     ; (brbc) b4 (false)
    st   z+,r21     ; (brbc) b5 (true)

    st   z+,r26     ; (brbc) b6 (true)
    st   z+,r27     ; (brbc) b7 (false)
    st   z+,r28     ; (brbc) b6 (false)
    st   z+,r29     ; (brbc) b7 (true)
;-------------------
    ldi  r16,0xff
    sts  0xffff,r16
halt:
    rjmp halt

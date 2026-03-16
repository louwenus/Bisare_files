
main:
        let r0 0x00fffffc
        copy SP r0 ; setup stack pointer

        let r0 0x00000000 ; GREEN
        let r14 0x0005000;
loop:
        sub r14 r14 1
        add r0 r0 1
        and r0 r0 0x00FF
        call clear
        skipto halt ifeq r14 0
        jump loop

halt:
        call 0





clear: ; color in r0
        let r1 0x01000000
        let r2 0x0112c000
clrloop:
        store [r1] r0
        store [r1+4] r0
        store [r1+8] r0
        store [r1+12] r0
        store [r1+16] r0
        store [r1+20] r0
        store [r1+24] r0
        store [r1+28] r0
        add r1 r1 32
        skipto end ifge r1 r2
        jump clrloop
end:
        ret


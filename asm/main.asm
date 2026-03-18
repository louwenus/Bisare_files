main:
        let r0 0x00FF0000
        call screen_clr
        let r12 0xFF00FF00
        let r14 50
        let r15 50
        let r13 0x01200000
        let r1 1
        store [r13+0x1000] r1
        halt

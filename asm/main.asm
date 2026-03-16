main:
        let r0 0x00FF00 ; green
        call screen_clr

        let r0 65468
        let r1 987
        div r2 r0 r1
        mod r3 r0 r1
        skip 1 ifeq r2 66
        jump error
        skip 1 ifeq r3 326
        
        let r0 18654547
        let r1 6513
        div r2 r0 r1
        mod r3 r0 r1
        skip 1 ifeq r2 2864
        jump error
        skip 1 ifeq r3 1315

        let r0 0xCAFE5678
        let r1 0x1324FECA
        umull r2 r0 r1
        umulh r3 r0 r1
        smull r4 r0 r1
        smulh r6 r0 r1
        let r5 0x975b4ab0
        skip 1 ifeq r2 r5
        jump error
        skip 1 ifeq r2 r5
        jump error
        let r5 0xf2e3637
        skip 1 ifeq r3 r5
        jump error
        let r5 0xfc09376d
        skip 1 ifeq r6 r5
        halt
        
error:
        let r0 0x0000FF ; red
        call screen_clr
        halt



screen_clr:
        let r1 0x01000000
        let r2 0x0112C000
screen_clr_loop:
        store [r1] r0
        add r1 r1 4
        skip 1 ifgt r1 r2
        jump screen_clr_loop
        ret

        let r0 0xFFFFFFFF
        let r1 0x01000000
        let r3 0x0112c000
main_loop:

        call consume
        store [r1] r0
        add r1 r1 4

        skip 1 ifult r1 r3
        call 0
        
        jump main_loop


consume:
        let r2 0
        let r4 561
        let r5 65465123589
        call consume_2
        ret

consume_2:
        skip 1 ifult r2 1000
        ret
        add r2 r2 1
        mult r4 r4 r5
        div r6 r4 687
        jump consume_2

mmio:
        load r3 [r13-12]
        skip 1 ifult r3 256
                reti
        load r1 [r13-4]
        skip 1 ifne r1 0 ; fine if press, even OS syntetic press
                reti
        copy r0 r12
        copy r1 r14
        copy r2 r15
        add r14 r14 8
        skipto mmio_cc ifult r14 600
                copy r14 0
                add r15 r15 16
                skipto mmio_cc ifult r15 400
                        copy r15 0
        mmio_cc:
        call print_char_unsafe
        reti

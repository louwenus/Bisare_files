; setup memory as follow
; Scratch  Remain_this_color Color Screen_pointer Bad_apple_next_pointer Loaded_value Remaining_significants_bits Frame_counter Screen_start Screen_end draw? 10bit_mask 25bit_mask
; R0-3        R4              R5        R6                 R7                 R8                 R9                  R10           R11         R12       R13       R14       R15


;White because we set 0 of this color
let r4 0
let r5 -1

;screen start
let r6 0x01000000

;bad apple
let r7 bad_apple_video
let r8 0
let r9 0
let r10 0

;screen end
copy r11 r6
let r12 0x0112c000

;draw
let r13 1

let r14 0x3FF
let r15 0x1FFFFFF

;activate drawing mmio:
let r0 0x01201000
let r1 8
store [r0] r1

halt

mmio:
;this is a screen (the only active) mmio

;draw at 30 fps, one frame every two requested
skip 2 ifeq r13 1
        copy r13 1
        reti
copy r13 0

;end if end of video reached
skip 1 iflt r10 6572
        call 0
add r10 r10 1


copy r6 r11


draw_loop:
        skip 1 iflt r6 r12 ;we got to end of screen.
                reti
        skipto get_next_data ifle r4 0
        store [r6] r5
        sub r4 r4 1
        add r6 r6 4
        jump draw_loop

get_next_data:
        ;exchange color
        not r5 r5
        skipto get_next_data_cross iflt r9 10
        and r4 r8 r14
        sub r9 r9 10
        lsr r8 r8 10
        skipto get_next_large ifeq r4 0
        jump draw_loop
        
get_next_data_cross:
        copy r4 r8
        load r8 [r7]
        add r7 r7 4
        lsl r0 r8 r9
        and r0 r0 r14
        or r4 r4 r0
        copy r3 10
        sub r2 r3 r9
        lsr r8 r8 r2
        add r9 r9 22
        skipto get_next_large ifeq r4 0
        jump draw_loop
        
get_next_large:
        skipto get_next_large_cross iflt r9 25
        and r4 r8 r15
        sub r9 r9 25
        lsr r8 r8 25
        jump draw_loop

get_next_large_cross:
        copy r4 r8
        load r8 [r7]
        add r7 r7 4
        lsl r0 r8 r9
        and r0 r0 r15
        or r4 r4 r0
        copy r3 25
        sub r2 r3 r9
        lsr r8 r8 r2
        add r9 r9 7
        jump draw_loop
        


; Scratch  Remain_this_color Color Screen_pointer Bad_apple_next_pointer Loaded_value Remaining_significants_bits Frame_counter Screen_start Screen_end draw? 10bit_mask 25bit_mask
; R0-3        R4              R5        R6                 R7                 R8                 R9                  R10           R11         R12       R13       R14       R15

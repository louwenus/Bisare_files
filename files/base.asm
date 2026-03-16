jump __start  ; entry
jump mmio     ; mmio interupt
call 0        ; swi interupt
call 0        ; div0 interupt
call 0        ; unaligned load store
call __sdivmul; unsuported opcode
call 0        ; iot


__sdivmul:
        push r0
        push r4
        push r5
        skip 1 ifne r3 0b1001
        jump __soft_smull
        skip 1 ifne r3 0b1010
        jump __soft_smulh
        skip 1 ifne r3 0b1011
        jump __soft_umull
        skip 1 ifne r3 0b1100
        jump __soft_umulh
        skip 1 ifne r3 0b1101
        jump __soft_div
        skip 1 ifne r3 0b1110
        jump __soft_mod
        call 0
        
__soft_mod:
        copy r0 r1
        copy r1 r2
        call __divise_alg
        copy r1 r0
        pop r5
        pop r4
        pop r0
        reti

__soft_div:
        copy r0 r1
        copy r1 r2
        call __divise_alg
        pop r5
        pop r4
        pop r0
        reti

; algo de division
; Args:
; R0 = Dividende
; R1 = Diviseur
; Return:
; R0 = reste
; R1 = Quotien
__divise_alg:
        copy r3 16
        lsr  r2 r0 16
        skip 2 ifuge r2 r1
        copy r3 0
        copy r2 r0
        ;skip here
        lsr  r4 r2 8
        skip 2 ifult r4 r1
        add  r3 r3 8
        copy r2 r4
        ;skip here
        lsr  r4 r2 4
        skip 2 ifult r4 r1
        add  r3 r3 4
        copy r2 r4
        ;skip here
        lsr  r4 r2 2
        skip 2 ifult r4 r1
        add  r3 r3 2
        copy r2 r4
        ;skip here
        lsr  r4 r2 1
        skip 1 ifult r4 r1
        add  r3 r3 1
        ;skip here
        ; a ce point, r3 contient le nombre de shift gauche qu'il faut faire sur le diviseur pour le caller "juste en dessous" du dividende. Aussi nombre d'étape de division -1
        lsl r2 r1 r3
        copy r1 0
        ; états des registres:
        ; r0: dividende
        ; r1: quotient
        ; r2: diviseur shifté
        ; r3: nombre de tour de boucle a faire
__divise_loop_start:
        skip 1 ifge r3 0
        ret
        
        lsl r1 r1 1
        skipto __divise_loop_mid ifult r0 r2
        or r1 r1 1
        sub r0 r0 r2
__divise_loop_mid:
        lsr r2 r2 1
        sub r3 r3 1
        jump __divise_loop_start


__soft_umull:
        copy r0 r2
        call __umull_alg
        copy r1 r2
        pop r5
        pop r4
        pop r0
        reti

__soft_smull:
        copy r3 0

        and r5 r1 0x80000000
        skip 1 ifeq r5 0
        sub r1 r3 r1
        
        and r4 r2 0x80000000
        skip 1 ifeq r4 0
        sub r2 r3 r2

        copy r0 r2
        call __umull_alg

        xor r4 r4 r5 ; should the result be signed (xor of signs)
        skip 1 ifeq r4 0
        sub r2 r0 r2 ; r0 == 0 at mult end.

        copy r1 r2
        pop r5
        pop r4
        pop r0
        reti

__soft_umulh:
        push r6 ;reserve registers
        push r7
        push r8

        call __long_mul

        pop r8 ; cleanup and return
        pop r7
        pop r6
        pop r5
        pop r4
        pop r0
        reti

__soft_smulh
        push r6
        push r7
        push r8
        push r9
        
        copy r3 0
        
        and r5 r1 0x80000000
        skip 1 ifeq r5 0
        sub r1 r3 r1
        
        and r4 r2 0x80000000
        skip 1 ifeq r4 0
        sub r2 r3 r2

        xor r9 r4 r5

        call __long_mul

        skipto __soft_smulh_cleanup ifeq r9 0 ; no need to invert result sign
        ; neg(x) = not(x) + 1
        ; however the +1 apply to the lower half, it only transfert to this upper half
        ; if not(x) is only ones (aka x is only 0)
        ; no need to calculate the lower half by mult, __long_mult have it nearly ready!
        lsl r7 r7 16
        add r7 r7 r2 ; low * low + (carry << 16)

        not r1 r1
        skip 1 ifne r7 0
        add r1 1

__soft_smulh_cleanup:
        pop r9
        pop r8
        pop r7
        pop r6
        pop r5
        pop r4
        pop r0
        reti
        

        

__long_mul:
        ;prepare halfs to mult
        and r4 r1 0xFFFF ; r1 low half
        lsr r5 r1 16     ; r1 upper half
        and r6 r2 0xFFFF ; r2 low half
        lsr r7 r2 16     ; r2 upper half

        copy r0 r5
        copy r1 r7
        call __umull_alg
        copy r8 r2       ; main high*high result
        
        copy r0 r7       ; preffer upper half (more chance of being little) for faster mul
        copy r1 r4
        call __umull_alg
        and r7 r2 0xFFFF ; lower half for carry. r7 reused
        lsr r2 r2 16     ; upper half of low * high, added to final result.
        add r8 r8 r2

        copy r0 r5
        copy r1 r6
        call __umull_alg
        lsr r1 r2 16     ; upper half, add to main result
        add r8 r8 r1     
        and r2 r2 0xFFFF ; low half, carry
        add r7 r7 r2

        copy r0 r4
        copy r1 r6
        call __umull_alg
        lsr r1 r2 16    ;upper half of low * low, add to carry
        add r7 r7 r1
        lsr r6 r7 16    ;upper half of carry, add to main for result
        add r1 r6 r8

        
        ;r1: main result
        ;r8: result without carry
        ;r7: carry
        ;r6: shifted carry
        ;r2: low*low
        ret

        
        

; r0 * r1
; result in r2
; use registers r0-3
__umull_alg:
        copy r2 0
__umull_alg_loop:
        skipto 1 ifne r0 0
        ret
        ;skip here
        and r3 r0 1
        skip 1 ifeq r3 0
        add r2 r2 r1
        lsr r0 r0 1
        lsl r1 r1 1
        jump _umull_alg_loop


;point d'entrée
__start:
        let r0 0x00fffffc
        copy SP r0 ; setup stack pointer
        eint

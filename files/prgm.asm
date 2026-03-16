
main:
        let r0 0x00fffffc
        copy SP r0 ; setup stack pointer
        
        let r0 0x0000FF00 ; GREEN
        call clear
        
        let r0 1567
        let r1 27
        call divise
        skipto error ifne r0 1
        skipto error ifne r1 58

        let r0 4967296
        let r1 367
        call divise
        skipto error ifne r0 318
        skipto error ifne r1 13534 
        

        halt
error:
        let r0 0x000000FF ; RED
        call clear
        halt











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

; algo de division
; Args:
; R0 = Dividende
; R1 = Diviseur
; Return:
; R0 = reste
; R1 = Quotien

divise:
        copy r3 16
        lsr  r2 r0 16
        skipto divise_shift_8 ifuge r2 r1
        copy r3 0
        copy r2 r0
divise_shift_8:
        lsr  r4 r2 8
        skipto divise_shift_4 ifult r4 r1
        add  r3 r3 8
        copy r2 r4
divise_shift_4:
        lsr  r4 r2 4
        skipto divise_shift_2 ifult r4 r1
        add  r3 r3 4
        copy r2 r4
divise_shift_2:
        lsr  r4 r2 2
        skipto divise_shift_1 ifult r4 r1
        add  r3 r3 2
        copy r2 r4
divise_shift_1:
        lsr  r4 r2 1
        skipto divise_shift_end ifult r4 r1
        add  r3 r3 1
divise_shift_end:
        ; a ce point, r3 contient le nombre de shift gauche qu'il faut faire sur le diviseur pour le caller "juste en dessous" du dividende. Aussi nombre d'étape de division -1
        lsl r2 r1 r3
        copy r1 0
        ; états des registres:
        ; r0: dividende
        ; r1: quotient
        ; r2: diviseur shifté
        ; r3: nombre de tour de boucle a faire
divise_loop_start:
        skip 1 ifge r3 0
        ret
        
        lsl r1 r1 1
        skipto divise_loop_mid ifult r0 r2
        or r1 r1 1
        sub r0 r0 r2
divise_loop_mid:
        lsr r2 r2 1
        sub r3 r3 1
        jump divise_loop_start

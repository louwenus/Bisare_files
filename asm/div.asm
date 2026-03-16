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

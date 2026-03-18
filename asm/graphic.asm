; Args: R0: Couleur
;       R1,R2 coordonées en haut a gauche
;       R3,R4 coordonées en bas a droite
; Retourne: R0: Couleur
rectfill:
        let r5 0x01000000
        umull r2 r2 2560
        add r2 r2 r5
        umull r4 r4 2560
        add r4 r4 r5
        lsl r1 r1 2
        lsl r3 r3 2
        copy r5 r1
rectfill_outer_loop:
        copy r1 r5

rectfill_inner_loop:
        store [r1+r2] r0
        add r1 r1 4
        skip 1 ifgt r1 r3
        jump rectfill_inner_loop
        
        add r2 r2 2560
        skip 1 ifle r2 r4
        ret
        jump rectfill_outer_loop
        

; Args: R0: couleur de remplisssage
; Return: R0 Couleur, r3-r5: non modifiés
screen_clr:
        let r1 0x01000000
        let r2 0x0112C000
screen_clr_loop:
        store [r1] r0
        add r1 r1 4
        skip 1 ifge r1 r2
        jump screen_clr_loop
        ret



; Args: R0: Couleur
;       R1,R2 coordonées du point
; Return R0: Couleur R3-R5 non modifiés
plot:
        umull r2 r2 640
        add r1 r1 r2
        lsl r1 r1 2
        let r2 0x01000000
        store [r1+r2] r0
        ret

; Args: R0: Couleur
; R1,R2 coordonées du coin haut gauche
; R3: Pointeur sur l'image
; Return: R0: Couleur

print_pict:
        load r4 [r3]     ;width
        load r5 [r3+4]   ;height
        add r3 r3 8      ;data start
print_pict_no_meta:      ;supply r4 = width and r5 = height, r3 to data start
        push r6
        push r7
        push r8

        umull r2 r2 2560 ;*640*4
        lsl r1 r1 2      ;*4
        add r1 r1 r2
        let r2 0x01000000
        add r1 r1 r2     ; r1 = memory start
        let r6 0
        
        copy r2 r4    ;set column counter
print_pict_w_loop:
        skipto print_pict_w_loop_2 ifne r2 0
                let r2 640
                sub r2 r2 r4
                lsl r2 r2 2
                add r1 r1 r2  ;next line
                sub r5 r5 1   ;decrease line conter
                skipto print_pict_end ifeq r5 0
                copy r2 r4
                jump print_pict_w_loop
        print_pict_w_loop_2:
        skipto print_pict_no_reload ifne r6 0
                let r6 32
                load r7 [r3]
                add r3 r3 4
        print_pict_no_reload:
            and r8 r7 1
            skip 1 ifeq r8 0
                store [r1] r0
            add r1 r1 4
            lsr r7 r7 1
            sub r6 r6 1
            sub r2 r2 1
        jump print_pict_w_loop    

print_pict_end:
        pop r8
        pop r7
        pop r6
        ret


;R0 = couleur
;R1,R2 = Coordonées en haut a gauche
;R3 = ascii du char
; renvoie R0 = couleur
print_char:
        skip 1 ifule r3 256        
        ret
print_char_unsafe: ;must be certain that code < 256
        let r4 picture_fontplate
        lsl r3 r3 4  ; 8*16 bit per char => 16 byte per char
        add r3 r3 r4
        let r4 8
        let r5 16
        jump print_pict_no_meta  ;this is the equivalent of call + ret because we do not have anything to restore from the stack.

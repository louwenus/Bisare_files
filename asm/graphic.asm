; Args: R0: Couleur
;       R1,R2 coordonées en haut a gauche
;       R3,R4 coordonées en bas a droite
; Retourne: R0: Couleur
rectfill:
        umull r2 r2 2560
        let r5 0x01000000
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

print_background:
        let r1 0
        let r2 0
        let r3 picture_background
        jump print_pict


; Args: R0: Couleur
;       R1 buffer
;       R2,R3 coordonées du point
; Return R0: Couleur R4-R5 non modifiés
plot:
        umull r3 r3 640
        add r2 r2 r3
        lsl r2 r2 2
        store [r1+r2] r0
        ret

;Args: R0 //Anything, ignored
;R1,R2 coordonées du coin haut gauche
;R3: Pointeur sur l'image

print_pict:
        push r6
        
        let r0 0x01000000
        load r4 [r3]     ;width
        load r5 [r3+4]   ;height
        add r3 r3 8      ;data start

        umull r2 r2 640 ;*640*4
        add r1 r1 r2
        lsl r1 r1 2      ;*4
        add r1 r1 r0     ; r1 = memory start
        
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
print_pict_end:
        pop r6
        ret
                
        print_pict_w_loop_2:
                skipto print_pict_rolled iflt r2 5
                ; slight loop unrolling for perfomance because we abuse of this function in rendering
                load r6 [r3]
                skip 1 ifeq r6 0
                        store [r1] r6
                load r6 [r3+4]
                skip 1 ifeq r6 0
                        store [r1+4] r6
                load r6 [r3+8]
                skip 1 ifeq r6 0
                        store [r1+8] r6
                load r6 [r3+12]
                skip 1 ifeq r6 0
                        store [r1+12] r6
                add r3 r3 16
                add r1 r1 16
                sub r2 r2 4

        print_pict_rolled:
                load r6 [r3]
                add r3 r3 4
                skip 1 ifeq r6 0
                        store [r1] r6
                add r1 r1 4
                sub r2 r2 1
                jump print_pict_w_loop    

                


;R0 = couleur
;R1 = buffer; ignoré
;R2,R3 = Coordonées en haut a gauche
;R4 = ascii du char
; renvoie R0 = couleur
print_char:
        skip 1 ifult r4 256        
        ret
print_char_unsafe: ;must be certain that code < 256
        push r6
        let r5 picture_fontplate
        lsl r4 r4 4  ; 8*16 bit per char => 16 byte per char
        add r4 r4 r5
        umull r3 r3 640
        add r2 r2 r3
        lsl r2 r2 2
        let r1 0x01000000
        add r2 r1 r2

        
        let r5 128
        load r3 [r4]
        
print_char_loop:
        and r6 r3 1
        skip 1 ifne r6 1
                store [r2] r0

        lsr r3 r3 1
        sub r5 r5 1
        skipto print_char_end ifeq r5 0
        and r6 r5 7
        skip 1 ifne r6 0
                add r2 r2 2528
        and r6 r5 31
        skip 2 ifne r6 0
                load r3 [r4+4]
                add r4 r4 4
        add r2 r2 4
        jump print_char_loop        
        
        
print_char_end:
        pop r6
        ret

;r0 couleur
;r1 valeur
;r2 x
;r3 y
print_int:
push r6
push r7
push r8

        div r6 r1 10
        mod r4 r1 10
        copy r7 r2
        copy r8 r3
        add r4 r4 48
        call print_char_unsafe
        print_int_loop:
                skipto print_int_end ifeq r6 0
                mod r4 r6 10
                div r6 r6 10
                add r4 r4 48
                sub r7 r7 8
                copy r2 r7
                copy r3 r8
                call print_char_unsafe
        jump print_int_loop
        
print_int_end:
pop r8
pop r7
pop r6
ret

main:
        let r0 0x01201000
        let r1 14
        store [r0] r1

        let r15 store_game_vars
        let r14 0x01200004 ; horloge
        let r13 store_plantes
        let r12 store_plantes_data
        let r11 store_zombie_data
        
        ; halt
main_game_logic_loop:
        load r10 [r14] ; clock actual

        load r9 [r15+16] ; soleil natural gen
        skipto main_loop2 ifugt r9 r10
                add r9 r9 6000
                store [r15+16] r9
                load r9 [r15]  ;no mutex on that ... we consider the bug if interrupt for clic happen here to be rare enough to be ok
                add r9 r9 25
                store [r15] r9
                
        main_loop2:
        
        copy r9 0 ; store_add
        copy r8 0 ;x
        copy r7 0 ;y
        main_loop_plant_loop:
                skip 2 iflt r8 9
                        add r7 r7 1
                        copy r8 0
                skip 1 iflt r7 5
                        jump main_loop3
                
                add r6 r9 r13
                load r4 [r6] ;id
                skipto main_loop_plant_loop_continue ifeq r4 -1
                load r5 [r6+8]
                skipto main_loop_plant_loop_continue ifugt r5 r10
                umull r4 r4 24
                add r4 r4 r12
                load r2 [r4+8]
                load r3 [r4+12]
                add r5 r5 r3
                store [r6+8] r5
                copy r0 r8
                copy r1 r7
                call call_by_ptr
                
                         
        main_loop_plant_loop_continue:
                add r8 r8 1
                add r9 r9 12 ; 3 word each
                jump main_loop_plant_loop

        main_loop3:


        push r13 ; we need a bit more room
        
        let r9 store_zombies
        let r8 0 ; x in store
        let r7 0 ; y

        main_loop_zombie_loop:
        skip 2 iflt r8 20
                copy r8 0
                add r7 r7 1
        skip 1 iflt r7 5
                jump main_loop4
        load r6 [r9]
        skip 2 ifeq r6 -1
          load r13 [r9+16]
          skip 1 ifle r13 r10
                jump main_loop_zombie_continue
        umull r6 r6 20
        add r6 r6 r11
        load r4 [r9+12]
        skipto main_loop_zombie_advance ifugt r4 35

        load r0 [r6+8]
        load r1 [r9+8]
        copy r2 r7
        call damage_plante
        skipto main_loop_zombie_advance_pre ifeq r0 0
        load r0 [r6+12]
        add r13 r13 r0
        store [r9+16] r13
        jump main_loop_zombie_continue

        main_loop_zombie_advance_pre:
        load r4 [r9+12]
        main_loop_zombie_advance: ; assume r4 is current x in case
                                  ; assume r13 is current time
        load r5 [r6+16]
        add r13 r13 r5
        store [r9+16] r13
        skipto main_loop_zombie_change_case ifle r4 0
        sub r4 r4 1
        store [r9+12] r4
        
        main_loop_zombie_continue:
        add r8 r8 1
        add r9 r9 20
        jump main_loop_zombie_loop

        main_loop_zombie_change_case:
        add r4 r4 64
        load r5 [r9+8]
        sub r5 r5 1
        skip 1 ifge r5 0
                jump game_lost
        store [r9+12] r4
        store [r9+8] r5
        

        jump main_loop_zombie_continue
        
        
        main_loop4:
        pop r13

        ; update pseudo random
        load r9 [r15+24]
        lsr r8 r9 5
        sub r9 r8 r9
        xor r9 r10 r9
        store [r15+24] r9
        

jump main_game_logic_loop



; stores
; game_vars:
;    - nb_soleil
;    - plante selectionné
;    - selection x
;    - selection y
; plantes: 8*6,
;     - plante ID
;     - Vie
;     - next_action
; plantes_data: for each plant by id
;     - sprite ptr
;     - prix
;     - ptr de fonction on fire: args pos x y en case de la plante
;     - fréquence (nb de milliseconde entre chaque attaque)
;     - pv
;     - ptr de fonction on death: args pos x y en case de la plante
; zombie_data
;     - sprite ptr
;     - vie
;     - dégats
;     - freq_atq
;     - speed (en ms/pix)


;r0: //legacy, ignored
;r1: plante_id
;r2: horizontal square
;r3: vertical square
;
;Return:

display_big_plante:
        
        let r4 store_plantes_data
        umull r1 r1 24 ; 4*6
        add r4 r1 r4
        
        umull r2 r2 65
        umull r3 r3 77
        add r1 r2 30 ; plant drawing area
        add r2 r3 68 ; plant drawing area

        load r3 [r4]
        
        jump print_pict


; r0: plante_id
; r1: x
; r2: y
create_plante:
        push r6
        
        let r3 store_plantes_data
        umull r4 r0 24 ;4bytes * 6champs dans plantes_data
        add r3 r3 r4

        umull r2 r2 9
        add r1 r1 r2
        umull r1 r1 12

        ; handle price, exit of too costy
        let r5 store_game_vars
        load r2 [r5]   ;soleils dispo
        load r4 [r3+4] ;prix
        skip 1 ifge r2 r4
                jump create_plante_end
        sub r2 r2 r4
        store [r5] r2

        
        let r4 store_plantes
        add r4 r1 r4

        store [r4] r0
        load r0 [r3+16]
        store [r4+4] r0
        load r0 [r3+12]
        let r3 0x01200004 ; horloge
        load r3 [r3]
        add r0 r0 r3
        store [r4+8] r0

create_plante_end:
        pop r6
        ret

; args: r0: dégats
;       r1: x
;       r2: y
; Return: 0 si pas de plante
;         1 si plante présente (et endomagée)
damage_plante:
        let r4 store_plantes
        umull r3 r2 9
        add r3 r3 r1
        umull r3 r3 12
        add r3 r3 r4
        load r4 [r3]
        skip 2 ifne r4 -1
                copy r0 0
                ret
        load r5 [r3+4]
        sub r5 r5 r0
        store [r3+4] r5
        skipto damage_plante_end ifgt r5 0
        copy r5 -1
        store [r3] r5
        copy r0 r1
        copy r1 r2
        let r2 store_plantes_data
        umull r4 r4 24
        add r2 r2 r4
        load r2 [r2+20] ; on death
        call call_by_ptr

damage_plante_end:
        copy r0 1
        ret
                


game_lost:
        let r0 0x01201000
        let r1 1
        store [r0] r1
        let r1 0
        let r2 0
        let r3 picture_game_over
        call print_pict
        halt

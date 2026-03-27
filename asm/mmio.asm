mmio:
        skip 1 ifne r0 2
                jump mmio_mouse_move
        skip 1 ifne r0 1
                jump mmio_mouse_clic
        skip 1 ifne r0 3
                jump mmio_frame_display
        call 0

mmio_mouse_move:
        push r1
        push r2
        let r1 0x0120000c ; MMIO mouse pos
        load r0 [r1]
        load r1 [r1+4]
        skipto mmio_mouse_move_illegal iflt r0 30
        skipto mmio_mouse_move_illegal iflt r1 68
        sub r0 r0 30
        sub r1 r1 68
        div r0 r0 65
        div r1 r1 77
        skipto mmio_mouse_move_illegal ifge r0 9
        skipto mmio_mouse_move_illegal ifge r1 5

mmio_mouse_move_end:
        let r2 store_game_vars
        store [r2+8] r0
        store [r2+12] r1        

        pop r2
        pop r1
        reti
mmio_mouse_move_illegal:
        copy r0 -1
        copy r1 -1
        jump mmio_mouse_move_end    


mmio_mouse_clic:
        push r5
        let r5 0x01200008 ;mmio souris 
        load r0 [r5]
        skip 2 ifeq r0 1 ;clic gauche
                pop r1
                reti
        
        push r2
        push r3
        push r4
        push r1

        let r3 store_game_vars
        load r0 [r3+4]
        load r1 [r3+8]
        load r2 [r3+12]
        skipto mouse_clic_store ifeq r0 -1
        skipto mouse_clic_store ifeq r1 -1
        skipto mouse_clic_store ifeq r2 -1
        copy r4 -1
        store [r3+4] r4
        call create_plante
        jump mouse_clic_end

mouse_clic_store:
        load r1 [r5+4]
        load r0 [r5+8]
        call quelle_plante
        store [r3+4] r0 ; pas beaux, mais en pratique r3 non écrasé par quelle_plante

mouse_clic_end:
        pop r1
        pop r4
        pop r3
        pop r2
        pop r5
        reti


mmio_frame_display:
        push r1
        
        ;30 fps frame limiter
        let r1 store_game_vars
        load r0 [r1+20]
        skip 4 ifeq r0 1
                copy r0 1
                store [r1+20] r0
                pop r1
                reti
        copy r0 0
        store [r1+20] r0
        
        push r2
        push r3
        push r4
        push r5
        push r6
        push r7
        push r8
        push r9
        push r10
        
        call print_background

        ; -------
        ; print plants
        ; -------
        
        let r7 0
        let r8 0
        let r6 store_plantes
        let r9 store_game_vars
display_all_plants_loop:
        load r1 [r6]
        skipto display_all_plants_plant ifne r1 -1
        
        load r3 [r9+8]
        skipto display_all_plants_loop_end ifne r3 r7
        load r3 [r9+12]
        skipto display_all_plants_loop_end ifne r3 r8
        ;plant selected for placement and on this block
        load r1 [r9+4]
        skipto display_all_plants_loop_end ifeq r1 -1
        
        display_all_plants_plant:
                copy r3 r8
                copy r2 r7
                call display_big_plante

display_all_plants_loop_end:
        add r7 r7 1
        add r6 r6 12
        skip 3 iflt r7 9
                copy r7 0
                add r8 r8 1
        skip 1 ifeq r8 5
                jump display_all_plants_loop
        ; ------
        ; sun counter
        ; ------
        let r0 0xFF ; black
        load r1 [r9]
        let r2 45
        let r3 46
        call print_int

        ; -----
        ; zombies
        ; -----

        let r9 store_zombies
        let r8 store_zombie_data
        let r7 0 ; index in z array
        let r6 0 ; line in z array
        let r10 65; initial y value

display_zombie_loop:
        load r5 [r9]
        skipto display_zombie_loop_continue ifeq r5 -1
        umull r5 r5 20
        load r3 [r5+r8]

        load r5 [r9+8]
        load r4 [r9+12]
        umull r5 r5 65
        add r1 r5 r4
        add r1 r1 10

        copy r2 r10
        call print_pict

display_zombie_loop_continue:
        add r9 r9 20
        add r7 r7 1
        skip 3 iflt r7 20
                copy r7 0
                add r6 r6 1
                add r10 r10 77
        skip 1 ifeq r6 5
                jump display_zombie_loop

        pop r10
        pop r9
        pop r8
        pop r7
        pop r6
        pop r5
        pop r4
        pop r3
        pop r2
        pop r1
        
        reti





; Args: r0: y
; Args r1   x
; return: r0: indice plante ou -1 si pas sur une plante
quelle_plante :
	skip 1 ifne r0 -1	;hors de l'écran
	jump pas_plante		
	skip 1 ifne r1 -1	;hors de l'écran
	jump pas_plante
	skip 1 ifle r0 43	;trop bas
	jump pas_plante
	skip 1 ifge r0 4	;trop haut
	jump pas_plante
	skip 1 ifge r1 75	;trop à gauche
	jump pas_plante
	skip 1 ifle r1 348	;trop à droite
	jump pas_plante
	skip 2 ifgt r1 113	;si trop à droite pour être le tournesol
	copy r0 0
	jump quelle_plante_fin
	skip 1 ifge r1 122	;entre tournesol et pisto-pois
	jump pas_plante
	skip 2 ifgt r1 159	;pisto-pois ? 
	copy r0 1
	jump quelle_plante_fin	
	skip 1 ifge r1 171	;entre pistopois et cerise
	jump pas_plante
	skip 2 ifgt r1 208 	;cerise ? 
	copy r0 2
	jump quelle_plante_fin	
	skip 1 ifge r1 218	;entre cerise et double pistopois
	jump pas_plante
	skip 2 ifgt r1 255	;double pistopois ? 
	copy r0 3
	jump quelle_plante_fin
	skip 1 ifge r1 266	;entre double pistopois et noix
	jump pas_plante
	skip 2 ifgt r1 300	;noix  ? 
	copy r0 4
	jump quelle_plante_fin
	skip 1 ifge r1 312	;entre noix et mine 
	jump pas_plante
	skip 2 ifgt r1 348	;mine ? 
	copy r0 5
	jump quelle_plante_fin
	jump pas_plante


	
pas_plante :
	copy r0 -1

quelle_plante_fin :
	ret

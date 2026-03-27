; toute les fonction: R0: coordonée x
;                     R1: coordonée y

action_tournesol:
        let r0 store_game_vars
        load r1 [r0]
        add r1 r1 25
        store [r0] r1
        ret

action_pistopois:
        push r6

        let r2 store_zombies
        umull r1 r1 400
        add r1 r1 r2

        copy r2 -1;ptr
        copy r3 -1;distance
        copy r4 0;conteur
pistopois_loop_min:
        load r5 [r1]
        skipto pistopois_loop_continue ifeq r5 -1 ; no zombie
        load r5 [r1+8]
        skipto pistopois_loop_continue iflt r5 r0 ; zombie on the left
        load r6 [r1+12]
        lsl r5 r5 7
        add r5 r5 r6
        skipto pistopois_loop_continue ifugt r5 r3 ; a nearer one was found previously
        copy r3 r5
        copy r2 r1
pistopois_loop_continue:
        add r4 r4 1
        skipto pistopois_loop_end ifge r4 20
        add r1 r1 20
        jump pistopois_loop_min
pistopois_loop_end:
        skipto pistopois_end ifeq r2 -1
        load r3 [r2+4]
        sub r3 r3 10
        store [r2+4] r3
        skipto pistopois_end ifgt r3 0
        copy r3 -1
        store [r2] r3

pistopois_end:
        pop r6
        ret

fonction_null:
        ret

action_cerise:
        let r2 store_plantes
        umull r3 r1 9
        add r3 r3 r0
        umull r3 r3 12
        add r2 r3 r2
        copy r3 -1
        store [r2] r3 ; the cerise diseapear

        let r2 store_zombies
        umull r3 r1 400 ; 4 bytes * 5 champs * 20 zombies par ligne
        add r2 r2 r3
        copy r5 r2
        call kill_line
        skip 2 ifle r1 0
                sub r2 r5 400
                call kill_line
        skip 2 ifge r1 4
                add r2 r5 400
                call kill_line
        ret

;designed to be used only from action_cerise (eg registers usage)
kill_line:

        copy r3 0

kill_line_loop:
        load r4 [r2+8]
        sub r4 r4 1
        skipto kill_line_continue ifgt r4 r0
        add r4 r4 2
        skipto kill_line_continue iflt r4 r0
        copy r4 -1
        store [r2] r4

kill_line_continue:
        add r3 r3 1
        add r2 r2 20
        skip 1 ifge r3 20
                jump kill_line_loop
        ret


action_mine_charge:
        copy r2 r1
        copy r1 r0
        copy r0 6 ; id de la mine chargée
        jump create_plante

action_mine_boom:

        let r2 store_zombies
        umull r1 r1 400 ; 4 bytes * 5 champs * 20 zombies par ligne
        add r1 r1 r2

mine_boom_find_nearest_zombie:
        ;this loop assume we do find a zombie: it must exist as the one who killed us!
        load r2 [r1]
        skipto mine_boom_find_continue ifeq r2 -1
        load r2 [r1+8]
        skipto mine_boom_find_continue ifne r0 r2
        load r2 [r1+12]
        skipto mine_boom_kill ifle r2 40 
mine_boom_find_continue:
        add r1 r1 20
        jump mine_boom_find_nearest_zombie
        
mine_boom_kill:
        copy r0 -1
        store [r1] r0
        ret

;Args: R0,R1, transférés
;R2: fn ptr
call_by_ptr:
        push r2  ;jump to r2 by absolute address
        ret      ;this is ugly but "it work TM"

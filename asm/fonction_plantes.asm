; toute les fonction: R0: coordonée x
;                     R1: coordonée y

action_tournesol:
        let r0 store_game_vars
        load r1 [r0]
        add r1 r1 25
        store [r0] r1
        ret

action_pistopois:
        ; TODO attaque 10
        ret

fonction_null:
        ret

action_cerise:
        ; TODO explosion 3*3
        ret

action_mine_charge:
        let r2 store_plantes
        umull r1 r1 9
        add r0 r0 r1
        umull r0 r0 12
        add r0 r0 r2
        let r1 6
        store [r0] r1
        store [r0+4] r1
        ret

action_mine_boom:
        ; todo tue 1 zombie
        ret

;Args: R0,R1, transférés
;R2: fn ptr
call_by_ptr:
        push r2  ;jump to r2 by absolute address
        ret      ;this is ugly but "it work TM"

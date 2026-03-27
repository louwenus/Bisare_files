
; stores
; game_vars:
;    - nb_soleil
;    - plante selectionné
;    - selection x
;    - selection y
;    - dernière gen naturelle de soleil
;    - render? (divide fpr by 2 to consume less cpu for printing)
;    - pseudo random
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
; zombies: 20 zombies par line * 5 line
;     - id
;     - vie
;     - x case
;     - x in case
;     - next_action
; zombie_data
;     - sprite ptr
;     - vie
;     - dégats
;     - freq_atq
;     - speed (en ms/pix)

store_game_vars:
        d 50
        d -1 ; TODO: put a -1 back
        d -1
        d -1
        d 6000
        d 1
        d 0x1C5A2F7E

store_plantes_data:

        ; tournesol
        d picture_tournesol
        d 50
        d action_tournesol
        d 24000
        d 125
        d fonction_null
        
        ;pistopois
        d picture_pistopois
        d 100
        d action_pistopois
        d 1000
        d 125
        d fonction_null

        ;cerise
        d picture_cerise
        d 150
        d action_cerise
        d 1000
        d 1000
        d fonction_null

        ;double_pistopois
        d picture_double_pistopois
        d 200
        d action_pistopois
        d 500
        d 125
        d fonction_null
        
        ;noix
        d picture_noix
        d 50
        d fonction_null
        d 10000
        d 1500
        d fonction_null

        ;mine
        d picture_mine_dechargee
        d 25
        d action_mine_charge
        d 16000
        d 125
        d fonction_null

        ;

        ;mine_chargée
        d picture_mine_chargee
        d 0
        d fonction_null
        d 10000
        d 1
        d action_mine_boom

store_zombie_data:
        ; usual zombie
        d picture_zombie
        d 100
        d 25
        d 500
        d 80
        
        ; zombie casque
        d picture_zombie_casque
        d 290
        d 25
        d 500
        d 80

        ;fast zombie
        d picture_zombie_rapide
        d 100
        d 30
        d 600
        d 40
        

store_plantes:
        d -1 ; id
        d -1  ; vie
        d -1  ; next_interaction
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
        d -1
       
store_zombies:
        d -1
        d -1
        d -1
        d -1
        d -1

        d 0
        d 0
        d 8
        d 65
        d 0

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d 2
        d 0
        d 8
        d 65
        d 0

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d 1
        d 0
        d 8
        d 63
        d 0



; stores
; game_vars:
;    - nb_soleil
;    - plante selectionné
;    - selection x
;    - selection y
;    - dernière gen naturelle de soleil
;    - render? (divide fpr by 2 to consume less cpu for printing)
;    - pseudo random
;    - next vague
;    - dernière ligne utilisée
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
; zombies: 20 zombies per line * 5 line
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
; vagues
;     - timer d'apparition
;     - spread
;     - nombre de zombie normaux
;     - nombre de zombie casque
;     - nombre de zombie rapide

store_game_vars:
        d 50
        d -1 ; TODO: put a -1 back
        d -1
        d -1
        d 6000
        d 1
        d 0x1C5A2F7E
        d store_vagues
        d 0

store_plantes_data:

        ; tournesol 0
        d picture_tournesol
        d 50
        d action_tournesol
        d 1000
        d 125
        d fonction_null
        
        ;pistopois 1
        d picture_pistopois
        d 100
        d action_pistopois
        d 1000
        d 125
        d fonction_null

        ;cerise 2
        d picture_cerise
        d 150
        d action_cerise
        d 1000
        d 1000
        d fonction_null

        ;double_pistopois 3
        d picture_double_pistopois
        d 200
        d action_pistopois
        d 500
        d 125
        d fonction_null
        
        ;noix 4
        d picture_noix
        d 50
        d fonction_null
        d 10000
        d 1500
        d fonction_null

        ;mine 5
        d picture_mine_dechargee
        d 25
        d action_mine_charge
        d 16000
        d 125
        d fonction_null

        ;

        ;mine_chargée 6
        d picture_mine_chargee
        d 0
        d fonction_null
        d 10000
        d 1
        d action_mine_boom

        ; tournesol_gen 7
        d picture_tournesol_gen
        d 50
        d action_tournesol_gen
        d 23000
        d 125
        d fonction_null
        

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

store_vagues:
        d 25000
        d 0
        d 1
        d 0
        d 0

        d 50000
        d 0
        d 1
        d 0
        d 0

        d 75000
        d 0
        d 1
        d 0
        d 0

        d 90000
        d 0
        d 0
        d 1
        d 0

        d 120000
        d 0
        d 0
        d 0
        d 1

        d 122500
        d 2
        d 1
        d 1
        d 0

        d 125000
        d 1
        d 1
        d 1
        d 0

        d 181000
        d 1
        d 1
        d 1
        d 0

        d 182500
        d 1
        d 4
        d 1
        d 1

        d 240000
        d 0
        d 0
        d 0
        d 1

        d 243000
        d 2
        d 1
        d 0
        d 1

        d 244500
        d 0
        d 0
        d 1
        d 1

        d 245800
        d 0
        d 2
        d 0
        d 1

        d 312000
        d 1
        d 2
        d 2
        d 1

        d 333000
        d 0
        d 0
        d 2
        d 1

        d -1

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

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1



        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1

        d -1
        d -1
        d -1
        d -1
        d -1


	copy sp 1000		;initialization of the top of the stack
	copy r0 240		;x1
	copy r1 320		;y1
	copy r2 0		;x2
	copy r3 640		;y2
	call ligne
	halt


	
ligne :
	sub r4 r2 r0		;dx
	skip 1 ifne r4 0	;si dx != 0
		jump dx_nul		;si dx = 0, passer à dx_nul
		skip 1 ifgt r4 0	;si dx > 0
			jump dx_le_0		;dx =< 0
			sub r5 r3 r1		;calcul dy
			skip 1 ifne r5 0
			jump dy_nul
			skip 1 ifgt r5 0	;dy > 0
				jump dy_neg	;on va au cas dy =< 0 
				skip 1 ifge r4 r5	;dx >= dy
				jump dx_infs_dy
				copy r6 r4 	;e
				lsl r6 r6  1
				copy r4 r6
				lsl  r5 r5 1

ligne_loop1 : 			;déplacements horizontaux
	call affiche_pixel	;on affiche le pixel
	add r0 r0 1		;on met à jour x1
	skip 1 ifne r0 r2	;on vérifie que x1 != x2
	jump ligne_fin
	sub r6 r6 r5		;on met à jour e
	skip 1 iflt r6 0	;si e < 0, on met à jour y1 et e
	jump ligne_loop1
	add r1 r1 1
	add r6 r6 r4
	jump ligne_loop1


dx_infs_dy :			;on est dans le cas oblique proche vertical
	copy r6 r5		;on définit e
	lsl r6 r6 1		;on le multiplie par 2
	copy r5 r6
	lsl r4 r4 1		;on multiplie dx par 2
ligne_loop2 :
	call affiche_pixel
	add r1 r1 1
	skip 1 ifne r1 r3
	jump ligne_fin
	sub r6 r6 r4
	skip 1 iflt r6 0
	jump ligne_loop2
	add r0 r0 1
	add r6 r6 r5
	jump ligne_loop2
	
	;; dy est négatif
dy_neg :
	copy r7 0
	sub r7 r7 r5 		;on calcule -dy
	skip 1 ifge r4 r7	;on exécute si dx >= -dy
	jump dx_inf_moins_dy
	copy r6 r4		;définition de e
	lsl r6 r6 1
	copy r4 r6
	lsl r5 r5 1
ligne_loop3 :
	call affiche_pixel	;on affiche
	add r0 r0 1
	skip 1 ifne r0 r2	;on s'arrête si x1 = x2
	jump ligne_fin
	add r6 r6 r5
	skip 1 iflt r6 0	;on met à jour si e < 0 
	jump ligne_loop3
	sub r1 r1 1
	add r6 r6 r4
	jump ligne_loop3

	
	;; dx inf à -dy

dx_inf_moins_dy : 		;apparemment oblique 7eme octant
	copy r6 r5		;définition de e
	lsl r6 r6 1
	copy r5 r6
	lsl r4 r4 1
ligne_loop4 	:
	call affiche_pixel	;on affiche le pixel
	sub r1 r1 1		
	skip 1 ifne r1 r3
	jump ligne_fin
	add r6 r6 r4
	skip 1 ifgt r6 0
	jump ligne_loop4
	add r0 r0 1
	add r6 r6 r5
	jump ligne_loop4

	;; dy = 0
	
dy_nul :
	call affiche_pixel
	add r0 r0 1
	skip 1 ifeq r0 r2
	jump dy_nul
	jump fin


	;; ON ARRIVE À dx < 0 
dx_le_0 :
	sub r5 r3 r1		;dy
	skip 1 ifne r5 0	;dy != 0 
	jump dy_eq_0
	skip 1 ifgt r5 0 	;si dy > 0
	jump dy_inf_0 
	copy r7 0
	sub r7 r7 r4		;-dx
	skip 1 ifge r7 r5
	jump moins_dx_inf_dy	;cas -dx >= dy 
	copy r6 r4 		;e
	lsl r6 r6 1
	copy r4 r6
	lsl r5 r5 1
ligne_loop5 :	
	call affiche_pixel
	sub r0 r0 1
	skip 1 ifne r0 r2
	jump ligne_fin 
	add r6 r6 r5
	skip 1 ifge r6 0
	jump ligne_loop5
	add r1 r1 1
	add r6 r6 r4
	jump ligne_loop5

	;; cas -dx < dy
moins_dx_inf_dy :
	copy r6 r5
	lsl r6 r6 1		;on a défini e
	copy r5 r6
	lsl r4 r4 1

ligne_loop6 :
	call affiche_pixel
	add r1 r1 1
	skip 1 ifne r1 r3
	jump ligne_fin 
	add r6 r6 r4
	skip 1 ifle r6 0
	jump ligne_loop6
	sub r0 r0 1
	add r6 r6 r5
	jump ligne_loop6

	;; cas dy < 0 
dy_inf_0 :
	skip 1 ifle r4 r5
	jump dx_sup_dy
	copy r6 r4		;def de e
	lsl r6 r6 1
	lsl r5 r5 1
	copy r4 r6
	
ligne_loop7 :
	call affiche_pixel
	sub r0 r0 1
	skip 1 ifne r0 r2
	jump ligne_fin 
	sub r6 r6 r5
	skip 1 ifge r6 0
	jump ligne_loop7
	sub r1 r1 1
	add r6 r6 r4
	jump ligne_loop7

dx_sup_dy :
	copy r6 r5		;def de e
	lsl r6 r6 1
	copy r5 r6
	lsl r4 r4 1

ligne_loop10 :
	call affiche_pixel
	sub r1 r1 1
	skip 1 ifne r1 r3
	jump ligne_fin 
	sub r6 r6 r4
	skip 1 ifge r6 0
	jump ligne_loop10
	sub r0 r0 1
	add r6 r6 r5
	jump ligne_loop10

dy_eq_0 :
	call affiche_pixel
	sub r0 r0 1
	skip 1 ifne r0 r2
	jump ligne_fin
	jump dy_eq_0

dx_nul :
	sub r5 r3 r1		;déligne_finition de dy
	skip 1 ifne r5 0 	;si dy != 0
	jump ligne_fin
	skip 1 ifgt r5 0	;si dy > 0
	jump dy_less_0
ligne_loop8 :
	call affiche_pixel
	add r1 r1 1
	skip 1 ifne r1 r3
	jump ligne_fin
	jump ligne_loop8

dy_less_0 :			;dy < 0 
	call affiche_pixel
	sub r1 r1 1
	skip 1 ifne r1 r3
	jump ligne_fin
	jump dy_less_0	
	
ligne_fin :
	ret
	
	
affiche_pixel :			;on va afficher le point aux coordonnées x1 y1
	let r10 0x01000000	;point en haut à gauche
	push r4
	push r5
	push r7
	copy r4 r0
	copy r5 r1
	lsl r4 r4 2		;on multiplie x1 par 4
	lsl r5 r5 2		;on multiplie x2 par 4
	copy r7 r4		;on va maintenant trouver la bonne coordonnée
	lsl r7 r7 9
	lsl r4 r4 7
	add r4 r4 r7
	add r4 r4 r5
	add r10 r10 r4
	copy r5 -1
	store [r10] r5
	pop r7
	pop r5
	pop r4
	ret

# Plant VS Zombie

Groupe: Louwen et Isaure

Un niveau de plante versus zombie.

On peut placer des plantes a l'aide de la souris (cliquez sur la plante puis sur la case ou placer), si l'on possède les soleil nécessaires

Empechez les zombies d'arriver chez vous !


# Lancer le jeu:

L'utilisation de make permet de regénérer le fichier assembleur a partir des ressources,
de compiler la dernière version du simulateur et de l'assembleur, puis d'assembler et de lancer la simulation

## Sous mac trop vieux qui n'as pas de futex

utilisez la commande `make apple` ou `make appledebug`

## Sous linux

utilisez la commande `make` ou `make debug`

## Si make ne marche pas

Des fichiers de secours (assembleur et binaire) sont disponible, (secours.asm et secours.bin) mais ils risquent d'être un peu moche


# Petites entorses aux consignes

Ce projet fait 3 petites entorse au consigne (sous la forme de deux modification au simulateur python/cbisare sans arguments qui sont utilisée)

- Utilisation du MMIO de la souris (c'est plus pratique que le clavier tout de même)

- L'écran au format rgb plutôt que bgr (ne change pas grand chose, mais plus naturel a debug / faire un convertisseur depuis de vraies images)

- Les intéruptions sont utilisées pour les choses suivantes:
  - Évite de devoir pool régulierement la souris / evite du flicker a l'affichage
      (pur confort visuel, peut se remplacer par des appels au routine de gestion d'affichqge et entrée dans la boucle principale)
  - Rattraper les opérations non supportées (div/mul) et faire appel à une fonction pour faire l'opération
      ( petit confort d'écriture de l'ASM, peut se remplacer par des appels direct au fonction correspondante, dans asm/base.asm )


# Pour le DM

- 1
  Les implémentation de multiplication / division sont disponible dans le fichier asm/base.asm
- 2
  La plupart des routines graphiques sont disponibles dans asm/graphic.asm, a l'exeption des lignes, non utilisées dans le rendu final (asm/bresenham.asm)
- 3
  Le rendu final est dispersé dans les autres fichier asm (assemblé par make). Une version pré assemblé et disponible dans les fichier de secours

Le simulateur et l'assembleur utilisé sont ceux de Louwen, disponible ici: https://gitea.jthillard.fr/mwa/bisare_sim_rs

Un programme de transformation image > asm, video > asm, ainsi que quelques script python de manipulation d'image on également été utiliser dans ce projet
Il sont disponibles ici:
  ./bitmap_to_asm  transformation image > assembleur
  ./video_to_asm   transformation video > assembleur  (voir bad apple ci dessous)
  ./pictures/mkfont.py   transfomration dont > image
  

# Deuxième programme
Il y a un second programme disponible dans cette archive, un player de Bad Apple.
Le décodeur est présent dans asm/bad_apple.asm.

On peut le lancer avec `make bad_apple` ou `make bad_apple_mac` (fichier de secours dans secours_bad_apple.asm et secours_bad_apple.bin)

un peu moins d'entorse ici, juste utilisation des interruptions pour eviter le screen tearing / jouer la video trop rapidement.
(aurait pu être remplacé par une boucle et une attente active / avec timer)

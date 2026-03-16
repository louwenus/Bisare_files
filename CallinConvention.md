registre 0 à 5:
    utilisés pour passer/retourner des arguments.
   toujours en caller save (y compris les arguments, que la fonction appelée a le droit de modifier)
registre 6 à 15:
    toujours en calee save

donc, pour appeler un fonction:

on push sur la stack le contenu des registres 0 à 5 si on veut conservé leur valeur après l'appel
on push sur la stack, en ordre inverse, les arguments au delà du 6ème
on utilise call
on pop les arguments au dela du 6ème
//on alors le retour de fonction dans les registres 0 à 5, ou des valeurs non determinée.
//on a également les éventuelles valeurs sauvegardée dans les registres 0-5 sur la stack, il ne faut pas les oublier


quand on est une fonction qui vient de se faire appeler:
//nos 6 premiers arguments sont sur les registres 0-5
//les éventuels arguments supplémentaires sont sur la stack (a partir de sp-4, puisque la dernière chose poussé est le pointeur de retour de fonction par call)
on push sur la stack les registres 6-15 si on décide de les utiliser dans notre fonction (si on n'en a pas besoin, on n'est pas obligé).
Si on a besoin des arguments supplémentaires (sur la stack), on récupère SP dans un autre registre, et on calcule où sont les arguments
(SP- 4 * (nombre de push dans cette fonction + 1 (pour call) + (indice de l'argument - 6 (car les 6 premiers sont dans les registres))
Si on a besoins de plus de place pour des variables temporaires, on peut augmenter SP et utiliser l'espace nouvellement libéré

//on exécute notre fonction

on met le retour de fonction dans les registres 0-5
Si on a pris de l'espace supplémentaire, on rediminue SP
Si on a sauvegardé certains registres entre 5 et 15, on les pop (dans l'ordre inverse des push)
on ret
 

NB: on ne peut pas retourner plus que 6 valeurs.
Si jamais on a vraiment besoin de retourner plus que 6 valeurs, l'appelant nous donne en argument un pointeur sur l'endroit ou il faut les sauvegarder

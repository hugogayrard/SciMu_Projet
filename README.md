# ANALYSE TRANSITION

- Analyse_transition_programme_principal.m :
	* Parcours tous les fichiers .lab d'un artiste donné pour obtenir les structures (succession de segments) de toutes les chansons. Ce programme calcule la matrice de transition puis l'enregistre (pour pouvoir l'utiliser dans la partie élongation musicale).

- rang.m :
	* Permet de calculer l'indice correspondant à un segment dans la matrice. Par exemple, 'silence' renvoie l'indice 0.

- Le dossier Exemples contient les matrices de transition créées pour certains artistes.

# ELONGATION CHANSONS

- Elongation_chansons_programme_principal.m :
	* A partir de la chanson originale (dont la structure est contenue dans un fichier du dossier The_Beatles_segmentation) et d'un temps souhaité, le programme fait appel à AlgoChoix.m pour obtenir la structure de la chanson élonguée. 
	La chanson est alors créée en faisant appel aux fonctions du dossier fonctions_sons. Ensuite, la chanson est enregistrée au format .wav. 
	Enfin, un affichage permet de comparer la structure de la chanson allongée à celle de la chanson originale.

- AlgoChoix.m :
	* Utilise une matrice de transition pour calculer la succession de segments de la chanson allongée en commençant par le premier segment de la chanson initiale. 
	Les probabilités sont ajustées pour viser le temps voulu et éviter des "culs-de-sac" (exemple : outro apparaît prématurément).

- rang.m :
	* Permet de calculer l'indice correspondant à un segment dans la matrice. Par exemple, 'silence' renvoie l'indice 0.	

- Dossier fonctions_sons :
	* Ensemble de fonctions permettant de créer la chanson allongée (pour obtenir le son) à partir de sa structure et de la chanson initiale.
	AssemblageTotal.m permet d'assembler tous les segments entre eux en faisant appel à Assemblage.m qui assemble les segments 2 à 2. Les fonctions fadeIn et fadeOut peuvent être appelées pour obtenir des transitions triangles entre chaques segments.

- Dossier The_Beatles_segmentation :
	* Contient les structures (segmentations et temps associés) de quelques chansons des Beatles.

- Dossier Exemples :
	* Contient pour quelques chansons des Beatles la chanson originale, la chanson allongée (environ 4min) ainsi que le graphique comparant leurs structures.


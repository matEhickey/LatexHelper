#LatexHelper

Generateur de fichier latex/Beamer en Ruby/GTK2

#Lancer le logiciel:
Dans un terminal:
"ruby generateur.rb"

#Generation du pdf:
"pdflatex (nom du fichier).tex"
	(C'est un logiciel encore inachevé, il faudra surement taper plusiuers fois la touche entrée)


#Fonctionnalités presentes
-Modification du type (article, beamer etc)
-Ajout d'image
-Optimisation beamer
-Previsualisation (un lexeme est supprimable, mais la fonctionnalité n'es pas achevé(les fins de clauses sont non suprrimés), ne pas l'utiliser pour un travail serieux, ou retoucher le fichier .tex)
-Sauvegarde/reprise (ctrl+O n'est pas encore fini, il faut taper le nom souhaiter et clicker ouvrir)

#A faire
-Debuggage supression lexeme (regles hierarchisés, l'ajout de languages sera possible (html etc))
-previsualisation image
-interdiction de generer si champs non remplis
-Fommules mathematique
-Fenetre choix couleurs pour les elements beamer / listes de styles
-Autres elements de styles latex (listes etc)


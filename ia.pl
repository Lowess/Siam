%ia.pl

%findall--> trouve toutes les solutuion si pas de solutions retourne liste vide []

%Quelques soit
findall(Y,(member(X,[1,2,3]), Y is X*2),L).
L=[2,4,6]


%Il existe
bagof(Y,(member(X,[1,2,3]), Y is X*2),L).
setof

X=1 L=[2]
X=2 L=[4]
X=3 L=[6]

%On quantifie en quelquesoit
bagof(Y,X^,(member(X,[1,2,3]), Y is X*2),L).
L=[2,4,6]


findall((X,Y), nth(X, [a,b,c], Y), L).
L=[(1,a), (2,b), (3,c)]

%bagof--> pas de sol echoue,

%setof--> pas de sol echoue, trie et supression de doublons


%PDF 10p environs
%Code
%Imprimer version papier

%expliquer la représentation du plateau
%expliquer coup possible
%expliquer l\'IA

trace,
notrace,
s --> ne rentre pas dans un predicat

spy(nom_predicat(/arite)). place un breackpoint sur le predicat
nospy(nom_predicat(/arite)).
nospyall.
debug. active le debuger
nodebug.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%liste coup poussible avec heuristiques
%se prémunir de la défaite


%Algo minimax

%considérer tous les coups possibles pour le joueur courant

%			min si favorable aux rhinos						
%evaluation du plateau
%			max si favorable aux ele


%(nb montagne sur le bord)
%(nb de montagne poussable)
%(nb pions en dehors)

%On choisit de tracer l'arbre du jeu et de l'évaluer à une certaine profondeur

%donner une valeur numérique au plateau

%l'un joue les coups max, l'autre les coups min


%Utiliser des heuristiques de jeux
%On va gagner

%evaluer les coups dont on pense que le plateaux vont etre médiocre



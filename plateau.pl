%%% Quelques prédicats

% change_directory('/home/florian/Documents/UTC/IA02/Projet').
% [projet].
% :- include(fichier).
% write('test').
% nl.

%%%%Convention d'écriture

% Prédicat(+variable) = variable en input
% Prédicat(-variable) = variable en output
% Prédicat(?variable) = variable en input ou output

%%% Constantes possibles pour orientation : n, s, w, e

%%% Prédicats utils

% length
% append
% member
% memberchk
% reverse
% delete
% select
% last
% nth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%plateau_test
% différents plateaux de siam possible en cours de partie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plateau_test(
	[
		[(11,n),(44,s),(13,w),(14,e),(15,n)],
		[(0,s),(34,s),(53,w),(54,e),(55,n)],
		[21,31,41],
		e
	]).

plateau_test([
		[(0,0),(0,0),(0,0),(0,0),(0,0)],
		[(0,0),(0,0),(0,0),(0,0),(0,0)],
		[0,0,0],
		e	
	]).

plateau_test(
	[
		[(0,0),(0,0),(0,0),(0,0),(0,0)],
		[(0,0),(0,0),(0,0),(0,0),(0,0)],
		[32,33,34],
		e
	]).

plateau_test(
	[
		[(11,n),(12,s),(13,w),(14,e),(15,n)],
		[(51,n),(52,s),(53,w),(54,e),(55,n)],
		[32,33,34],
		e
	]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Affiche ligne
% Permet l'affichage de NbCases du plateau P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

affiche_ligne(Numero, 0 , P):- 	!.

affiche_ligne(Numero, NbCases, P):-	TmpCases is NbCases - 1,
					affiche_ligne(Numero, TmpCases, P),						
					Case is Numero*10 + NbCases,
					affiche_contenu(Case, P),
					write('  |  ').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Affiche lignes
% Permet l'affichage de NbLignes du plateau P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

affiche_lignes(0, NbCases, P):- 	!, 
				write('     |-------|-------|-------|-------|-------|'), 
				nl,
				write('         1       2       3       4       5    '),
				nl.
				
				


affiche_lignes(NbLignes, NbCases, P):-	TmpLignes is NbLignes - 1,
					write('     |-------|-------|-------|-------|-------|'), 
					nl,
					write('  '),
					write(NbLignes),
					write('  |  '),		
					affiche_ligne(NbLignes, NbCases, P),
					nl,								
					affiche_lignes(TmpLignes, NbCases, P),
					!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Test le contenu de la case
%elephant s'efface si la case Case contient un éléphant
%rhinocéros s'efface si la case Case contient un rhinocéros
%montagne s'efface si la case Case contient une montagne
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elephant([E|_],Case) :- 	member((Case,_),E).
rhinoceros( [_,R|_], Case) :- 	member((Case,_),R).
montagne( [_,_,M,_], Case) :- 	member(Case,M).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Afficher contenu 
%Affiche le contenu d'une case C d'un plateau P
%Le contenu d'une case peut être:
%	Elephant	<=> e
%	Rhinocéros	<=> r
%	Montagne	<=> M
%	Vide		<=> espace
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

affiche_contenu(C, P) :-	elephant(P, C),
				!,
				afficher_elephant,
				afficher_orientation(P,C,O).

affiche_contenu(C, P) :-	rhinoceros(P,C),
				!,
				afficher_rhinoceros,
				afficher_orientation(P,C,O).

affiche_contenu(C, P) :-	montagne(P,C),
				!,
				afficher_montagne.

affiche_contenu(C, P) :-	!, write('   ').

afficher_elephant :-	write('e '). %write('(}.l.{)'). 

afficher_rhinoceros :-	write('r '). %write(' ].J.[ '). 

afficher_montagne :-	write(' M '). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Afficher orientation
%Affiche un signe ^ v > < selon l'orientation respective N S E W
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

transcrit(n) :- write('^').
transcrit(s) :- write('v').
transcrit(e) :- write('>').
transcrit(w) :- write('<').

					
afficher_orientation([E|_], C, O) :- 	member((C,O),E),
					transcrit(O).

afficher_orientation([_,R|_], C, O) :- 	member((C,O),R),
					transcrit(O).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Get Orientation
%Retourne l'orientation d'un pion d'une case C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_orientation([E|_], C, O) :- 	member((C,O),E), !.

get_orientation([_,R|_], C, O) :- 	member((C,O),R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Afficher joueur
%Affiche le nom du joueur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

afficher_joueur([_,_,_,J], J).	
				

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Nombre de pièce restantes
%Prends en paramètre soit une liste d'éléphant soit une liste de rhinocéros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nombre_pieces_restantes([],0):- !.
nombre_pieces_restantes([(0,0)|Q],Nb):- 	nombre_pieces_restantes(Q,Tmp),
						!,
						Nb is Tmp + 1.
nombre_pieces_restantes([(_,_)|Q],Nb):- 	nombre_pieces_restantes(Q,Tmp),
						!,
						Nb is Tmp + 0.
					
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Afficher plateau	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

afficher_plateau([E,R,M,J]) :- 	affiche_lignes(5,5, [E,R,M,J]), %Affiche le plateau 5x5				

				afficher_joueur([E,R,M,J],Jou), %Affiche le nom du joueur
				write('Nom du joueur: '),
				write(Jou), nl,
	
				nombre_pieces_restantes(R,NbEle), %Affiche le nombre d'éléphants restants
				write('Nombre d\'éléphants à faire entrer en jeu: '),  
				write(NbEle), nl,

				nombre_pieces_restantes(E,NbRhi), %Affiche le nombre de rhinocéros restants
				write('Nombre de rhinocéros à faire entrer en jeu: '),
				write(NbRhi), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Test fin de partie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
/*

	########################################
	### ELEMENTS DEPLACES DANS humain.pl ###
	########################################
*/
/*
%dynamic(plateau_en_cours/1).
%asserta(plateau_en_cours(P)).	

%plateau_depart([
%		[(0,0),(0,0),(0,0),(0,0),(0,0)],
%		[(0,0),(0,0),(0,0),(0,0),(0,0)],
%		[32,33,34],
%		e
%	]).
%	
%dynamic(plateau_en_cours/1).
%asserta(plateau_en_cours(P)).	
	
%coup_possible(P, (D,A,O)) :- repeat,
%							write('Choisissez votre pion'),
%							nl,
%							read(D),
%							verifier_depart(D, P),!,
%							repeat,
%							write('Choisissez la case d\'arrivée'),
%							read(A),
%							verifier_arrivee(A, P),!,
%							write('Choisissez l\'orientation de votre pion'),
%							read(O),
%							verifier_orientation(O).
%
%fin_partie([_,_,M,_]) :- montagne_out(M), !.
%fin_partie(_) :- fail.
%montagne_out([]) :- fail.
%montagne_out([M,_,_]) :- M = 0, !.
%montagne_out([_,M,_]) :- M = 0, !.
%montagne_out([_,_,M]) :- M = 0, !.
%montagne_out(_) :- fail.
*/

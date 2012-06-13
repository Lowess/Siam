%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       HUMAIN.PL                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- include('plateau.pl').
:- dynamic(plateau_courant/1).
:- multifile(plateau_courant/1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Vérifie que la case appartient au plateau
case_valide(0).
case_valide(Case) :- 	Case > 10, Case < 56,
			T is Case mod 10,
			T < 6, T > 0.
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Vérifie que le joueur manipule ses pions
verifier_depart(0, P) :- nombre_pieces_restantes(P, NbAnimaux), NbAnimaux > 0.
verifier_depart(0, P) :- nombre_pieces_restantes(P, NbAnimaux), NbAnimaux > 0.

%Si joue les elephants
verifier_depart(Depart,Plateau) :-	case_valide(Depart),
					afficher_joueur(Plateau,Joueur),
					Joueur=e,
					elephant(Plateau,Depart), 
					!.
%Si joue les rhinoceros
verifier_depart(Depart,Plateau) :-	case_valide(Depart),
					afficher_joueur(Plateau,Joueur),
					Joueur=r,
					rhinoceros(Plateau,Depart), 
					!.

verifier_depart(_,_) :-	write('Vous n\'avez pas le droit de manipuler les pions de votre adversaire...'),
			nl,
			fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Vérifie que la case arrivée est vide + coup autorisé

%Arrivée par le nord
verifier_entree_plateau(Arrivee) :-   	Depart is Arrivee // 10,
					Depart=5, !.

%Arrivée par le sud					
verifier_entree_plateau(Arrivee) :-   	Depart is Arrivee // 10,
					Depart=1, !.

%Arrivée par l'ouest
verifier_entree_plateau(Arrivee) :-   	Mod is Arrivee mod 10,
					Mod=5, !.

%Arrivée par l'est
verifier_entree_plateau(Arrivee) :-   	Mod is Arrivee mod 10,
					Mod=1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verifier_deplacement_plateau(-1).
verifier_deplacement_plateau(1).
verifier_deplacement_plateau(-10).
verifier_deplacement_plateau(10).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ne peut laisser son pion hors du jeu car obligation de changer l'orientation
%de la pièce si celle-ci ne change pas de case
verifier_arrivee(0,0,_,_,[]) :-	write('Vous etes obliges d\'effectuer un deplacement'),
								fail.

%Entrée sur plateau sur une case vide
verifier_arrivee(0,Arrivee,Orientation,Plateau,[]) :-	
							write('Verification case arrivee pour Entree sur case vide'), nl,
							case_valide(Arrivee),
							verifier_case_vide(Arrivee,Plateau),!,
							%test maintenant la validité du coup
							verifier_entree_plateau(Arrivee), 
							!.
							
%Entrée sur plateau avec poussée
verifier_arrivee(0, Arrivee, Orientation, Plateau, Historique) :-
							write('Verification case arrivee pour Entree sur plateau avec poussee'), nl,
							%verification que la case d'arrivée appartient bien au plateau 
							case_valide(Arrivee),
							%test maintenant la validité du coup				
							verifier_entree_plateau(Arrivee),
							%vérifie que l'on pousse avec l'avant du pion
							oriente_pour_pousser(0, Arrivee, Orientation),
							%verifier que la poussée est valide
							poussee_possible(Arrivee,Orientation,Plateau, Historique),
							!.							

%Déplacement sur une case vide
verifier_arrivee(Depart,Arrivee,Orientation,Plateau,[]) :-	
							\+ Depart = 0,
							write('Verification case arrivee pour Deplacement sur case vide'), nl,
							case_valide(Arrivee),
							verifier_case_vide(Arrivee,Plateau),!,
							%Orientationn test maintenant la validité du coup
							%Case Arrivee = Depart +/- 1 OU Depart +/- 10
							Tmp is Depart-Arrivee,
							verifier_deplacement_plateau(Tmp).
							
%Déplacement sur plateau avec poussée
verifier_arrivee(Depart,Arrivee,Orientation,Plateau,Historique) :-	
							\+ Depart = 0,
							write('Verification case arrivee pour Deplacement sur plateau avec poussee'), nl,
							case_valide(Arrivee),
							%Test la validité du coup
							Tmp is Depart - Arrivee,
							verifier_deplacement_plateau(Tmp),
							%verifier que la poussée est valide
							poussee_possible(Arrivee,Orientation,Plateau,Historique).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Vérifie que la case ne contient rien
verifier_case_vide(Case,Plateau) :- 
					\+ elephant(Plateau,Case),
					\+ rhinoceros(Plateau,Case),
					\+ montagne(Plateau,Case).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Retourne vrai si les orientations sont opposées
orientation_opposee(n,Case,Plateau) :- 	get_orientation(Plateau, Case, O),
					!,
					O=s.
orientation_opposee(s,Case,Plateau) :- 	get_orientation(Plateau, Case, O),
					!,
					O=n.
orientation_opposee(w,Case,Plateau) :- 	get_orientation(Plateau, Case, O),
					!,
					O=e.
orientation_opposee(e,Case,Plateau) :- 	get_orientation(Plateau, Case, O),
					!,
					O=w.

%Retourne vrai si les orientations sont identiques
orientation_identique(Orientation,Case,Plateau) :- 	get_orientation(Plateau, Case, O),
							!,
							Orientation=O.

%Conditions d'arrets avec réussite de poussée:
% 	--> 1) On arrive sur une case vide alors la File de poussée est terminée
%	--> 2) On sort du plateau

% 1)
genere_liste_force_masse(Case, _, Plateau, (_,_), []):- verifier_case_vide(Case,Plateau), !.

% 2)
genere_liste_force_masse(Case, _, _, (_,_), []):- \+ case_valide(Case), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Poussée vers le NORD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	--> Poussée d'une montagne
genere_liste_force_masse(Case, n, Plateau, (Force,Masse),[Pion|Historique]):- 
	montagne(Plateau, Case),
	CaseSuivante is Case + 10,
	NewMasse is Masse + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(Force,NewMasse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, n, Plateau, (Force, NewMasse), Historique).

%	--> Poussée d'un animal avec des forces qui s'opposent Ex e--> <--e
genere_liste_force_masse(Case, n, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_opposee(n,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est opposée à la mienne
	CaseSuivante is Case + 10,
	NewForce is Force - 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, n, Plateau, (NewForce, Masse), Historique).

%	--> Poussée d'un animal avec des forces qui s'ajoute e--> e-->
genere_liste_force_masse(Case, n, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_identique(n,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est la meme que la mienne
	CaseSuivante is Case + 10,
	NewForce is Force + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, n, Plateau, (NewForce, Masse), Historique).
%									 ^
%	--> Poussée d'un animal avec des forces qui ne change rien e--> r|
%									 v
genere_liste_force_masse(Case, n, Plateau, (Force,Masse), [Pion|Historique]):- 
	write('Genere liste force masse avec poussee vers nord'), nl,
	CaseSuivante is Case + 10,
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, n, Plateau, (Force, Masse), Historique).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Poussée vers le SUD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	--> Poussée d'une montagne
genere_liste_force_masse(Case, s, Plateau, (Force,Masse),[Pion|Historique]):- 
	montagne(Plateau, Case),
	CaseSuivante is Case - 10,
	NewMasse is Masse + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(Force,NewMasse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, s, Plateau, (Force, NewMasse), Historique).

%	--> Poussée d'un animal avec des forces qui s'opposent Ex e--> <--e
genere_liste_force_masse(Case, s, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_opposee(s,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est opposée à la mienne
	CaseSuivante is Case - 10,
	NewForce is Force - 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, s, Plateau, (NewForce, Masse), Historique).

%	--> Poussée d'un animal avec des forces qui s'ajoute e--> e-->
genere_liste_force_masse(Case, s, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_identique(s,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est la meme que la mienne
	CaseSuivante is Case - 10,
	NewForce is Force + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, s, Plateau, (NewForce, Masse), Historique).
%									 ^
%	--> Poussée d'un animal avec des forces qui ne change rien e--> r|
%									 v
genere_liste_force_masse(Case, s, Plateau, (Force,Masse), [Pion|Historique]):- 
	write('Genere liste force masse avec poussee vers sud'), nl,
	CaseSuivante is Case - 10,
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, s, Plateau, (Force, Masse), Historique).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Poussée vers l'WEST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	--> Poussée d'une montagne
genere_liste_force_masse(Case, w, Plateau, (Force,Masse),[Pion|Historique]):- 
	montagne(Plateau, Case),
	CaseSuivante is Case - 1,
	NewMasse is Masse + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(Force,NewMasse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, w, Plateau, (Force, NewMasse), Historique).

%	--> Poussée d'un animal avec des forces qui s'opposent Ex e--> <--e
genere_liste_force_masse(Case, w, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_opposee(w,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est opposée à la mienne
	CaseSuivante is Case - 1,
	NewForce is Force - 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, w, Plateau, (NewForce, Masse), Historique).

%	--> Poussée d'un animal avec des forces qui s'ajoute e--> e-->
genere_liste_force_masse(Case, w, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_identique(w,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est la meme que la mienne
	CaseSuivante is Case - 1,
	NewForce is Force + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, w, Plateau, (NewForce, Masse), Historique).
%									 ^
%	--> Poussée d'un animal avec des forces qui ne change rien e--> r|
%									 v
genere_liste_force_masse(Case, w, Plateau, (Force,Masse), [Pion|Historique]):- 
	write('Genere liste force masse avec poussee vers ouest'), nl,
	CaseSuivante is Case - 1,
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, w, Plateau, (Force, Masse), Historique).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Poussée vers l'EAST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	--> Poussée d'une montagne
genere_liste_force_masse(Case, e, Plateau, (Force,Masse),[Pion|Historique]):- 
	montagne(Plateau, Case),
	CaseSuivante is Case + 1,
	NewMasse is Masse + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(Force,NewMasse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, e, Plateau, (Force, NewMasse), Historique).

%	--> Poussée d'un animal avec des forces qui s'opposent Ex e--> <--e
genere_liste_force_masse(Case, e, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_opposee(e,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est opposée à la mienne
	CaseSuivante is Case + 1,
	NewForce is Force - 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, e, Plateau, (NewForce, Masse), Historique).

%	--> Poussée d'un animal avec des forces qui s'ajoute e--> e-->
genere_liste_force_masse(Case, e, Plateau, (Force,Masse), [Pion|Historique]):- 
	%\+ montagne(Plateau, Case), %Ce n'est pas une montagne donc 2 animaux
	orientation_identique(e,Case, Plateau), %Orientation du pion de la case sur laquelle je souhaite me déplacer est la meme que la mienne
	CaseSuivante is Case + 1,
	NewForce is Force + 1,
	%Test la validité de la poussée
	!,
	test_force_masse(NewForce,Masse),
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, e, Plateau, (NewForce, Masse), Historique).
	
%									 ^
%	--> Poussée d'un animal avec des forces qui ne change rien e--> r|
%									 v
genere_liste_force_masse(Case, e, Plateau, (Force,Masse), [Pion|Historique]):- 
	write('Genere liste force masse avec poussee vers est'), nl,
	CaseSuivante is Case + 1,
	get_pion(Plateau, Case, Pion),
	genere_liste_force_masse(CaseSuivante, e, Plateau, (Force, Masse), Historique).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Orienté pour pousser:
%On ne peut pousser que par l'avant du pion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Entrée par un des 4 coins du plateau on peut pousser dans 2 directions
oriente_pour_pousser(0, 11, n):- !. % (C1)
oriente_pour_pousser(0, 11, e):- !.

oriente_pour_pousser(0, 15, n):- !.
oriente_pour_pousser(0, 15, w):- !. % (C2)

oriente_pour_pousser(0, 55, s):- !.
oriente_pour_pousser(0, 55, w):- !. % (C3)

oriente_pour_pousser(0, 51, s):- !.
oriente_pour_pousser(0, 51, e):- !. % (C4)


%Entrée par un bord du plateau (les 4 coins étant exclus car traités précédement)
oriente_pour_pousser(0, 12, n):- !.			%	(C4)		(4)		(C3)
oriente_pour_pousser(0, 13, n):- !. 		% (1)		
											%	---------------------------------
oriente_pour_pousser(0, 14, n):- !.			%	|				|
											%	|				|
											%	|				|
oriente_pour_pousser(0, 21, e):- !.			%	|				|
oriente_pour_pousser(0, 31, e):- !. 		% (2)		
											%	|				|
oriente_pour_pousser(0, 41, e):- !.			%	|				|
											%   (2)	|	  PLATEAU DE JEU	| (3)
											%	|				|
oriente_pour_pousser(0, 25, w):- !.			%	|				|
oriente_pour_pousser(0, 35, w):- !. 		% (3)		
											%	|				|
oriente_pour_pousser(0, 45, w):- !.			%	|				|
											%	|				|
oriente_pour_pousser(0, 52, s):- !.			%	|				|
oriente_pour_pousser(0, 53, s):- !. 		% (4)		
											%	|				|
oriente_pour_pousser(0, 54, s):- !.			%	---------------------------------
											%	(C1)		(1)		(C2)

%oriente_pour_pousser(Depart, Arrivee, n).
					    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Poussée Possible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
poussee_possible(Case, Orientation, Plateau, Historique):-
	%On test si notre piece que l'on manipule est dans le sens opposée à la pièce de devant
	%orientation_opposee(Orientation, Case, Plateau),
	genere_liste_force_masse(Case, Orientation, Plateau, (1,0), Historique),
	!.

%poussee_possible(Case, Orientation, Plateau, Historique):-
	%Si notre piece que l'on manipule n'est pas opposée à la notre
%	genere_liste_force_masse(Case, Orientation, Plateau, (1,0), Historique),
%	!.

%Conditions d'arrets avec echec de poussée:
% 	--> 1) (F > 0) AND (F >= M)
test_force_masse(Force, Masse) :- 	Force > 0,
					Force >= Masse.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Coup possible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
%coup_possible(Plateau, (Depart,Arrivee,Orientation), Historique) :- verifier_arrivee(Depart, Arrivee, Orientation, Plateau, Historique),!.

%coups_possibles(Plateau, ListeCoups) :- setof(X, coup_possible(Plateau, X, Historique), ListeCoups).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GESTION DE LA PARTIE DE SIAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Déroulement d'une partie:
% -Création dynamique du plateau de jeu initial
% -Tour de jeu (avec réallocation dynamique du plateau de jeu)
% -Test fin de partie? Si non, on retourne au point de choix créé par repeat, si oui, partie finie.

partie_SIAM :-
			asserta(plateau_courant([
							[(0,0),(0,0),(0,0),(0,0),(0,0)],
							[(0,0),(0,0),(0,0),(0,0),(0,0)],
							[32,33,34],
							e
						])),
			repeat,
			plateau_courant(P),
			tour(P, H, C, NP),
			write('NP : '), write(NP), nl, write('P : '), write(P), nl,
			fin_partie(NP, H, C), !,
			write('La partie est finie.'), nl.

afficher_joueur_courant([_,_,_,e]) :- write('Au tour des elephants de jouer.'), nl.
afficher_joueur_courant([_,_,_,r]) :- write('Au tour des rhinoceros de jouer.'), nl.
				
%Déroulement d'un tour de jeu :
% - Saisie du coup (vérification du joueur, des cases de départ et d'arrivée, si poussée possible.
% - Réallocation du plateau de jeu dynamiquement
% - Affichage du vainqueur si montagne hors du jeu.
					
tour(Plateau, Historique, Coup, NouveauPlateau) :- 
						afficher_plateau(Plateau),
						write('#####################################'), nl,
						write('Tour de jeu'), nl,
						afficher_joueur_courant(Plateau),
						write('#####################################'), nl,
						saisir_coup(Plateau, Coup, Historique),
						jouer_coup(Plateau, Coup, Historique, NouveauPlateau).					

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
							
saisir_coup(Plateau, (Depart, Arrivee, Orientation), Historique) :-	
							repeat,
							write('Choisissez votre pion'), nl,
							read(Depart),
							verifier_depart(Depart, Plateau), !,
							repeat,
							write('Choisissez la case d\'arrivee'), nl,
							read(Arrivee),
							write('Choisissez l\'orientation de votre pion'), nl,
							read(Orientation),
							verifier_arrivee(Depart, Arrivee, Orientation, Plateau, Historique), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

jouer_coup(P, Coup, H, NP) :- 	
				write('Modifier le plateau en fonction du coup joue'), nl,
				modifier_plateau(P, Coup, NP, H),
				retractall(plateau_courant(_)),
				asserta(plateau_courant(NP)).

%Historique vide = pas de poussee
%Si joueur = e, on bouge un éléphant, et le joueur suivant jouera les rhinocéros, sinon inverse
modifier_plateau([E,R,M,e], (Depart,Arrivee,Orientation), [NewE,R,M,r], []) :- 
	write('Modif plateau sans histo qd elephant'),
	change_p(E, (Depart,Arrivee,Orientation), NewE),!.
modifier_plateau([E,R,M,r], (Depart,Arrivee,Orientation), [E,NewR,M,e], []) :- 
	write('Modif plateau sans histo qd rhino'),
	change_p(R, (Depart,Arrivee,Orientation), NewR),!.

%Historique non vide = poussee, changements multiples de pions
modifier_plateau([E,R,M,e], (Depart,Arrivee,Orientation), [E,R,M,r], H) :- 
															write('Modif plateau avec histo qd elephant'),
															reverse(H, InvH),
															modifier_plateau(P, (Depart,Arrivee,Orientation), TmpP, _),
															change_pion(TmpP, Orientation, NP, InvH).
modifier_plateau([E,R,M,r], (Depart,Arrivee,Orientation), [E,R,M,e], H) :- 
															write('Modif plateau avec histo qd rhino'),
															reverse(H, InvH),
															modifier_plateau(P, (Depart,Arrivee,Orientation), TmpP, _),
															change_pion(TmpP, Orientation, NP, InvH).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Modification des pions               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
change_p([],_,[]) :- write('Erreur : impossible de modifier la piece, non presente dans la base.'),
					nl,
					fail.
change_p([(Depart,_)|Q], (Depart, Arrivee, Orientation), [(Arrivee,Orientation)|Q]).
change_p([T|Q], Coup, [T|NewQ]) :- change_p(Q, Coup, NewQ). 
								
%Quand historique vide = plus de modifications à apporter
change_pion([E,R,M,J], O, NewPlateau, [(m,Case)|Q]) :- 	change_montagne(M, Case, TmpM, O), 
										change_pion([E,R,TmpM,J], O, NewPlateau, Q).
change_pion([E,R,M,J], O, NewPlateau, [(e, Case, O)|Q]) :- 	change_animal(E, Case, TmpE, O), 
										change_pion([TmpE,R,M,J], O, NewPlateau, Q).
change_pion([E,R,M,J], O, NewPlateau, [(r, Case, O)|Q]) :- 	change_animal(R, Case, TmpR, O), 
										change_pion([E,TmpR,M,J], O, NewPlateau, Q).

change_montagne([Case|Q], Case, [NewCase|Q], n) :- NewCase is Case + 10.
change_montagne([Case|Q], Case, [NewCase|Q], e) :- NewCase is Case + 1.
change_montagne([Case|Q], Case, [NewCase|Q], s) :- NewCase is Case - 10.
change_montagne([Case|Q], Case, [NewCase|Q], w) :- NewCase is Case - 1.
change_montagne([T|Q], Case, [T|NewQ], O) :- change_montagne(Q, Case, NewQ, O).

change_animal([(Case,Orientation)|Q], Case, [(NewCase,Orientation)|Q], n) :- NewCase is Case + 10.
change_animal([(Case,Orientation)|Q], Case, [(NewCase,Orientation)|Q], e) :- NewCase is Case + 1.
change_animal([(Case,Orientation)|Q], Case, [(NewCase,Orientation)|Q], s) :- NewCase is Case - 10.
change_animal([(Case,Orientation)|Q], Case, [(NewCase,Orientation)|Q], w) :- NewCase is Case - 1.
change_animal([T|Q], Case, [T|NewQ], O) :- change_animal(Q, Case, NewQ, O).
							
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					

%Fin de partie : vérification si une montagne est hors-limites
%				détermination du vainqueur si oui.					
					
fin_partie([E,R,M,J], H, C) :- write('Fin de partie?'), nl,
								montagne_out(M), !, 
								afficher_gagnant(H, [E,R,M,J], C).

montagne_out([M,_,_]) :- M = 0, !.
montagne_out([_,M,_]) :- M = 0, !.
montagne_out([_,_,M]) :- M = 0, !.
					
afficher_gagnant(H, P, (_,_,Orientation)) :- reverse(H, InvH),
							trim_historique(InvH, NewH),
							test_orientation(NewH, Orientation, P, e),
							write('Les elephants ont gagne!').
													
afficher_gagnant(_, _, _) :- write('Les rhinoceros ont gagne!').

trim_historique([], []) :- write('Erreur : impossible de se retrouver avec un historique sans montagne dans le cas ou fin de partie').
trim_historique([(m,_)|Q], Q) :- !.
trim_historique([_|Q], NewH) :- trim_historique(Q, NewH).

%Si historique vide : pion qui a initié la poussée a gagné
%Comme plateau déjà modifié (joueur différent de celui qui a joué), on renvoie l'autre joueur que le joueur courant
test_orientation([], _, Plateau, r) :- afficher_joueur(Plateau, e).
test_orientation([], _, Plateau, e) :- afficher_joueur(Plateau, r).

test_orientation([(Pion,Case,_)|Q], O, Plateau, Pion) :- orientation_identique(O, Case, Plateau),!.
test_orientation([(Pion,Case,_)|Q], O, Plateau, Pion) :- test_orientation(Q, O, Plateau).
						

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                      TIPS                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%						
						
						
%Structure d'un coup : (Depart, Arrivee, Orientation)
%Ex (0,11,n)

%dynamic(plateau_courant/1).
%retract(plateau_courant).
%asserta(plateau_courant(P)).	

%setof

%bagof(X,Y^,pere(X,Y),L). %Orientation se fiche des Y

%coups_possibles(Plateau, Case). 

%Vérifier la syntaxe du coup
%repeat laisse un point de choix donc si false il backtrack sur le point laissé
%par le repeat
%Il faut placer un cut après le test vrai
%saisir_coup.


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ne pas oublier pousser une piece hors du plateau il revient
%dans la main du joueur

%Orientation peut pousser en entrant

%En cas de victoire c'est le joueur qui possède le pion qui a poussé le dernier

%Représenter la file de pousser par une liste
% --> Représenter sous forme d'une liste Force Masse
% --> F > 0
% --> F >= M
%Compter F,M dans le sens de la liste

% exemples

%  --> <--
%F  1   0 Stop
%M  0   0

%  --> M M -->
%F  1  1 1 Stop
%M  0  1 2

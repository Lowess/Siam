%Jouer coup

:- include('plateau.pl').

%Vérifie que la case appartient au plateau
case_valide(0).
case_valide(C) :- 	C > 10, C < 56,
			T is C mod 10,
			T < 6, T > 0.
		
%Vérifie que le joueur manipule ses pions
%position + joueur
%Si joue les elephants
verifier_depart(D,P) :-	case_valide(D),
			afficher_joueur(P,J),
			J=e,
			elephant(P,D), 
			!.
%Si joue les rhinoceros
verifier_depart(D,P) :-	case_valide(D),
			afficher_joueur(P,J),
			J=r,
			rhinoceros(P,D), 
			!.

verifier_depart(_,_) :-	fail.


%Vérifie que la case arrivée est vide + coup autorisé
%position + plateau

verifier_entree_plateau(A) :-   Div is A // 10,
				Div=5, !.

verifier_entree_plateau(A) :-   Div is A // 10,
				Div=1, !.

verifier_entree_plateau(A) :-   Mod is A mod 10,
				Mod=5, !.

verifier_entree_plateau(A) :-   Mod is A mod 10,
				Mod=1.

verifier_deplacement_plateau(-1).
verifier_deplacement_plateau(1).
verifier_deplacement_plateau(-10).
verifier_deplacement_plateau(10).

%On ne peut pas passer son tour
verifier_arrivee(0,0,_) :-	fail.

%Entrée sur plateau
verifier_arrivee(0,A,P) :-	case_valide(A),!,
				verifier_case_vide(A,P),
				%On test maintenant la validité du coup
				verifier_entree_plateau(A).

verifier_arrivee(A,A,P).				

verifier_arrivee(D,A,P) :-	case_valide(A),
				%On test maintenant la validité du coup
				%Case A = D +/- 1 OU D +/- 10
				Tmp is D-A,
				verifier_deplacement_plateau(Tmp),
				verifier_case_vide(A,P),!.

%Si case depart et case arrivée valides mais arrivée non vide, joueur tente de pousser une pièce
%Case d'arrivée valide, continuer en donnant orientation				
verifier_arrivee(D,A,P): write('Case non vide : pour tenter une poussee, choisir orientation.').

%Vérifie que la case ne contient rien
verifier_case_vide(C,P) :- 	\+ elephant(P,C),
							\+ rhinoceros(P,C),
							\+ montagne(P,C).


%Vérification de l'entrée d'une valeur correcte
verifier_orientation(_,_,_, n).
verifier_orientation(_,_,_, w).
verifier_orientation(_,_,_, e).
verifier_orientation(_,_,_, s).

%Si le joueur décide de ne pas bouger son pion : obligation de changer son orientation							
verifier_orientation(P, D, D, O) :- getOrientation(O, D),
									\+ O = PreviousOrientation.

%Si la destination de la pièce est l'extérieur du plateau, on se fiche de l'orientation.
verifier_orientation(_,_,0,_).

%Si le joueur décide de ne pas bouger son pion : obligation de changer son orientation
verifier_orientation(P,D,A,O) :- 							
							
coup_possible(P, (D,A,O)) :- repeat,
							write('Choisissez votre pion'),
							nl,
							read(D),
							verifier_depart(D, P),!,
							repeat,
							write('Choisissez la case d\'arrivée'),
							read(A),
							verifier_arrivee(D, A, P),!,
							write('Choisissez l\'orientation de votre pion'),
							read(O),
							verifier_orientation(P,D,A,O).
							

%Ex (0,11,n)
%coup(Depart, Arrivee, Orientation).

%jouer_coup(PlateauInitial, Coup, NouveauPlateau) :- 

%dynamic(plateau_en_cours/1).
%retract(plateau_en_cours).
%asserta(plateau_en_cours(P)).	

%poussee_possible(Plateau, Case, Direction).




%setof

%bagof(X,Y^,pere(X,Y),L). %On se fiche des Y

%coups_possibles(Plateau, Coup). 

%Vérifier la syntaxe du coup
%repeat laisse un point de choix donc si false il backtrack sur le point laissé
%par le repeat
%Il faut placer un cut après le test vrai
%saisir_coup.







%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ne pas oublier pousser une piece hors du plateau il revient
%dans la main du joueur

%%On peut pousser en entrant

%En cas de victoire c'est le joueur qui a le pion 

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

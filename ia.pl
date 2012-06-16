%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          IA.PL                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

casesExterieures([11,12,13,14,15,21,31,41,51,52,53,54,55,45,35,25]).

coups_possibles_joueur([E,R,M,e], ListeCoups) :- coups_possibles_pion(E, TmpCoups, [E,R,M,e]), flatten(TmpCoups, 													ListeCoups).
coups_possibles_joueur([E,R,M,r], ListeCoups) :- coups_possibles_pion(R, TmpCoups, [E,R,M,r]), flatten(TmpCoups, 													ListeCoups).

coups_possibles_pion([],[], _).
coups_possibles_pion([E1|E], [NewCoups|ListeCoups], P) :- coups_possibles_pion(E, ListeCoups, P),
													setof(Coups, getCoupPossible(E1, Coups, P), TmpCoups), flatten(TmpCoups,NewCoups).

%Coups possibles : Pion reste sur place mais change d'orientation
getCoupPossible((Case, n), [(Case,Case,e),(Case,Case,s),(Case,Case,w)], _).
getCoupPossible((Case, e), [(Case,Case,n),(Case,Case,s),(Case,Case,w)], _).
getCoupPossible((Case, s), [(Case,Case,n),(Case,Case,e),(Case,Case,w)], _).
getCoupPossible((Case, w), [(Case,Case,n),(Case,Case,e),(Case,Case,s)], _).

%Coups possibles : Sortie de plateau
getCoupPossible((Case, Orientation), [(Case, 0, 0)], P) :- \+ Case = 0,
															Arrivee is Case + 10,
														\+ case_valide(Arrivee),
															Arrivee2 is Case - 10,
														\+ case_valide(Arrivee2),
															Arrivee3 is Case + 1,
														\+ case_valide(Arrivee3), 
															Arrivee4 is Case - 1,
														\+ case_valide(Arrivee4).

														
getCoupPossible((0,_), ListeDeplacements, P) :- casesExterieures(L),
											produireListeEntree(L , ListeDeplacements, P).

getCoupPossible((Case,_), L, P) :- Arrivee is Case + 10,
								verifier_case_vide(Arrivee, P), getAllCoups(Case, Arrivee, L).
getCoupPossible((Case,_), L, P) :- Arrivee is Case - 10,
								verifier_case_vide(Arrivee, P), getAllCoups(Case, Arrivee, L).
getCoupPossible((Case,_), L, P) :- Arrivee is Case + 1,
								verifier_case_vide(Arrivee, P), getAllCoups(Case, Arrivee, L).
getCoupPossible((Case,_), L, P) :- Arrivee is Case - 1,
								verifier_case_vide(Arrivee, P), getAllCoups(Case, Arrivee, L).
getCoupPossible((Case,O), [(Case,Arrivee,n)], P) :- Arrivee is Case + 10, 
												\+ verifier_case_vide(Arrivee, P),
												poussee_possible(Arrivee,n,Plateau,H).
getCoupPossible((Case,O), [(Case,Arrivee,s)], P) :- Arrivee is Case - 10,
												\+ verifier_case_vide(Arrivee, P),
												poussee_possible(Arrivee,s,Plateau,H).
getCoupPossible((Case,O), [(Case,Arrivee,e)], P) :- Arrivee is Case + 1,
												\+ verifier_case_vide(Arrivee, P),
												poussee_possible(Arrivee,e,Plateau,H).
getCoupPossible((Case,O), [(Case,Arrivee,w)], P) :- Arrivee is Case - 1,
												\+ verifier_case_vide(Arrivee, P),
												poussee_possible(Arrivee,w,Plateau,H).
								
produireListeEntree([], [], _).
produireListeEntree([T|Q], [(0,T,n),(0,T,e),(0,T,s),(0,T,w)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P), verifier_case_vide(T, P).
																					
%Coups possibles lors de l'entree lorsque case non vide.

%Coins : orientations particulieres
produireListeEntree([11|Q], [(0,11,n),(0,11,e)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P).
produireListeEntree([51|Q], [(0,51,e),(0,51,s)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P).
produireListeEntree([15|Q], [(0,15,n),(0,15,w)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P).
produireListeEntree([55|Q], [(0,55,w),(0,55,s)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P).

%Bords : une seule orientation possible
produireListeEntree([T|Q], [(0,T,e)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P), Case is T mod 5, Case = 1.
produireListeEntree([T|Q], [(0,T,w)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P), Case is T mod 5, Case = 0.
produireListeEntree([T|Q], [(0,T,n)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P), Case is T // 10, Case = 1.
produireListeEntree([T|Q], [(0,T,s)|ListeDeplacements], P) :- produireListeEntree(Q, ListeDeplacements, P), Case is T // 10, Case = 5.
														
getAllCoups(Case, Arrivee, [(Case,Arrivee,n),(Case,Arrivee,e),(Case,Arrivee,s),(Case,Arrivee,w)]) :- case_valide(Arrivee).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

meilleur_coup(Plateau, ListeCoups, Coup). 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%findall--> trouve toutes les solutions, si pas de solution retourne liste vide []

%Quelques soit
%findall(Y,(member(X,[1,2,3]), Y is X*2),L).
%L=[2,4,6]


%Il existe
%bagof(Y,(member(X,[1,2,3]), Y is X*2),L).
%setof

%X=1 L=[2]
%X=2 L=[4]
%X=3 L=[6]

%On quantifie en quel que soit
%bagof(Y,X^,(member(X,[1,2,3]), Y is X*2),L).
%L=[2,4,6]


%findall((X,Y), nth(X, [a,b,c], Y), L).
%L=[(1,a), (2,b), (3,c)]

%bagof--> pas de solution, echoue,

%setof--> pas de solution, echoue, trie et supression de doublons


%PDF 10p environ
%Code
%Imprimer version papier

%expliquer la représentation du plateau
%expliquer coup possible
%expliquer l\'IA

%trace,
%notrace,
%s --> ne rentre pas dans un predicat

%spy(nom_predicat(/arite)). place un breackpoint sur le predicat
%nospy(nom_predicat(/arite)).
%nospyall.
%debug. active le debuger
%nodebug.

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

%evaluer les coups dont on pense que le plateau vont etre médiocre
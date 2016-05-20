male(josef).
male(jan).
female(sarka).
female(jana).
female(anna).

parent(josef, jan).
parent(josef, sarka).
parent(jana, jan).
parent(jana, sarka).
parent(anna, josef).

human(H):-male(H),!.
human(H):-female(H).

father(F,C) :- male(F),parent(F,C).
mother(M,C) :- female(M),parent(M,C).

is_father(F) :- father(F,_).
is_mother(M) :- mother(M,_).

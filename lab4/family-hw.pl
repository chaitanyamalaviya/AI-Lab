cyborg(curtis_brady).
cyborg(felix_snyder).
cyborg(garry_freeman).
cyborg(iris_tucker).
cyborg(linda_owens).
cyborg(meredith_elliott).
cyborg(olive_hall).
cyborg(roger_mccormick).
cyborg(samantha_wilson).
cyborg(wallace_moran).
female(lula_saunders).
female(luz_schultz).
female(mae_robertson).
female(sophia_schmidt).
female(terrell_kennedya).
female(tracy_wells).
male(dewey_price).
male(guadalupe_spencer).
male(guy_holloway).
male(lee_jenkins).
male(marty_cobb).
male(terrell_kennedy).
male(todd_glover).
married(guy_holloway, mae_robertson).
married(iris_tucker, roger_mccormick).
married(lee_jenkins, terrell_kennedya).
married(linda_owens, wallace_moran).
married(mae_robertson, guy_holloway).
married(roger_mccormick, iris_tucker).
married(samantha_wilson,todd_glover).
married(terrell_kennedy, tracy_wells).
married(terrell_kennedya, lee_jenkins).
married(todd_glover, samantha_wilson).
married(tracy_wells, terrell_kennedy).
married(wallace_moran, linda_owens).
parent(guadalupe_spencer, lula_saunders).
parent(guy_holloway, lee_jenkins).
parent(iris_tucker, felix_snyder).
parent(iris_tucker, garry_freeman).
parent(lee_jenkins, guadalupe_spencer).
parent(lee_jenkins, olive_hall).
parent(lee_jenkins, todd_glover).
parent(linda_owens, meredith_elliott).
parent(linda_owens, roger_mccormick).
parent(linda_owens, samantha_wilson).
parent(luz_schultz, lula_saunders).
parent(mae_robertson, lee_jenkins).
parent(roger_mccormick, felix_snyder).
parent(roger_mccormick, garry_freeman).
parent(samantha_wilson, dewey_price).
parent(samantha_wilson, marty_cobb).
parent(samantha_wilson, sophia_schmidt).
parent(terrell_kennedy, terrell_kennedya).
parent(terrell_kennedya, guadalupe_spencer).
parent(terrell_kennedya, olive_hall).
parent(terrell_kennedya, todd_glover).
parent(todd_glover, dewey_price).
parent(todd_glover, marty_cobb).
parent(todd_glover, sophia_schmidt).
parent(tracy_wells, terrell_kennedya).
parent(wallace_moran, meredith_elliott).
parent(wallace_moran, roger_mccormick).
parent(wallace_moran, samantha_wilson).

human(H) :- male(H).
human(H) :- female(H).
father(F,C) :- male(F),parent(F,C).
mother(M,C) :- female(M),parent(M,C).
is_father(F) :- father(F,_).
is_mother(M) :- mother(M,_).


% X is a spouse of Y
spouse(X, Y) :- married(X,Y); married(Y,X).

% H is a human husband of Y
human_husband(H, Y) :- married(H,Y), male(H).

% H is a human wife of Y
human_wife(H, Y) :- married(H,Y), female(H).

% H1 is a spouse of H2, both are humans
human_couple(H1, H2) :- human(H1), human(H2), married(H1,H2).

% C is a spouse of Y, C is cyborg, Y can be anyone
cyborg_spouse(C, Y) :- married(C,Y), cyborg(C).

% C1 is a spouse of C2, both are cyborgs
cyborg_couple(C1, C2) :- married(C1,C2), cyborg(C1), cyborg(C2).

% X and Y are siblings, both humans
human_siblings(X, Y) :- human(X), human(Y), siblings(X,Y).
siblings(X, Y) :- parent(H,X), parent(H,Y), X \= Y.

% X is a brother (male human) of a human Y
brother_of_human(X, Y) :-  human_siblings(X,Y), male(X).

% X is a sister (female human) of a human Y
sister_of_human(X, Y) :- human_siblings(X,Y), female(X).

% X is an ancestor of Y
ancestor(X,Y) :- parent(X, Y).
ancestor(X,Y) :- parent(X, H), ancestor(H, Y).

% C is a cyborg ancestor of Y
cyborg_ancestor(C,Y) :- ancestor(C,Y), cyborg(C).

% C1, C2 and C3 is a family of cyborgs, where C1 and C2 are married cyborgs and C3 is their cyborg
% child if they have multiple children, results will be repeated with different C3
cyborg_family(C1,C2,C3) :- cyborg_couple(C1,C2), is_parent(C1,C3), is_parent(C2,C3), cyborg(C3).
is_parent(X,Y) :- parent(X,Y).

% X is descendant of Y
descendant(X,Y) :- parent(Y, X).
descendant(X,Y) :- parent(H, X), descendant(H,Y).


% C is cyborg descendant of Y
cyborg_descendant(C,Y) :- descendant(C,Y), cyborg(C).

% X is aunt or uncle of Y, X is human
human_auntoruncle(X,Y) :- parent(H,Y), siblings(X,H), human(X).

% A few simple rules now, if these the variable is not bounded, iterate through all those who
% fulfill the condition, e.g. is_cyborg(X). iterates through all cyborgs
is_cyborg(C) :- cyborg(C).

is_human(H) :- human(H).

is_human_child_of_cyborg_parent(H) :- cyborg(X), parent(X,H), human(H).

has_cyborg_ancestor(X) :-  cyborg(H), ancestor(H,X).

all(X) :-human(X);cyborg(X).
has_no_cyborg_descendants(X) :- all(X), \+(cyborg_descendant(_, X)).





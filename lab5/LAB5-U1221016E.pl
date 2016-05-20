%%%% CZ3005 2015 Semester 2: Lab 4 (Total Marks: 100)
%%%%
%%%% Due two weeks from the lab.
%%%%
%%%% Submission procedure will be announced during the lecture or the
%%%% lab session.
%%%%
%%%% This file is a loadable Prolog file.  You are to modify this file and
%%%% add your answers.  Then CHECK TO MAKE SURE that the file still loads
%%%% properly into the Prolog system. You will be penalized in case the file
%%%% is not loadable.
%%%%
%%%% Name your lab 5 Prolog code as  "LAB5-<YOUR_MATRICULATION_NUMBER>.pl"
%%%%
%%%% Before you submit your code, be sure to test it in Swi-Prolog.
%%%% We'll be using Swi_Prolog v. 6.6.* to check your solutions.
%%%%
%%%% If we cannot run your code, including our automatic checker, your answer
%%%% will not be considered at all. If our checker detects wrong output, you may
%%%% still get partial marks for such problem.
%%%%
%%%% No external code is allowed in this assignment. All code and text has to be your
%%%% original work.
%%%%
%%%% No synopsis and outlines are given for any question. You have to figure out the format of the
%%%% predicates yourself.
%%%%
%%%% COMMENT EXCESSIVELY -- In Prolog, the code is usually very concise. It is very
%%%% important that you comment everything. In most of the programming questions, up to
%%%% 50% of the marks is awarded for comments!




%%%% QUESTION 1     [ 20 marks (10 marks for each task) ]

%% Anyone who goes to consultations or works smart can finish all his assignments. Anyone who works
%% smart maintains his mental health. Anyone who finished the third assignment of CZ3005 and
%% maintains his mental health is a mastermind. Quek Jr. did not go to consultations, but he works
%% smart.

%% Convert these sentences into first order logic (like you did in the tutorial). Note you may use
%% textual representation, such as: forall students exists student such that ...

%% Use Prolog to prove or disprove this:
%%     Quek Jr. is a mastermind
%% Proved using mastermind(QuekJr). , which returns true.

%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:

%% If X goes(does not - not go) to consultations or
%% works smart, he can finish any assignment.
finish(X,_) :- not(no_consultation(X)) ; work_smart(X).

%% If X works smart, he maintains his mental health.
mental_health(X) :- work_smart(X).

%% If X finished third assignment of CZ3005 and
%% maintained his mental health, he is a mastermind.
mastermind(X) :- finish(X,Assignment3), mental_health(X).

%% no_consultation(X) : X did not go to consultations.
%% QuekJr did not go to consultations.
no_consultation(QuekJr).

%% QuekJr works smart.
work_smart(QuekJr).




%%%% QUESTION 2     [ 20 marks (10 marks for each task) ]

%% If the unicorn is mythical, then it's immortal, but if it is not mythical, then it is a mortal
%% mammal. If the unicorn is either immortal or a mammal, then it is horned. The unicorn is magical
%% if it is horned.

%% Convert these sentences into first order logic.

%% Use Prolog to find answers (or find that we cannot give an answer) for the following:

%% Is the unicorn mythical?
%% It cannot be found out whether a unicorn is mythical or not.
%% All other characteristics of unicorn depend on whether it is mythical or not.
%% Hence, both possibilities must be considered for next questions.

%% Is the unicorn magical?
%% Yes, both when it is mythical and not mythical.
%% Can be found out using magical(X). and redoing for both cases(mythical/not mythical).
%% true is returned for both cases.

%% Is the unicorn horned?
%% Yes, both when it is mythical and not mythical.
%% Can be found out using magical(X). and redoing for both cases(mythical/not mythical).
%% true is returned for both cases.

%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:

%% Unicorn X may be mythical or not mythical.
%% The output should consider both scenarios and give answers.
mythical(X).
not(mythical(X)).

%% If X is mythical, X is immortal.
immortal(X) :- mythical(X).

%% If X is not mythical, X is mortal and mammal.
not(immortal(X)) :- not(mythical(X)).
mammal(X) :- not(mythical(X)).

%% If X is either immortal or mammal, X is horned.
horned(X) :- immortal(X); mammal(X).

%% If X is horned, X is magical.
magical(X) :- horned(X).





%%%% QUESTION 3     [ 20 marks (10 for correctness, 10 for comments) ]

%% Consult file logical-gates.pl. It contains predicates for a few basic logical gates.
%% Consult http://www.tutorialspoint.com/computer_logical_organization/combinational_circuits.htm
%% Your task is to write predicates for more sophisticated logical gates.

%% Write predicates for:

%%     4-bit full adder
%%     4-bit full subtractor
%%     4-bit priority encoder (4th input variable has highest priority)

%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:

%% A0 is LSB and A3 is the MSB of the first 4-bit number while B0 is LSB and B3 is the MSB of the second 4-bit number.
%% Carry_in1 is the carryIn input, which is 0 when predicate is called.
%% Carry_out is the carry output of the 4-bit full adder.
%% Sum_out0 is LSB and Sum_out3 is the MSB of the sum of the two 4-bit numbers.
%% The 4-bit full adder can be implemented by cascading 4 full adders,
%% where the carry output of the previous full adder is used as carry in of the next full adder.

fourbitadder(A0, A1, A2, A3, B0, B1, B2, B3, Carry_in1, Carry_out, Sum_out0, Sum_out1, Sum_out2, Sum_out3) :-
    fulladder(A0,B0,Carry_in1,Sum_out0,M),
    fulladder(A1,B1,M,Sum_out1,N),
    fulladder(A2,B2,N,Sum_out2,O),
    fulladder(A3,B3,O,Sum_out3,Carry_out).



%% A0 is LSB and A3 is the MSB of the first 4-bit number while B0 is LSB and B3 is the MSB of the second 4-bit number.
%% Carry_in1 is the carryIn input, which is 0 when predicate is called.
%% Carry_out is the carry output of the 4-bit full subtractor.
%% Diff_out0 is LSB and Diff_out3 is the MSB of the difference of the two 4-bit numbers.
%% The 4-bit full subtractor can be implemented using the 4-bit full adder.
%% For instance, if we need to find (A - B), where A and B are two 4-bit numbers,
%% we first find the 2's complement of B and then add it to A using a full adder.
%% The 2's complement is found by negating all bits using the not predicate and adding 1 to B.
%% If A > B then Carry_out = 0 and the result is of binary form (A-B)
%% and when Carry_out = 1, the result is in 2's complement form.

fourbitsubtractor(A0, A1, A2, A3, B0, B1, B2, B3, Carry_in1, Carry_out, Diff_out0, Diff_out1, Diff_out2, Diff_out3) :-
    not(B0,N0), %% Negate all bits of B using not predicate, N represents the 1's complement
    not(B1,N1),
    not(B2,N2),
    not(B3,N3),
    %% Add 1 to 1's complement of B using 4-bit full adder
    fourbitadder(N0, N1, N2, N3, 1, 0, 0, 0, 0, _ , M0, M1, M2, M3),
    fourbitadder(A0, A1, A2, A3, M0, M1, M2, M3, Carry_in1, Carry_out, Diff_out0, Diff_out1, Diff_out2, Diff_out3).



%% A0, A1, A2, A3 are input bits to the priority encoder starting from LSB.
%% Y0 and Y1 are the LSB and MSB of the output of encoder.
%% To design the priority encoder, a truth table was drawn where
%% the 4th input variable A3 has the highest priority.
%% The truth table was converted into a logic circuit.
%% It was constructed from the circuit that,
%% Y0 = A3 + A2'.A1 and Y1 = A2 + A3

fourbitpencoder(A0, A1, A2, A3, Y0, Y1) :-
    or(A2,A3,Y1), %% A2 + A3 = Y1
    not(A2,N2),   %% A2'
    and(N2,A1,K), %% A2'.A1
    or(K,A3,Y0).  %% A3 + A2'.A1 = Y0





%%%% QUESTION 4     [ 40 marks (20 for working solution and correct answers, 20 for comments) ]

%% You are given a logical riddle. Unlike conventional riddles with a single solutions, this one has
%% plenty of solutions. That's why Prolog is better than pen and paper. By a solution, we mean all
%% possible valid combinations.

%% Use Prolog to solve the riddle and successively evaluate the solutions. You have to create
%% several predicates, model the problem properly, test it thoroughly. For convenience, you may want
%% to go through tutorial on lists in Prolog (https://en.wikibooks.org/wiki/Prolog/Lists). It makes
%% the problem modeling process simpler.

%% Describe your thinking process. Why did you chose to model this and that constraint using certain
%% model and not a different one? What is the purpose of each predicate?

%% Note that there is plenty of different ways how to model your problem. Don't get stuck with one.
%% No outline is given to you. Use your creativity.


%% THE RIDDLE:

%% * There are 5 frogs living in 5 ponds on NTU campus.
%% * The ponds are laid out in a circular shape (cycle graph), first pond is on the north, second
%%   on the east, third on the south-east, fourth on the south-west, fifth on the west.
%% * Each pond has different trees growing around it.
%% * Each frog owns its own pond.
%% * Each frog graduated from different school at NTU.
%% * Each frog listens to different genre of music.
%% * Each frog drinks different beer.
%%
%% * Frog that drinks Tsingtao beer lives adjacent to frog that listens to punk. (1)
%% * Willow pond is counterclockwise adjacent to pine pond. (2)
%% * Wet_Willy lives in a pond adjacent to lilies pond. (3)
%% * Frog from willow pond drinks Heineken. (4)
%% * Frog that likes punk lives adjacent to a frog that graduated from Nanyang Business School. (5)
%% * Frog who likes rock music is a graduate of School of Biological Sciences. (6)
%% * Wet_Willy lives in the northern pond. (7)
%% * Leaping_Lucy graduated from School of Mechanical and Aerospace Engineering. (8)
%% * Tommy_Toad drinks Budweiser. (9)
%% * Freaky_Frog lives in birch pond. (10)
%% * Frog from palm pond likes thrash metal music. (11)
%% * Xena_Warrior_Frog listens to classical music. (12)
%% * Frog in the south-eastern pond drinks Pilsner Urquell. (13)
%% * Xena_Warrior_Frog graduated from School of Computer Engineering. (14)
%% * Frog that graduated from School of Electrical and Electronic Engineering lives adjacent to frog
%%   that listens to thrash metal. (15)
%% * Frog that listens to k-pop drinks Tiger beer. (16)
%%
%% * The largest living frog on Earth is the goliath frog (Conraua goliath) :-). - Not useful for modeling


%% THE QUESTIONS:

%% How many different frogs can possibly live in the palm pond?  Which frogs are those?
%% Three frogs: wet_willy, tommy_toad, leaping_lucy.

%% How many different combinations (pond X trees surrounding ponds X beer type X music genre X alma
%% mater) are there in total? What are they?

%% 3 combinations are obtained:
%% (1) [(palm, wet_willy, nbs, tsingtao, thrashmetal),
%%      (lilies, tommy_toad, eee, budweiser, punk),
%%      (birch, freaky_frog, sbs, pilsnerurquell, rock),
%%      (pine, leaping_lucy, mae, tiger, kpop),
%%      (willow, xena_warrior_frog, sce, heineken, classical)]

%% (2) [(willow, wet_willy, sbs, heineken, rock),
%%      (lilies, xena_warrior_frog, sce, tsingtao, classical),
%%      (birch, freaky_frog, eee, pilsnerurquell, punk),
%%      (palm, tommy_toad, nbs, budweiser, thrashmetal),
%%      (pine, leaping_lucy, mae, tiger, kpop)]

%% (3) [(pine, wet_willy, nbs, tiger, kpop),
%%      (willow, xena_warrior_frog, sce, heineken, classical),
%%      (birch, freaky_frog, sbs, pilsnerurquell, rock),
%%      (palm, leaping_lucy, mae, tsingtao, thrashmetal),
%%      (lilies, tommy_toad, eee, budweiser, punk)]


%% WRITE YOUR CODE AND COMMENTS BELOW THIS LINE:

%% Determines which frogs can live at the pond with palm trees
%% When all constraints are satisfied through the ponds predicate,
%% find the frog who lives in the palm pond.
palm_frog(Frog) :-
ponds(P),
member(p(palm,Frog,_,_,_), P).


%% ponds predicate is used to define the constraints provided in the problem.
%% This method of modeling was chosen due to 1) ease of representing all constraints with a single predicate,
%% 2) flexibility in using a list to obtain all possible solutions and
%% representing the adjacent predicate for a circular configuration.

ponds(P) :-
%% P is represented as a list of ponds of length 5.
%% Pond p in list P of ponds is represented as:
%% p(tree, frog, school, drink, genre) in the clockwise direction
%% starting from north, east, south-east, south-west and west
%% The member predicate binds the constraint values for a pond.
%% The values that are unknown while defining a constraint are represented as '_'
%% to allow all possible unifications.
%% The constraints written below are written in same order as given description.

length(P, 5),
adjacent(p(_,_,_,tsingtao,_),p(_,_,_,_,punk), P),
adjacentCCW(p(willow,_,_,_,_),p(pine,_,_,_,_), P), %%counterclockwise adjacency
adjacent(p(_,wet_willy,_,_,_),p(lilies,_,_,_,_), P),
member(p(willow,_,_,heineken,_), P),
adjacent(p(_,_,nbs,_,_),p(_,_,_,_,punk), P),
member(p(_,_,sbs,_,rock), P),
P = [p(_,wet_willy,_,_,_),_,_,_,_],
member(p(_,leaping_lucy,mae,_,_), P),
member(p(_,tommy_toad,_,budweiser,_), P),
member(p(birch,freaky_frog,_,_,_), P),
member(p(palm,_,_,_,thrashmetal), P),
member(p(_,xena_warrior_frog,sce,_,classical), P),
P = [_,_,p(_,_,_,pilsnerurquell,_),_,_],
adjacent(p(_,_,_,_,thrashmetal),p(_,_,eee,_,_), P),
member(p(_,_,_,tiger,kpop), P).



% Predicate defined for a relation between two ponds both ways - clockwise and counterclockwise
% The append predicate adds pond A after pond B or pond B after pond A in a list L.
adjacent(A, B, L) :- append(_, [A,B|_], L).
adjacent(A, B, L) :- append(_, [B,A|_], L).

%% To take care of circular adjacency, two ponds A and B may also be adjacent
%% if A is head and B is tail in the list of ponds P. The vice-versa is also valid.
adjacent(A, B, L) :- gethead(L,B), last(L,A).
adjacent(A, B, L) :- gethead(L,A), last(L,B).

% Predicate defined only for a counterclockwise relation between two ponds
adjacentCCW(A, B, L) :- append(_, [B,A|_], L).
%% To take care of circular counterclockwise adjacency,
%% two ponds A and B may also be counterclockwise adjacent
%% if A is head and B is tail in the list of ponds P.
adjacentCCW(A, B, L) :- gethead(L,A), last(L,B).

%% Finds the head of a list L and stores it in Head.
gethead(L,Head) :- [Head|_] = L.


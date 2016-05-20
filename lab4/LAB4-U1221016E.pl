%%%% CZ3005 2015 Semester 2: Lab 4 (Total Marks: 100)
%%%%
%%%% Due two weeks from the lab.
%%%%
%%%% Submission procedure will be announced during the lecture or the
%%%% lab session.
%%%%
%%%% This file is a loadable Lisp file.  You are to modify this file and
%%%% add your answers.  Then CHECK TO MAKE SURE that the file still loads
%%%% properly into the Prolog system. You will be penalized in case the file
%%%% is not loadable.
%%%%
%%%% Name your lab 4 Prolog code as  "LAB4-<YOUR_MATRICULATION_NUMBER>.pl"
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
%%%% COMMENT EXCESSIVELY -- In Prolog, the code is usually very concise. It is very
%%%% important that you comment everything. In most of the programming questions, up to
%%%% 50% of the marks is awarded for comments!



%%%% QUESTION 1     [ 10 marks for thorough explanation
%%%%                  10 marks for derivation tree ]

%% Suppose that, in program P [p.pl], we change the clause #2 to this:

%% p(X) :- q(X), !, r(X).

%% What answers can now be produced by the goal ?-p(X)? Why? Test it. Draw the corresponding Prolog
%% derivation  tree (modified to suit the new rule).

%% Answers produced: X = a ;
%%                   X = a.

%% Here as well, the top goal p(X) unifies with the heads of clauses #1, #2,
%% #3 as three choices. Performing a depth-first traversal, X is first bound to a in clause #1.
%% In the next branch, p(X) is bound to q(X),!,r(X) and subsequently q(x) is bound to s(X).
%% Since there is a cutoff after q(X), there will be no more search for binding q(X).
%% In the next step, X is bound to a as r(a) and s(a) are both true. Since X is already bound to
%% a in this step, and there is a cutoff after s(X), the other branches existing in the tree
%% are cutoff. The final result is two bindings of X in step 1 and 7, both to a.

%% Please draw the derivation tree in ASCII below. You may use the one from lab4.pl as a base.


%%                     p(X)
%%          ________ ___|_________
%%          |           |         |
%%          |#1(X=a)    |#2       |#3
%%          |           |         |
%%        true      q(X),!,r(X)  u(x)
%%        X=a           |         |
%%                      |#4     cutoff
%%                      |
%%                  s(X),!,r(X)
%%                      |
%%           ___________|____________
%%           |        cutoff      cutoff
%%           |#7(X=a)
%%           |
%%          r(a)
%%      _____|____
%%      |        |
%%      |#5    #6|
%%      |        |
%%      true  fail
%%      X=a



%%%% QUESTION 2     [ 20 marks total ]

%% A common example of a knowledge base in Prolog is a family tree. Unfortunately, in the 21st
%% century, technology advances and human ignorance have cause a wide-spread integration of
%% cybernetic organisms (also known as cyborgs) into the human race. In the new society, it is
%% possible for newborn children to be transformed into cyborgs! They can get married and even have
%% children themselves, although cyborgs don't have genders!

%% You are given a family tree of a large family infested with cyborgs. See the file "family-hw.pl".

%% Your task is to write several very simple Prolog rules, so that we can easily analyze the
%% relationships withing this cyborg infested family.

%% The file consists of the following facts:

%% male(X).
%% female(X).
%% cyborg(X). % first three facts are exclusive
%% parent(X,Y). % X is parent of Y
%% married(X,Y). % X is married to Y, always accompanied by reverse fact

%% And the following rules:

%% human(H) :- male(H).
%% human(H) :- female(H).
%% father(F,C) :- male(F),parent(F,C).
%% mother(M,C) :- female(M),parent(M,C).
%% is_father(F) :- father(F,_).
%% is_mother(M) :- mother(M,_).

%% Your task is to to define all the following rules.

%% NOTE that not all the rules are very simple and sometimes you have to create multiple rules or
%% use recursive rules in order to achieve your goal.

% X is a spouse of Y
spouse(X, Y) :- married(X,Y); married(Y,X).
//Prints both cases: X is married to Y or Y is married to X.

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
//Remove duplicate entries with X\=Y when finding siblings in family tree.

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
% X is a parent of Y

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
//check all members of family tree for if they have a cyborg descendant.

%%%% QUESTION 3     [ 30 marks total (10 for each function) ]

%% Can you recognize the following three functions? If so, write the common name of each function
%% with detailed explanation how the evaluation works and how you figured out which function it is.
%% You may want to include a simple example. Imagine you are explaining this to your friend who is
%% proficient in computer science, but has no clue what logic programming and Prolog are. Saying
%% merely what the function does is not enough.

%% It is possible that you may get an instantiation_error error when trying the function. Just try
%% to use it differently, you may assume that variable X gets bound to the result. Always try
%% various inputs to the functions, otherwise you may be mislead easily.

% First function
first(0, 1).
first(N, X) :- N>0, N1 is N-1, first(N1,F1), X is N * F1.

% The first function is a factorial function that binds the factorial of N in X.
% Evaluation: The first statement is the base case of the recursive function
% and assigns the factorial of 0 to 1.
% The recursive condition in the second statement operates as follows, as long as N>0,
% keep calling the first function with the argument N-1. Compute the factorial(N) by
% multiplying the number  by the factorial of the integer that is 1 less than the number (N * (N-1)!)
% at each recursive stage.
% For example, to find first(5,X), the function makes repetitive calls- first(4,F1), first(3,F1) and so on
% until N=0. first(5,X) is calculated as multiplication of factorials of numbers below 5 (5*4*3*2*1*0!=120).
% How I figured it out: The logic in the code was easily understandable and was verified with random tests.

% Second function
second(0, X, X) :- !.
second(X, 0, X) :- !.
second(X, X, X) :- !.
second(A, B, X) :- B>A, C is B-A, second(A, C, X).
second(A, B, X) :- B<A, C is A-B, second(C, B, X).

% The second function is a function that binds the greatest common factor(GCF) of A and B in X.
% Evaluation: The first two statements simply assign the GCF to X and cutoff the search
% if the two arguments given are X and 0. This is because the GCF of a number and 0 is the same number.
% The third statement assigns the GCF to X and cuts off the search if the two arguments are X and X.
% This is because the GCF of a number with itself will always be the same number.
% This statements is the base case for the recursive function.
% The last two statements form the recursive logic of the GCF function.
% Suppose we want to find the GCF of 3(A) and 12(B). The logic works as follows,
% keep passing the difference between the two numbers and the smaller number to the next
% recursive call until both the arguments are equal(to the GCF).
% In our eg, since B>A, C is 9 and we call second(3,9,X). Once again B>A, so we call second(3,6,X)
% and finally second(3,3,X).
% At this point, the third statement is true as A and B are equal, so X is assigned to 3.
% How I figured it out: By testing it with random values and reading the code logic.


% Third function
third(0, 0, _) :- !, fail.
third(B, N, X) :- N>0, third(B, N, 1, X).
third(B, N, X) :- N<0, N1 = -N, third(B, N1, 1, X1), X is 1/X1.
third(_, 0, X, X).
third(B, N, T, X) :- N>0, T1 is T*B, N1 is N-1, third(B, N1, T1, X).

% The third function is the exponential function that binds B to the power of N in variable X.
% Evaluation: The first statement returns false in case we try to find 0 to the 0th power, since its undefined.
% In the second and third statements, we first find if N is greater or less than 0.
% In case N<0, we find B^N and then finally return 1/X1.
% We then call function with an extra accumulator T that stores the intermediate values in our calculation.
% The fourth statement is the base case of the recursive function and returns X if the N is 0.
% And the last statement keeps finding multiples of B and decrementing N simultaneously until N is 0.
% Suppose we want to find 3^2, B=3 and N=2. Since N>0 we call third(3,2,1,X1).
% In next call, we multiply 1(T) by 3(B) and decrement N(now 1). Finally, we multiply
% 3(T1) by 3(B) to obtain 9 and decrement N(now 0). Since N is 0, in the next call,
% the base case is true and we return 9.
% How I figured it out: Multiple random tests with the function revealed its purpose, which
% I then verified with the logic in the code.




%%%% QUESTION 4     [ 30 marks total (10 for each function: 5 for correctness, 5 for comments) ]

%% Your task in this question is to write the following predicates in Prolog. Note that the predicates
%% may consist of several clauses and may be recursive. You shouldn't need to use any techniques
%% we haven't gone through during the lab (lab4.pl). If you do, justify it.

%% Describe thoroughly how you reached the solutions. Just writing the function is not enough.

%% Test your predicates well. Don't forget invalid values, unbounded variables, border conditions.

% L and H are integers, such that L <= H. If X is an integer, numbers_between is true for L <= X <=
% H. When X is a variable it is successively bound to all integers between L and H.

numbers_between(L, H, X) :- L =< H, X = L.
numbers_between(L, H, X) :- L < H, F is L+1, numbers_between(F, H, X).

% Evaluation: This function operates as follows:
% The second statement is the recursive part of the function which increments L,
% stores in a new variable F and passes it as L.
% while the first statement is the base case. When X is an integer,
% L is incremented by 1 in the second statement until X=L and the first
% statement becomes true. 
% For example, if L=3, H=7 and X=5, the function is recursivvely called as,
% numbers_between(3,7,5)-> numbers_between(4,7,5) -> numbers_between(5,7,5). At this point, X=L
% and we know L falls between L and H.
% Whereas, if X is a variable, X is successively bound to L as we keep incrementing L
% until L>H.


% This predicate computes both the Quotient and Remainder of two positive integers: Dividend /
% Divisor. Quotient is Dividend div Divisor; Remainder is Dividend mod Divisor

divmod(Dividend, Divisor, Quotient, Remainder) :-  Dividend > 0 , Divisor > 0 , divmod(Dividend, Divisor, 0, Quotient, Remainder).
divmod(Dividend, Divisor, T, Quotient, Remainder) :- Dividend < Divisor, Quotient = T, Remainder = Dividend.
divmod(Dividend, Divisor, T, Quotient, Remainder) :- Dividend >= Divisor , T1 is T+1 , Diff is Dividend-Divisor , divmod(Diff, Divisor, T1, Quotient, Remainder).

% Evaluation: This function operates as follows,
% In first statement, we check if both divident and divisor are >0 since they need to be positive integers
% and then call divmod with an accumulator, that counts the number of subtractions of dividend-divisor, starting from 0.
% The second statement is the base case that binds quotient to the accumulator and remainder to the dividend.
% The third recursive statement increments the accumulator, calculates the difference between dividend and divisor and
% passes this difference as the dividend for the next recursive call.
% For example, if dividend=7 and divisor=3, T1=1 and difference will be 4, and used as next dividend.
% In next call, dividend=4 and divisor=3, T1=2 and difference will be 1, and used as next dividend.
% At this point, dividend(1)<divisor(3), and the second statement becomes true.
% The quotient is bound to current T, that is 2, and remainder is bound to current dividend, that is 1.


% lucas predicate computes the Nth Lucas number (https://en.wikipedia.org/wiki/Lucas_number)

lucas(0, 2).
lucas(1, 1).
lucas(N,X) :- N>1, A is N-1, B is N-2, lucas(A,X1), lucas(B,X2), X is X1+X2.

%Evaluation: The first two statements are facts, since we know that the Lucas number
% for n=0 is 2 and for n=1 is 1. They will be the base cases.
% The third statement checks if N>1 and recursively calls the function with
% N as N-1 and as N-2. The value of the Nth lucas number is stored as the sum of the
% the (n-1)th and (n-2)th lucas number. This is true because, lucas(n) = lucas(n-1) + lucas(n-2)
% according to definition of Lucas numbers.
% For example, if N=3, lucas(2,X1) and lucas(1,X2) are called.
% lucas(2, X1) calls lucas(1,X1)[1] and lucas(0,X2)[2] and binds their sum[3] to X1.
% lucas(1,X2) from the original call binds 1 to X2.
% The answer is the sum of X1 and X2, that is 4.
% In the case that X is an integer, the function then checks if the computed Nth
% Lucas number is equal to X and returns true or false.










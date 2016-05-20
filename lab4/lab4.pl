%%%% CZ3005 2015 Semester 2: Lab 4


%%% OBJECTIVES

%% * Understand the separation of Knowledge from the inference mechanism in Knowledge-Based System
%% (KBS).

%% * Understand that the inference process can be represented in the form of AND-OR tree; where AND
%% branches are the premises and OR branches are the alternative matching in the KBS.

%% * Appreciate the structure of the AND-OR is heavily influenced by the ordering of the facts and
%% rules in the KBS.

%% * Understand the process of unification in zero and first order logic.



%%%% INTRODUCTION

%% Prolog is a simple but powerful programming language originally developed at the University of
%% Marseilles, as a practical tool for programming in logic. From a user's point of view the major
%% attraction of the language is ease of programming. Clear, readable, concise programs can be
%% written quickly with few errors. Prolog is especially suitable for high-level symbolic
%% programming tasks and has been applied in many areas of Artificial Intelligence. It is a
%% declarative language which separates the knowledge in the form of facts and rules from the
%% inference mechanism. This example worksheet allows you to develop a basic knowledge on the use,
%% working and operation of Prolog as well as the creation of declarative knowledge.

%% http://www.learnprolognow.org/lpnpage.php?pageid=teaching



%%%% HOW TO RUN PROLOG

%% SWI-Prolog's website has lots of information about SWI-Prolog, a download area, and
%% documentation.

%%      http://www.swi-prolog.org/
%%      http://www.swi-prolog.org/pldoc/doc_for?object=root
%%      http://www.swi-prolog.org/download/stable/doc/
%%		https://www.youtube.com/watch?v=SykxWpFwMGs

%% The examples in this tutorial use a simplified form of interaction with a typical Prolog
%% interpreter. The sample programs should execute similarly on any system using an Edinburgh-style
%% Prolog interpreter or interactive compiler.

%% A startup message or banner may appear, and that will soon be followed by a goal prompt looking
%% similar to the following

%% On Linux, the interactive shell executable is usually called swipl.

%% Interactive goals in Prolog are entered by the user following the '?- ' prompt. Many Prologs have
%% command-line help information. SWI Prolog has extensive help information. This help is indexed
%% and guides the user. To learn more about it, try

help(help).

%% Notice that all of the displayed symbols need to be typed in, followed by a carriage return.

%% To illustrate some particular interactions with prolog, consider the following sample session.
%% Each file referred to is assumed to be a local file in the user's account, which was either
%% created by the user, obtained by copying directly from some other public source, or obtained by
%% saving a text file while using a web browser. The way to achieve the latter is either to follow a
%% URL to the source file and then save, or to select text in a Prolog Tutorial web page, copy it,
%% paste into a text editor window and then save to file. The comments /* ... */ next to goals are
%% referred to in the notes following the session.

consult('factorial.pl'). /* 1. Load a program from a local file */
%% % factorial.pl compiled 0.00 sec, 1 clauses
%% true.

listing(factorial/2). /* 2. List program to the screen */
%% factorial(0, 1).
%% factorial(A, C) :-
%%     A>0,
%%     B is A+ -1,
%%     factorial(B, D),
%%     C is A*D.
%% true.

factorial(10,What). /* 3. Compute factorial of 10 */
%% What = 3628800 ; /* press ; to obtain more results */
%% false. /* but there are no more results */

consult('takeout.pl'). /* 4. Load another program */
%% % takeout.pl compiled 0.00 sec, 3 clauses
%% true.

listing(takeout).
%% takeout(A, [A|B], B).
%% takeout(B, [A|C], [A|D]) :-
%%     takeout(B, C, D).
%% true.

takeout(X,[1,2,3,4],Y). /* 5. Take X out of list [1,2,3,4] */
%% X = 1,
%% Y = [2, 3, 4] ;
%% X = 2,
%% Y = [1, 3, 4] ;
%% X = 3,
%% Y = [1, 2, 4] ;
%% X = 4,
%% Y = [1, 2, 3] ;
%% false. /* Means: No more answers. */

takeout(X,[1,2,3,4],_), X>3. /* 6. Conjunction of goals */
%% X = 4 ;
%% false.

halt. /* 7. Return to OS */


%% We discuss several points now, while other details will be deferred to later sections. Notes:

%% 1. A Prolog goal is terminated with a period "." In this case the goal was to load a program
%% file. This "bracket" style notation dates back to the first Prolog implementations. Several files
%% can be chain loaded by listing the filenames sequentially within the brackets, separated by
%% commas. In this case, the file's name is factorial.pl The program file was located in the current
%% directory. If it had not been, then the path to it would have to have been specified in the usual
%% way.

%% 2. The built-in predicate 'listing' will list the program in memory -- in this case, the
%% factorial program.

%% 3. The goal here, 'factorial(10,What)', essentially says "the factorial of 10 is What?". The word
%% 'What' begins with an upper-case letter, denoting a logical variable. Prolog satisfies the goal
%% by finding the value of the variable 'What'.

%% 4. Both "programs" now reside in memory, from the two source factorial.pl and takeout.pl.

%% 5. In the program just loaded is a definition of the logical predicate 'takeout'. The goal
%% 'takeout(X,[1,2,3,4],Y)' asks that X be taken out of list [1,2,3,4] leaving remainder list Y, in
%% all possible ways. There are four ways to do this, as shown in the response. Each of this is an
%% OR-branch in the entire search tree. Note, however, how Prolog is prodded to produce all of the
%% possible answers: After producing each answer, Prolog waits with a cursor at the end of the
%% answer. If the user types a semicolon ';' , Prolog will look for a next answer (alternative-OR
%% branch), and so on. If the user just hits Enter, then Prolog stops looking for alternative
%% answers.

%% 6. A compound or conjunctive goal asks that two individual goals be satisfied. Note the
%% arithmetic goal (built-in relation), 'X>3'. Prolog will attempt to satisfy these goals in the
%% left-to-right order, just as they would be read. In this case, there is only oneanswer. Note the
%% use of an anonymous variable '_' in the goal, for which no binding is reported ("don't-care
%% variable").

%% 7. The 'halt' goal always succeeds and returns the user to the operating system.



%%%% LOADING PROGRAMS, EDITING PROGRAMS

%% The standard Prolog predicates for loading programs are 'consult', 'reconsult', and the bracket
%% loader notation '[ ...]'. For example, the goal ?- consult('family.pl'). opens the file family.pl
%% and loads the clauses in that file into memory.

%% There are two main ways in which a prolog program can be deficient: either the source code has
%% syntax errors, in which case there will be error messages upon loading, or else there is a
%% logical error of some sort in the program, which the programmer discovers by testing the program.
%% The current version of a prolog program is usually considered to be a prototype for the correct
%% version in the future, and it is a common practice to edit the current version and reload and
%% retest it. This rapid prototyping appraoch works nicely provided that the programmer has devoted
%% sufficient time and effort to analyzing the problem at hand. Interestingly, if the rapid
%% prototyping approach seems to be failing, this is an excellent signal to take up paper and
%% pencil, rethink the requirements, and start over!

%% We could call the built-in editor from within SWI-Prolog

edit('family.pl'). %% SWI-Prolog (built-in) defined edit, see below ...

%% and then upon returning from the editor (and assuming that the new version of the file was
%% resaved using the same file name), one could use the goal

reconsult('family.pl').

%% to reload the program clauses into memory, automatically replacing the old definitions. If one
%% had used 'consult' rather than 'reconsult' the old (and possibly incorrect) clauses would have
%% remained in memory along with the new clauses (this depends upon the Prolog system, actually).

%% If several files have been loaded into memory, and one needs to be reloaded, use 'reconsult'. If
%% the reloaded file defines predicates which are not defined in the remaining files then the reload
%% will not disturb the clauses that were originally loaded from the other files.

%% The bracket notation is very handy. For example, ['family.pl', 'p.pl']. would load (effectively
%% reconsult ) all 2 files into prolog memory.

%% To use a custom editor, edit the file user-edit.pl with your favorite editor, then

consult('user-edit.pl').

%% and then an 'user-edit' goal can be used (again assume that the file to edit is local to the
%% prolog session)

user_edit('p.pl').

%% After editing and saving the prolog program, we can reconsult the new version in the prolog
%% session using reconsult('p.pl').

%% It is possible to modify the edit program to suit the user's particular circumstances (various
%% prologs, various operating systems, various editors).

%% Alternatively you may use the built predicate edit that is supplied with SWI-prolog.

edit('p.pl').

%% To load clauses supplied interactively by the user, use the goals:
consult(user).
reconsult(user).
[user].
%% The user then types in clauses interactively, using stop '.' at the end of clauses, and ^D (EOF)
%% to end input.

%% Analyze how the edit program works. First, try goals ... ?- name('name',NameString).
%% and ?- name(Name,"name")

?????



%%%% PROLOG AS A KNOWLDEGE BASE SYSTEM

%% The prolog knowledge base contains 2 types of knowledge sentences; namely: facts and rules. The
%% inference mechanism is separated from the KB and is part of the Prolog engine. Facts can be
%% propositional symbols or predicate terms.

%% Facts can be as simple as:
'It is raining today'.
%% or
jill.

%% Useful facts usually contain predicates:
boy(jack).
girl(jill).
friends(jack, jill).
go(jack, jill, 'up the hill').
give(jack, jill, crown).

%% Names of constants and predicates begin with a lower case letter. The predicate (attribute
%% or relationship, if you will) is written first, and the following objects are enclosed by a
%% pair or parenthesis and separated by commas. Every fact ends with the period character
%% '.'.

%% Order is generally speaking arbitrary, but once you decide on the order, you should be
%% consistent. For example:

eating(vladimir, burger).

%% intuitively means that "Vladimir is eating a burger". We could have chosen to put the
%% object of eating (i.e. food) first:

eating(burger, vladimir).

%% which we can interpret as "A burger is being eaten by Vladimir". The order is arbitrary in that
%% sense. Rule of thumb is to use 'intuitive' order, sticking to the English language when possible.
%% Typically predicates are used to define characteristics/properties (unary predicates or
%% relationships (binary or n-ary predicates) Examples are given as follows:

characteristicA(anthony). /* an unary property governing the term anthony */
characteristicB(X). /* an unary property governing the variable X */
anthony. /* propositional term */
brother(charles, andrew). /* brother relationship existing between charles and andrew */
sibling(X, Y). /* X and Y are logical variables and the sibling predicate defines the
                  relationship of sibling between X and Y. */

%% These are used in the formulation of rules; which has the following form: if "premise 1" and
%% "premise 2" then "conclusion" and is written in prolog in the following format: "conclusion" :-
%% "premise 1", "premise 2". Eg.

%% Facts:
male(charles).
female(diana).
%% Rules:
possible_couple(X, Y) :- male(X), female(Y).
possible_couple(X, Y) :- female(X), male(Y).
%% These two rules are alternative ways to define the possibility of being a couple.

%% Rules are used to express dependency between a fact and another fact:
child(X, Y) :- parent(Y, X).
odd(X) :- not even(X).
%% or a group of facts:
son(X, Y) :- parent(Y, X) , male(X).
child(X, Y) :- son(X, Y) ; daughter(X, Y).



%%%%% PROLOG DERIVATION TREES, CHOICES, AND UNIFICATION

%% To illustrate how Prolog produces answers for programs and goals, consider the following simple
%% datalog program (no functions).

p(a).                /* #1 */
p(X) :- q(X), r(X).  /* #2 */
p(X) :- u(X).        /* #3 */

q(X) :- s(X).        /* #4 */


r(a).                /* #5 */
r(b).                /* #6 */


s(a).                /* #7 */
s(b).                /* #8 */
s(c).                /* #9 */

u(d).                /* #10 */

%% Load program P into Prolog and observe what happens for the goal ?-p(X). When an answer is
%% reported, hit (or enter) ';' so that Prolog will continue to trace and find all of the answers.

????? exercise ?????

%% Load program P into Prolog, turn on the trace, and record what happens for the goal
%% ?-p(X). When an answer is reported, hit (or enter) ';' so that Prolog will continue to trace and
%% find all of the answers. (Use ?- help(trace). first, if needed.)

????? exercise ?????

%% Another fine tutorial is here: http://www.swi-prolog.org/pldoc/man?section=debugoverview

%% The following diagram, shows a complete Prolog derivation tree for the goal ?- p(X). The edges in
%% the derivation tree are labeled with the clause number in the source file for program P that was
%% used to replace a goal by a subgoal. The direct descendantsunder any goal in the derivation tree
%% correspond to choices. For example, the top goal p(X) unifies with the heads of clauses #1, #2,
%% #3, three choices.

%%                     p(X)
%%          ________ ___|_________
%%          |           |         |
%%          |#1(X=a)    |#2       |#3
%%          |           |         |
%%        true      q(X),r(X)    u(X)
%%        X=a           |         |
%%                      |#4       |#10(X=d)
%%                      |         |
%%                  s(X),r(X)    true
%%                      |        X=d
%%           ___________|____________
%%           |          |           |
%%           |#7(X=a)   |#8(X=b)    |#9(X=c)
%%           |          |           |
%%          r(a)       r(b)        r(c)
%%      _____|____  ____|_____  ____|_____
%%      |        |  |        |  |        |
%%      |#5    #6|  |#5    #6|  |#5    #6|
%%      |        |  |        |  |        |
%%      true  fail  fail  true  fail  fail
%%      X=a               X=b

%% The trace (ii above) of the goal ?-p(X) corresponds to a depth-first traversal of this derivation
%% tree. Each node in the Prolog derivation tree was, at the appropriate point in the search, the
%% current goal. Each node in the derivation tree is a sequence of subgoals. The edges directly
%% below a node in this derivation tree correspond to the choices available for replacing a selected
%% subgoal.

%% The current side clause, whose number labels the arc in the derivation tree, is tried in the
%% following way: If the leftmost current subgoal (shown as g1 in the little diagram below) unifies
%% with the head of the side clause (shown as h in the diagram), then that leftmost current subgoal
%% is replaced by the body of the side clause (shown as b1,b2,...,bn in the diagram). Pictorially,
%% we could show this as follows:

%%      g1,g2,g3,...
%%          |
%%          | h :- b1,b2,...,bn
%%          |
%%      b1,b2,...,bn,g2,g3,...

%% One important thing not shown explicitly in the diagram is that the logical variables in the
%% resulting goal b1,b2,...,bn,g2,g3,... have been bound as a result of the unification, and Prolog
%% needs to keep track of these unifying substitutions as the derivation tree grows down any branch.

%% Now, a depth first traversal of such a derivation tree means that alternate choices will be
%% attempted as soon as the search returns back up the tree to the point where the alternate choice
%% is available. This process is called backtracking to search through alternative OR branches in
%% the matching process.

%% Of course, if the tail of the rule is empty, then the leftmost subgoal is effectively erased. If
%% all the subgoals can eventually be erased down a path in the derivation tree, then an answer has
%% been found (or a 'yes' answer computed). At this point the bindings for the variables can be used
%% to give an answer to the original query.



%%%% UNIFICATION OF PROLOG TERMS

%% Prolog unification matches two Prolog terms T1 and T2 by finding a substitution of variables
%% mapping M such that if M is applied T1 and M is applied to T2 then the results are equal.

%% Unification is an important step in the matching of terms when Prolog attempts to answer a query
%% using refutational proof with resolution as the sound inference rule.

%% For example, Prolog uses unification in order to satisfy equations (T1=T2)

p(X, f(Y), a) = p(a, f(a), Y).
%% X = Y, Y = a.

p(X, f(Y), a) = p(a, f(b), Y).
%% false.

%% In the first case the successful substituton is {X/a, Y/b}, and for the second example there is
%% no substitution that would result in equal terms. In some cases the unification does not bind
%% variables to ground terms but result in variables sharing references ...

p(X, f(Y), a) = p(Z, f(b), a).
%% X = Z,
%% Y = b.

%% In this case the unifying substitution is {X/Z, Y/b}, and X and Z share reference, as can be
%% illustrated by the next goal ...

p(X, f(Y), a) = p(Z, f(b), a), X = d.
%% X = Z, Z = d,
%% Y = b.

%% {X/Z, Y/b} was the most general unifying substitution for the previous goal, and the instance
%% {X/d, Y/b, Z/d} is specialized to satisfy the last goal.

%% Prolog does not perform an occurs check when binding a variable to another term, in case the
%% other term might also contain the variable. For example (SWI-Prolog) ...

X=f(X).
%% X = f(X).

%% This produces a circular reference in this example, but the goal does succeed {X/f(f(f(...)))}.
%% However

X=f(X), X=a.
%% false.

%% The circular reference is checked by the binding, so the goal fails. "a canNOT be unified with
%% f(_Anything)"

a \=f(_).
%% true.

%% Some Prologs have an occurs-check version of unification available for use. For example, in SWI-
%% Prolog

unify_with_occurs_check(X,f(X)).
%% false.

%% The Prolog goal satisfation algoritm, which attempts to unify the current goal with the head of a
%% program clause, uses an instance form of the clause which does not share any of the variables in
%% the goal. Thus the occurs-check is not needed for that.

%% The only possibility for an occurs-check error will arise from the processing of Prolog terms (in
%% user programs) that have unintended circular reference of variables which the programmer believes
%% should lead to failed goals when they occur . Some Prologs might succeed on these circular
%% bindings, some might fail, others may actually continue to record the bindings in an infinite
%% loop, and thus generate a run-time error (out of memory). These rare situations need careful
%% programming.



%%%% THE CUT OPERATOR

%% The Prolog cut predicate, or '!', eliminates choices is a Prolog derivation tree. To illustrate,
%% first consider a cut in a goal. For example, consider goal ?-p(X),!. for the program P used in
%% section 3.1. The cut goal succeeds whenever it is the current goal, AND the derivation tree is
%% trimmed of all other choices on the way back to and including the point in the derivation tree
%% where the cut was introduced into the sequence of goals. For the previous derivation tree, this
%% means that the branches labeled #2 and #3 are eliminated, and hence the entire subtrees below
%% these two edges are also cut off. This then corresponds to only producing the first answer X=a:

p(X),!.
%% X = a.

%% Here we tried to get Prolog to find some more answers using ';' but they have already been cut
%% off. Consider also:

r(X),!,s(Y).
%% X = Y, Y = a ;
%% X = a, Y = b ;
%% X = a, Y = c.

%% Note that there is no backtracking into that first goal. Also,

r(X), s(Y), !.
%% X = Y, Y = a

%% Suppose that a cut occurs in the body of the program. The cut rule (above) still applies when the
%% cut appears as a called subgoal. The cut is used in the body of a given clause so as to avoid
%% using clauses appearing after the given clause in the program. To illustrate, consider the
%% following program:

%%    part(a). part(b). part(c).
%%    red(a). black(b).
%%    color(P,red) :- red(P),!.
%%    color(P,black) :- black(P),!.
%%    color(P,unknown).

['colors.pl'].

%% The intention is to determine a color for a part based upon specific stored information, or else
%% conclude that the color is 'unknown' otherwise. A derivation tree for goal ?- color(a,C) is

color(a,C).
%% C = red.

%% derivation tree for goal ?- color(a,C) is
%%
%%         color(a,C)
%%      __________|_____cutoff
%%      |
%%      | color(P,red) :- red(P),!.
%%      |
%%    red(a),!
%%      |
%%    cutoff

color(c,C).
C = unknown.

%% derivation tree for goal ?- color(c,C) is
%%         color(a,C)
%%      __________|_________|______________________
%%      |                   |                     |
%%      | color(P,red)      | color(P,black)      | color(P,unknown)
%%      |     :- red(P),!   |     :- black(P),!   |
%%      |                   |                    true
%%    red(a),!            black(c)
%%      |                   |
%%    fail                fail


%% The Prolog cut is a procedural device for controlling goal satisfaction. The use of cut affects
%% the meanings of programs. For example, in the 'color' program, the following program clause tree
%% says that 'color(a,unknown)' should be a consequence of the program:

%% The cut in the program enables Prolog to "avoid" this answer. It would be difficult to modify the
%% program clause tree definition (for program consequences) to reflect the procedural meaning of
%% cut. However, program clause trees can still be useful to diagram answers that could result
%% without the cut.

%% What happens if one were to use the (suspect) program

max(X,Y,Y) :- Y>X, !.
max(X,Y,X).

%% What can happen for goal ?-max(1,2,1), for example? Use a clause tree to show that 'max(1,2,1)'
%% is a consequence of the program as it stands. What assumption must one make in order for this
%% Prolog specification to correctly compute the maximum of two numbers?

????? exercise ?????


%% The best use of cut is as an efficiency device, to avoid additional computations that are not
%% desired or required in a program. A use of a cut which only improves efficiency is referred to as
%% a green cut. A good example of a green cut is in the definition of the predicate 'is_same-
%% level_as' in section 2.5. Otherwise the use is a red cut. The use of the cut in the 'color'
%% program is red (pun intended), but the cut  was used to restrict answers -- that is, block what
%% would otherwise be reported as consequences of the program. Here is another version of 'color',
%% using Prolog's implication '->':

%%      color_impl(X,C) :- red(X) -> C = red; black(X) -> C = black; C = unknown.

color_impl(b,C).
%% C = black.



%%%% KNOWLEDGE BASED SYSTEM (KBS) -- FAMILY TREE

%% The most common example of a logic program is the creation of a Knowledge Based System (KBS) of
%% your family tree; set of facts using the following 3 predicates:

%% male = { The males in your family. } - This is an unary predicate
%% female = { The females in your family. } - This is an unary predicate
%% parent_of = { The pairs (x,y) where x is the parent of y in your family. } - This is a binary
%% relationship between x and y, expressing the parenthood of x over y.

%% An example family tree

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

%% This is an example of some basic rules:

    human(H):-male(H).
    human(H):-female(H).
    father(F,C) :- male(F),parent(F,C).
    mother(M,C) :- female(M),parent(M,C).

%% If we only want to find out a predicate, we define a rule like this - with an anonymous variable
%% - by convention denoted as _

    is_father(F) :- father(F,_).
    is_mother(M) :- mother(M,_).

%% You will get to define all the possible family-based rules in your assignment.


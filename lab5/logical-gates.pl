not(1, 0).
not(0, 1).

and(1, 1, 1) :- !.
and(_, _, 0).

or(A_in, B_in, 1) :- A_in == 1, !; B_in == 1, !.
or(0, 0, 0).

xor(A_in, B_in, 1) :- A_in \= B_in,!.
xor(A_in, B_in, 0) :- A_in == B_in.

halfadder(A_in, B_in, Sum_out, Carry_out) :-
    and(A_in, B_in, Carry_out),
    xor(A_in, B_in, Sum_out).

fulladder(A_in, B_in, Carry_in, Sum_out, Carry_out) :-
    xor(A_in, B_in, X),
    and(A_in, B_in, Y),
    and(X, Carry_in, Z),
    xor(Carry_in, X, Sum_out),
    or(Y, Z, Carry_out).

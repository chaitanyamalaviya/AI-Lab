part(a). part(b). part(c).
red(a). black(b).
color(P,red) :- red(P),!.
color(P,black) :- black(P),!.
color(P,unknown).

color_impl(X,C) :- red(X) -> C = red; black(X) -> C = black; C = unknown.

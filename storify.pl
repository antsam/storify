% Story Generator w/ Scary Dungeon
% Anton Samson anton@antonsamson.com
%
% Please use "storify(ACTIONS, STATES)." for text output.
%
% You can also call "test(S, W)." for the default test case.

% Setup
connected(dungeon, forest).
connected(dungeon, mountains).
connected(forest, dungeon).
connected(forest, mountains).
connected(forest, home).
connected(home, lake).
connected(home, forest).
connected(lake, home).
connected(mountains, forest).
connected(mountains, dungeon).
connected(mountains, home).

% Base case
path(X, Y, [X, Y]) :- connected(X, Y).

% List all existing paths between X -> Y
% Reverse the path or it'll be from X -> Y
path(X, Y, P) :-
  visit(X, Y, [X], P1),
	reverse(P1, P).

% Base case
visit(X, Y, P, [Y|P]) :- connected(X, Y).

% Make sure we don't revisit anything or cycle
visit(X, Y, V, P) :-
	connected(X, C),
	C \= Y,
	\+ member(C, V),
	visit(C, Y, [C|V], P).

% Get all possible paths from X to Y.
getPaths(X, Y, C) :-
	findall(P, path(X, Y, P), C).

% Get the size of a list.
size([],0).
size([_|T],N):-
	size(T,M),
	N is M+1.

compareLength(X, A, B) :-
	size(A, C1),
	size(B, C2),
	compare(X, C1, C2).

% Sort the list of lists by length.
shortestPath(X, Y, P) :-
	getPaths(X, Y, C),
	predsort(compareLength, C, [P|_]).


% Iterate through all the actions
transform([], [], _).
transform([H|T], A, S) :-
	transform(H, A1, S),
	transform(T, A2, S),
	append(A1, A2, A), !.

% Move to D from an unconnected node.
transform(move(P, D), [travel(P, L, F)|A], S) :-
	member(at(P, L), S),
	\+ member(at(P, D), S),
	\+ connected(L, D),
	shortestPath(L, D, [_, F|_]), !,
	select(at(P, L), S, S0),
	transform(move(P, D), A, [at(P, F)|S0]).

% Move to D from a connected node.
transform(move(P, D), [travel(P, L, D)], S) :-
	\+ member(at(P, D), S),
	connected(L, D),
	member(at(P, L), S).

% We're already at D!
transform(move(P, D), [travel(P, D, D)], S) :-
	member(at(P, D), S).

% Move to the location of O and take the object!
transform(get(P, O), A, S) :-
	\+ member(has(P, O), S),
	member(at(O, L), S),
	\+ member(at(P, L), S),
	transform(move(P, L), A0, S),
	append(A0, [take(P, O)], A).

% Already at the location of O, just take it.
transform(get(P, O), [take(P, O)], S) :-
	\+ member(has(P, O), S),
	member(at(O, L), S),
	member(at(P, L), S), !.

% Update the world state after getting an object.
do(get(P, O), S, S2) :-
	member(at(P, L), S),
	member(at(O, D), S),
	select(at(P, L), S, S0),
	select(at(O, D), S0, S1),
	append([at(P, D), has(P, O)], S1, S2), !.

% Update the world state after moving to a location.
do(move(P, D), S, S1) :-
	member(at(P, L), S),
	select(at(P, L), S, S0),
	append([at(P, D)], S0, S1).

% Base case
story([], [], _, []).

% Goal is alone but in a list.
story([H], A, S, W) :- story(H, A, S, W), !.

% Iterate through all the goals in a list.
story([H|T], A, S, W2) :-
	story(H, A1, S, W1),
	story(T, A2, W1, W2),
	append(A1, A2, A), !.

% Come up with an ending for the story!
story(G, A, S, W) :-
	transform(G, A, S),
	do(G, S, W), !.

% Tell transforms lists to human friendly text.
tell([]).
tell([H|T]) :-
	tell(H),
	tell(T).
tell([X]) :- tell(X).

tell(take(P, I)) :-
	write(P),
	write(' takes the '),
	write(I),
	write(' in triumph!'),
	nl.

tell(travel(P, L, D)) :-
	write(P),
	write(' travels from '),
	write(L),
	write(' to '),
	write(D),
	write('.'),
	nl.

tell(at(O, L)) :-
	write(O),
	write(' is at '),
	write(L),
	write('.'),
	nl.

tell(has(P, O)) :-
	write(P),
	write(' has the '),
	write(O),
	write('.'),
	nl.

tell(_).

% Verbose output of story.
storify(G, S) :-
	write('Last time on Arrested Development...'),
	nl,
	tell(S),
	story(G, A, S, W),
	tell(A),
	tell(W), !.

% Default test case.
test(S, W) :- story([get(hero, treasure), move(hero, home)], S, [at(hero, home), at(treasure, dungeon)], W).

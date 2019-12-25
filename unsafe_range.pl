/* ___________________IO___________________  */

%read_from_file
read_from_file(File, [N, Mod], Lines) :-
	 open(File, read, Stream),
	 read_string_(Stream, [N, Mod]),
	 read_lines(Stream, N, Lines).

%read_line into list of ints
read_string_(Stream , Params) :-
	 read_line_to_codes(Stream, Codes),
	 atom_codes(Atom, Codes),
	 atomic_list_concat(Atoms, ' ', Atom),
	 maplist(atom_number, Atoms, Params).

%read_N_lines_from_Stream
read_lines(_, 0, []).
read_lines(Stream, Counter, [X|L]) :-   
	%read
	read_string_(Stream, X),
	%recurse
	New_counter is Counter-1,
	read_lines(Stream, New_counter, L).


/* __________________IO_END___________________ */



%euclidean modulo
em(A, B, Res):-
	M is A rem B,
	(
	(M < 0) ->
		(
			(B < 0) -> 
				Res is M - B
			;
				Res is M + B
		)
	;
		Res = M
	).


wins(L) :-
	L = [1,3,7,15,31,63,127,255,511,1023,2047,4095,
	8191,16383,32767,65535,131071,262143,524287, 1048575].


max_index(1000009).

%ACCESS ARRAY ELEMENT -> 1-indexed. shift by one here
%keep rest of code zero indexed
access(Index, Array, Value) :-
	%safety first
	Index >= 0,
	%shift to get actual index
	Actual_Index is Index + 1,
	arg(Actual_Index, Array, Value).



%calculate ways of n -> iterating winstreaks.
calc(Array, Index, [Win|Rest], Acc, Mod, Res) :-
	%done
	Win > Index -> 
		em(Acc, Mod, Res)
	;
	(	%more winstreaks to add up

		Win =< Index,
		DP_lookback is Index - Win,	
		access(DP_lookback, Array, Elem),

		New_acc is Acc + Elem, 		
		calc(Array, Index, Rest, New_acc, Mod, Res)
	).



%make array
ways(Mod, Ways_Array) :-
	max_index(MAX_INDEX),
	functor(Ways_Array, my_array, MAX_INDEX),
	access(0, Ways_Array, 1),
	access(1, Ways_Array, 1),
	make_ways(2, Mod, Ways_Array).

%building array upwards
make_ways(Index, Mod, Ways_Array) :-
	max_index(Index)	%done
	;
	(
		%add dp[i]
		wins(Wins),
		calc(Ways_Array, Index, Wins, 0, Mod, DP_elem),
		access(Index, Ways_Array, DP_elem),

		%continue upwards
		Succ is Index + 1,
		make_ways(Succ, Mod, Ways_Array)
	).




partial(Mod, Partial_Array) :-
	%MAKE WAYS ONCE
	ways(Mod, Ways_Array),
	max_index(MAX_INDEX),
	functor(Partial_Array, my_array, MAX_INDEX),
	access(0, Partial_Array, 1),
	make_partial(1, Mod, Ways_Array, Partial_Array).

make_partial(Index, Mod, Ways_Array, Partial_Array) :-
	max_index(Index)
	;
	(
		%Fetch
		Index >= 1,
		Prev is Index - 1,
		access(Index, Ways_Array, Ways_I),
		access(Prev, Partial_Array, Part_I),
		
		%Calc
		Raw_elem is Ways_I + Part_I,
		em(Raw_elem, Mod, Elem),
	
		%Store
		access(Index, Partial_Array, Elem),
	
		%Continue
		Succ is Index + 1,
		make_partial(Succ, Mod, Ways_Array, Partial_Array)
	).




solve(0, 0, _, _, 1).
solve(0, N2, Partial_Array, Mod, Res) :-
	N2 > 0,

	% 2 * partial[n2] - 1
	access(N2, Partial_Array, Partial_N2),

	Raw_Res is 2 * Partial_N2 - 1,
	em(Raw_Res, Mod, Res).


solve(N1, N2, Partial_Array, Mod, Res) :-
	N1 > 0,
	N2 > 0,
	But_one is N1 - 1,

	% 2 * (partial[n2] - partial[n1-1])
	access(But_one, Partial_Array, Partial_N1),
	access(N2, Partial_Array, Partial_N2),

	Raw_Res is 2 * (Partial_N2 - Partial_N1),
	em(Raw_Res, Mod, Res).





do_solve([], _, _ , []).
do_solve([[N1, N2] | Rest], Partial_Array, Mod, [Res | Rest_res]) :-
	solve(N1, N2, Partial_Array, Mod, Res),
	do_solve(Rest, Partial_Array, Mod, Rest_res).



final(File, Res) :-
	%read
	read_from_file(File, [_, Mod], Lines),
	%make array
	partial(Mod, Partial_Array),
	%print solutions
	do_solve(Lines, Partial_Array, Mod, Res).
	


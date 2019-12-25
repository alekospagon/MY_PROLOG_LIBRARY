/* ___________________IO___________________  */

%read_from_file
read_from_file(File, Params, Lines) :-
	 open(File, read, Stream),
	 read_params(Stream, Params),
	 Params = [N | _],
	 read_lines(Stream, N, Lines).

%read_first_line
read_params(Stream , Params) :-
	 read_line_to_codes(Stream, Line),
	 atom_codes(Atom, Line),
	 atomic_list_concat(Atoms, ' ', Atom),
	 maplist(atom_number, Atoms, Params).


%useful_for_maplist.
code_char(A,B) :- char_code(B,A).

%read_a_string
read_string_(Stream, Res) :-
	read_line_to_codes(Stream, Codes),	%read_line
	Codes \= "\n",				
	maplist(code_char, Codes, Char_list),	%convert 
	string_to_list(Res, Char_list).		


%read_N_lines_from_Stream
read_lines(_, 0, []).
read_lines(Stream, Counter, [X|L]) :-   
	%read
	read_string_(Stream, X),
	%recurse
	New_counter is Counter-1,
	read_lines(Stream, New_counter, L).


%my_handle_is: read_from_file

%__________________IO_END___________________



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


%ACCESS ARRAY ELEMENT -> 1-indexed. shift by one here
%keep rest of code zero indexed
access(Index, Array, Value) :-
	%safety first
	Index >= 0,
	%shift to get actual index
	Actual_Index is Index + 1,
	functor(Array, my_array, MAX_INDEX),
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
	make_ways(0, Mod, Ways_Array).

%first cases
make_ways(0, Mod, Ways_Array) :- access(0, Ways_Array, 1).
make_ways(1, Mod, Ways_Array) :- access(1, Ways_Array, 1).
%building array upwards
make_ways(Index, Mod, Ways_Array) :-
	max_index(Index)	%done
	;
	(
		%add dp[i]
		wins(Wins),
		calc(Ways_Array, Index, Wins, 0, Mod, DP_elem),
		access(N, Ways_Array, DP_elem),

		%continue upwards
		Succ is N + 1,
		make_ways(Succ, Mod, Ways_Array)
	).





partial(Mod, Partial_Array) :-
	%MAKE WAYS ONCE
	ways(Mod, Ways_Array),
	make_partial(0, Mod, Ways_Array, Partial_Array).

make_partial(0, Mod, Ways_Array, Partial_Array) :- 
	access(0, Partial_Array, 0).

make_partial(Index, Mod, Ways_Array, Partial_Array) :-
	max_index(Index)
	;
	(
		%Fetch
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
		make_partial(Succ, Mod, Ways_Array, Partial_Array).
	).



solve(0, 0, _, 1).
solve(0, N2, Mod, Res) :-
	N2 > 0,

	memo( partial(N2, Mod, Partial_N2) ),

	Raw_Res is 2 * Partial_N2 - 1,
	em(Raw_Res, Mod, Res).

solve(N1, N2, Mod, Res) :-
	N1 > 0,
	N2 > 0,
	But_one is N1 - 1,
	memo( partial(But_one, Mod, Partial_N1) ),
	memo( partial(N2, Mod, Partial_N2) ),
	Raw_Res is 2 * (Partial_N2 - Partial_N1),
	em(Raw_Res, Mod, Res).



tabling(10000, Mod, Res, Res).
tabling(N, Mod, Temp, Res) :-
	N < 10000,
	


	Succ is N + 1,
	tabling(Succ, Mod).


tabling_h(Mod, Res) :-
	tabling(0, Mod, Res).

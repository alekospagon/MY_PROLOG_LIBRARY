/* PROLOG Array -> UNSAFE.  Using arg on predicate
 *
 * Each node contains slots forN elements and K subtrees.
 *
*/

max_index(1000009).	%max index for my array.

%my handle of accessing
access_arr(Index, Array, Value) :-
	%safety first
	integer(Index),   	
	Index > 0,

	%access
	access(Index, Array, Value).

%accessing
access(Index, Array, Value) :-
	max_index(MAX_INDEX),
	functor(Array, my_array, MAX_INDEX),
	arg(Index, Array, Value).

make_arr(Index, Array) :-
		%when max index-> Im done
		max_index(Index) 
	;
		(
			Index < 1000009,
			%sample tree -> on third term store 
			%your values. (I store the index)
			access_arr(Index, Array, Index),
			Succ is Index + 1,
			make_arr(Succ, Array)
		).



%make an array and fetch index
indexing(Index, Result) :-
		make_arr(1, Array),
		access_arr(Index, Array, Result).

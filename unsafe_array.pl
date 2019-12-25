/* PROLOG Array -> UNSAFE.  Using arg on predicate
 *
 * Naming a term "my_array" with arity: max_index
 *
 * Then accessing its arguments with arg in O(1)
 *
*/

max_index(1000009).	%max index for my "array".

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
	%making Term: my_array
	functor(Array, my_array, MAX_INDEX),
	%take Value from my_array at index: Index
	arg(Index, Array, Value).

%make a sample array with arr[i] = i
make_arr(Index, Array) :-
		%when max index-> Im done
		max_index(Index) 
	;
		(
			access_arr(Index, Array, Index),
			Succ is Index + 1,
			make_arr(Succ, Array)
		).



%make an array and fetch index
indexing(Index, Result) :-
		make_arr(1, Array),
		access_arr(Index, Array, Result).

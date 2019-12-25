/* PROLOG N_plus_K_tree -> fast index 
 *
 * Each node contains slots forN elements and K subtrees.
 *
 */

%Tree parameters
%choose power of 2 to avoid inefficient mod/div calculations
n(1024).		%node elements  -> 2^10
k(32).			%subtrees hanging from node -> 2^5
log_k(5).
max_index(1000009).	%max index for my array.

%my handle of accessing
access_N_plus_K(Index, Tree, Value) :-
	integer(Index),   	%safety first
	Index > 0,
	access_N_K(Index, Tree, Value).

%accessing
access_N_K(Index, Tree, Value) :-
	%fetch N and K
	n(N), k(K), log_k(Log_K),
	Sum is N+K,

	%n_plus_k( ..... ) -> N+K arguments
	functor(Tree, n_plus_k, Sum),

	(
		%Data if found here with Index <= N
		Index =< N ->
		arg(Index, Tree, Value)

		%I must go deeper in N_plus_K tree
		;	
			%with subtree?
			Sht_Idx is (Index - (N+1)),		%skip first N + 1 elems
			%a mod b when b = 2^k is { a bitwise_and (k - 1) }
			Mod_Idx is Sht_Idx /\ (K - 1),
			SonIndex is Mod_Idx + N + 1,	%add back first N + 1 elems
			%index on subtree: a div 2^k is a >> log(k) + 1
			NewIndex is (Index - N - 1) >>  Log_K + 1,
			arg(SonIndex, Tree, Son),
			%go deeper
			access_N_K(NewIndex, Son, Value)
		).



	make_arr(Index, Tree) :-
		%when max index-> Im done
		max_index(Index) 
	;
		(
			Index < 1000009,
			%sample tree -> on third term store 
			%your values. (I store the index)
			access_N_plus_K(Index, Tree, Index),
			Succ is Index + 1,
			make_arr(Succ, Tree)
		).

	%make a tree and fetch index
	indexing(Index, Result) :-
		make_arr(1, Tree),
		access_N_plus_K(Index, Tree, Result).

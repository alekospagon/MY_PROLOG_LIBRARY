/* PROLOG N_plus_K_tree -> fast index 
 *
 * Each node contains slots forN elements and K subtrees.
 *
*/

%Tree parameters
%choose power of 2 to avoid complex mod/div calculations
n(10000).             %node elements
k(10).                %subtrees hanging from node
max_index(1000009).   %max index for my array.

%my handle of accessing
access_N_plus_K(Index, Tree, Value) :-
	integer(Index),   	%safety first
	Index > 0,
	access_N_K(Index, Tree, Value).

%accessing
access_N_K(Index, Tree, Value) :-
	%fetch N and K
	n(N), k(K),
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
    SonIndex is (Index - N - 1) mod K + N + 1,
    %index on subtree
		NewIndex is (Index - N - 1) //  K + 1,
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
	access_N_K(Index, Tree, Result).

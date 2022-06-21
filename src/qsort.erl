-module(qsort).


-export([start/1
	]).




%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start([Pivot|T]) ->
    start([ X || X <- T, X < Pivot]) ++
    [Pivot] ++
    start([ X || X <- T, X >= Pivot]);
start([]) -> [].

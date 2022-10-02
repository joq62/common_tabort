-module(list_duplicates).



-export([remove/1
	]).


%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
remove([])->
    [];
remove(L)->
    lists:reverse(remove(L,[])).

remove([],Acc)->
    Acc;
remove([Item|T],Acc)->
    NewAcc=case lists:member(Item,Acc) of
	       true->
		   Acc;
	       false->
		   [Item|Acc]
	   end,
    remove(T,NewAcc).
   

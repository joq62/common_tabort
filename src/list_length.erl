-module(list_length).



-export([start/1
	]).


%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start([])->
    0;
start(L)->
    start(L,0).

start([],Len)->
    Len;
start([_|T],Acc)->
    start(T,Acc+1).
   

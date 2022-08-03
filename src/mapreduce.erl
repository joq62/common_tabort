-module(mapreduce).



-import(lists, [foreach/2]).
-include_lib("stdlib/include/qlc.hrl").

-export([start/4
	]).


%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start(F1,F2,Acc0,L)->
    S=self(),
    Pid=spawn(fun()->
		      reduce(S,F1,F2,Acc0,L) end),
    receive
	{Pid,Result}->
	    Result
    end.

reduce(Parent,F1,F2,Acc0,L)->
    process_flag(trap_exit,true),
    ReducePid=self(),
    foreach(fun(X)->
		    spawn_link(fun()->
				       do_job(ReducePid,F1,X) end)
	    end, L),
    N=length(L),
  %  io:format("~p~n",[{?MODULE,?LINE,N}]),
    Dict0=dict:new(),
    Dict1=collect_replies(N,Dict0),
  %  io:format("~p~n",[{?MODULE,?LINE,Dict1}]),
    Acc = dict:fold(F2, Acc0,Dict1),
    Parent!{self(),Acc}.

collect_replies(0,Dict)->
    Dict;
collect_replies(N,Dict) ->
   %io:format("N= ~p~n",[{?MODULE,?LINE,N}]),
    receive
	{Key,Value}->
 	    case dict:is_key(Key,Dict) of
		true->
		    Dict1=dict:append(Key,Value,Dict),
		    collect_replies(N,Dict1);
		false ->
		    Dict1=dict:store(Key,[Value],Dict),
		    collect_replies(N,Dict1)
		end;
	{'EXIT',_,_Why} ->
       %    io:format("~p~n",[{?MODULE,?LINE,Why,Dict}]),
	    collect_replies(N-1,Dict)
    end.
	    
do_job(ReducePid, F, X)->
%   io:format("Do job ~p~n",[{?MODULE,?LINE,F,X}]),
    F(ReducePid,X).

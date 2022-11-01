%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(count).


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
-export([init_regular/0,init_dir/0,init_error/0,regular/2,dir/2,error/3]).


%% ====================================================================
%% External functions
%% ====================================================================

init_regular()->
    [0].
init_dir()->
    [0].
init_error()->
    [0].

regular(FilePath,[N]) ->
    io:format("~p~n",[{FilePath,N}]),
    N1=N+1,
    [N1].

dir(DirPath,[N])->
    io:format("~p~n",[{DirPath,N}]),
    N1=N+1,
    [N1].
error(_Path,Reason,[NumErrors])->
    io:format("Error in dfs ~p~n",[Reason]),
    [NumErrors+1].


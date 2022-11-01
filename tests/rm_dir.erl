%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(rm_dir).


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
    [].
init_dir()->
    [].
init_error()->
    [0].

regular(FilePath,Acc) ->
    io:format("~p~n",[{FilePath}]),
    [FilePath|Acc].

dir(DirPath,Acc)->
    io:format("~p~n",[{DirPath}]),
    [DirPath|Acc].

error(Path,Reason,[NumErrors])->
    io:format("Error in dfs ~p~n",[{Path,Reason}]),
    [NumErrors+1].


%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(dfs_test).
 

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
-export([start/0]).


%% ====================================================================
%% External functions
%% ====================================================================

start()->
    Root="config",
    {Reg,Dir,Error}=dfs:search(Root,rm_dir),
    [file:delete(FileName)||FileName<-Reg],
    [file:del_dir(DirName)||DirName<-Dir],
    file:del_dir(Root),
    
    io:format("Reg ~p~n",[Reg]),
    io:format("Dir  ~p~n",[Dir]),
    io:format("Error ~p~n",[Error]).

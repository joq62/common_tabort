%%% -------------------------------------------------------------------
%%% Author  : Joq
%%% Description : 
%%% Generic depth first search: 
%%% Function: search(RootDir,Module)-> {[RegularAction],[DirAction],[ErrorAction]}
%%% The Module needs to implement following functions that are used by dfs
%%%    RegularAcc=Module:init_regular(),
%%%    DirAcc=Module:init_dir(),
%%%    ErrorAcc=Module:init_error(),
%%%    RegularAcc1= Module:regular(Next_Fullname,RegularAcc),
%%%    DirAcc2 = Module:dir(Next_Fullname,DirAcc),
%%%    ErrorAcc2=Action:error(Next_Fullname,Reason,ErrorAcc),
%%%
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(dfs).


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-include_lib("kernel/include/file.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([search/2]).


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
search(RootDir,Action)->
    RegularAcc=Action:init_regular(),
    DirAcc=Action:init_dir(),
    ErrorAcc=Action:init_error(),
    {RegularResult,DirResult,ErrorResult}=dfs(RootDir,RegularAcc,DirAcc,ErrorAcc,Action),
    {RegularResult,DirResult,ErrorResult}.
    

dfs(Path,RegularAcc,DirAcc,ErrorAcc,Action)->
    case filelib:is_dir(Path) of
	true ->
	    case file:list_dir(Path)of
		{ok,Path_dir_list} ->
		    {RegularAcc1,DirAcc1,ErrorAcc1} = dfs(Path_dir_list,Path,RegularAcc,DirAcc,ErrorAcc,Action),
		    Result={RegularAcc1,DirAcc1,ErrorAcc1};
		{error,Result} ->
		    io:format("Error - Root is not a directory ~p~n",[Path])
	    end;
	false ->
	    Result = {error},
	    io:format("Error - Root is not a directory ~p~n",[Path])
    end,
    Result.

%%
%% Local Functions
%%
		
dfs([],_Path,RegularAcc,DirAcc,ErrorAcc,_Action) ->
      {RegularAcc,DirAcc,ErrorAcc};
	
dfs(Dir_list,Path,RegularAcc,DirAcc,ErrorAcc,Action) ->
    [Next_node|T] = Dir_list,
    Next_Fullname = filename:join(Path,Next_node),
    case file_type(Next_Fullname) of
	regular ->
	    RegularAcc1= Action:regular(Next_Fullname,RegularAcc),
	    DirAcc1=DirAcc,
	    ErrorAcc1=ErrorAcc;
	directory ->
	    case file:list_dir(Next_Fullname) of
		{ok,Next_node_Dir_list} ->
		    DirAcc2 = Action:dir(Next_Fullname,DirAcc),
		 %   io:format(" ~p~n",[{?MODULE,?LINE,[DirAcc2]}]),
		    {RegularAcc1,DirAcc1,ErrorAcc1} = dfs(Next_node_Dir_list,Next_Fullname,RegularAcc,DirAcc2,ErrorAcc,Action);
		{error, Reason} ->          %% troligen en fil som det inte går att accessa ex H directory
		    ErrorAcc2=Action:error(Next_Fullname,Reason,ErrorAcc),
		    %io:format("Error in dfs ~p~n",[Reason]),
		    %io:format("Error in dir/file ~p~n",[file:list_dir(Next_Fullname)]),
		    {RegularAcc1,DirAcc1,ErrorAcc1}= dfs(T,Path,RegularAcc,DirAcc,ErrorAcc2,Action)
	    end;
	X ->
	    %io:format("Error in dfs ~p~n",[X]),
	    ErrorAcc2=Action:error(Next_Fullname,X,ErrorAcc),
	    {RegularAcc1,DirAcc1,ErrorAcc1}= dfs(T,Path,RegularAcc,DirAcc,ErrorAcc2,Action)
    end,
    dfs(T,Path,RegularAcc1,DirAcc1,ErrorAcc1,Action).

%%********************************************************************

file_type(File) ->
    case file:read_file_info(File) of
	{ok, Facts} ->
	    case Facts#file_info.type of
		regular   -> regular;
		directory -> directory;
		X         -> {error,X}
	    end;
	Y ->
	    {error,Y}
    end.

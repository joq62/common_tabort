%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(local_vm).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%%---------------------------------------------------------------------
%% Records for test
%%

-define(IsDir(Dir),"test -d "++Dir++" && echo true || echo false").
%% --------------------------------------------------------------------
%-compile(export_all).
-export([
	 create/1,
	 create/3,
	 create_dir/2,
	 create_dir/4,
	 
	 delete/1,
	 delete/2
	]).
	 	 

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
create(NodeName)->
    {ok,HostName}=net:gethostname(),
    Cookie=atom_to_list(erlang:get_cookie()),
    PaArgs=" ",
    EnvArgs=" ",
    create(HostName,NodeName,Cookie,PaArgs,EnvArgs).    

create(NodeName,PaArgs,EnvArgs)->
    {ok,HostName}=net:gethostname(),
    Cookie=atom_to_list(erlang:get_cookie()),
    create(HostName,NodeName,Cookie,PaArgs,EnvArgs).

create_dir(NodeName,NodeDir)->
    Reply=case create(NodeName) of
	      {ok,SlaveNode}->
		  case rpc:call(SlaveNode,code,add_patha,[NodeDir]) of
		      {badrpc,Error}->
			  {error,[badrpc,Error,SlaveNode]};
		      {error,bad_directory}->
			  {error,[bad_directory,NodeDir]};
		      true-> {ok,SlaveNode}
		  end
	  end,
    Reply.

create_dir(NodeName,NodeDir,PaArgs,EnvArgs)->
    Reply=case create(NodeName,PaArgs,EnvArgs) of
	      {ok,SlaveNode}->
		  case rpc:call(SlaveNode,code,add_patha,[NodeDir]) of
		      {badrpc,Error}->
			  {error,[badrpc,Error,SlaveNode]};
		      {error,bad_directory}->
			  {error,[bad_directory,NodeDir]};
		      true-> {ok,SlaveNode}
		  end
	  end,
    Reply.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
create(HostName,NodeName,Cookie,PaArgs,EnvArgs)->
    Args=PaArgs++" "++"-setcookie "++Cookie++" "++EnvArgs,
    Result=case slave:start(HostName,NodeName,Args) of
	       {error,Reason}->
		   {error,[Reason]};
	       {ok,SlaveNode}->
		   case net_kernel:connect_node(SlaveNode) of
		       false->
			   {error,[failed_connect,SlaveNode]};
		       ignored->
			   {error,[ignored,SlaveNode]};
		       true->
			   {ok,SlaveNode}
			   
		   end
	   end,
    Result.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------	       
delete(Node)->
    slave:stop(Node).

delete(Node,Dir)->
    rpc:call(Node,os,cmd,["rm -rf "++Dir]),
    slave:stop(Node).


%%================== EOF ==============================================

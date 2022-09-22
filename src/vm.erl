%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(vm).  
   
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
	 check_started_node/1,
	 check_stopped_node/1,
	 check_started_node/3,
	 check_stopped_node/3,

	 create_local/1,
	 create_local/3,
	 create_local_dir/2,
	 create_local_dir/4
	]).
	 	 
-export([	 
	 create/6,
	 create/5,
	 delete/1,
	 delete/2,
	 ssh_create/6,
	 ssh_create/7,
	 is_dir_ssh/2
	]).
	 

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
create_local(NodeName)->
    {ok,HostName}=net:gethostname(),
    Cookie=atom_to_list(erlang:get_cookie()),
    PaArgs=" ",
    EnvArgs=" ",
    create(HostName,NodeName,Cookie,PaArgs,EnvArgs).    

create_local(NodeName,PaArgs,EnvArgs)->
    {ok,HostName}=net:gethostname(),
    Cookie=atom_to_list(erlang:get_cookie()),
    create(HostName,NodeName,Cookie,PaArgs,EnvArgs).

create_local_dir(NodeName,NodeDir)->
    Reply=case create_local(NodeName) of
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

create_local_dir(NodeName,NodeDir,PaArgs,EnvArgs)->
    Reply=case create_local(NodeName,PaArgs,EnvArgs) of
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
%% --------------------------------------------------------------------
create(HostName,NodeDir,NodeName,Cookie,PaArgs,EnvArgs)->
  %  io:format("HostName ~p~n",[HostName]),
  %  io:format("NodeDir ~p~n",[NodeDir]),
  %  io:format("NodeName ~p~n",[NodeName]),
  %  io:format("PaArgs ~p~n",[{PaArgs,?MODULE,?LINE}]),
  %  io:format("Cookie ~p~n",[Cookie]),
  %  io:format("EnvArgs ~p~n",[EnvArgs]),

    Args=PaArgs++" "++"-setcookie "++Cookie++" "++EnvArgs,
    Result=case slave:start(HostName,NodeName,Args) of
	       {error,Reason}->
		   {error,[Reason,?MODULE,?LINE]};
	       {ok,SlaveNode}->
		   case net_kernel:connect_node(SlaveNode) of
		       false->
			   {error,[failed_connect,SlaveNode]};
		       ignored->
			   {error,[ignored,SlaveNode]};
		       true->
			   case rpc:call(SlaveNode,code,add_patha,[NodeDir],1000) of
			       {badrpc,Error}->
				   {error,[badrpc,Error,SlaveNode]};
			       {error,bad_directory}->
				   {error,[bad_directory,NodeDir]};
			       true-> {ok,SlaveNode}
			   end
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





%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_dir_ssh(Dir,
	   {Ip,SshPort,Uid,Pwd,TimeOut})->
    case my_ssh:ssh_send(Ip,SshPort,Uid,Pwd,?IsDir(Dir),TimeOut) of
	["false"]->
	    false;
	["true"] ->
	    true;
	ok ->
	    true;
	Reason ->
	    io:format(" Reason ~p~n",[Reason]),
	    {error,[Reason]}
    end.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
ssh_create(HostName,NodeName,NodeDir,Cookie,PaArgs,EnvArgs,
	   {Ip,SshPort,Uid,Pwd,TimeOut})->
    my_ssh:ssh_send(Ip,SshPort,Uid,Pwd,"rm -rf "++NodeDir,TimeOut),
    my_ssh:ssh_send(Ip,SshPort,Uid,Pwd,"mkdir "++NodeDir,TimeOut),
    ssh_create(HostName,NodeName,Cookie,PaArgs,EnvArgs,
	   {Ip,SshPort,Uid,Pwd,TimeOut}).

ssh_create(HostName,NodeName,Cookie,PaArgs,EnvArgs,
	   {Ip,SshPort,Uid,Pwd,TimeOut})->
    Node=list_to_atom(NodeName++"@"++HostName),
    rpc:call(Node,init,stop,[],5000),
    true=check_stopped_node(100,Node,false),
    Args=PaArgs++" "++"-setcookie "++Cookie++" "++EnvArgs,

    Msg="erl -sname "++NodeName++" "++Args++" "++"-detached", 
    Result=case rpc:call(node(),my_ssh,ssh_send,[Ip,SshPort,Uid,Pwd,Msg,TimeOut],TimeOut-1000) of
	       % {badrpc,timeout}-> retry X times       
	       {badrpc,Reason}->
		   {error,[{?MODULE,?LINE," ",badrpc,Reason}]};
	       _Return->
		   case check_started_node(100,Node,false) of
		       false->
			   rpc:call(Node,init,stop,[],5000),
			   {error,[{?MODULE,?LINE," ",couldnt_connect,Node}]};
		       true->
			   {ok,Node}
		   end
	   end,
    Result.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
check_stopped_node(Node)->
    N=50,
    check_stopped_node(N,Node,false).

check_stopped_node(_N,_Node,true)->
    true;
check_stopped_node(0,_Node,Boolean) ->
    Boolean;
check_stopped_node(N,Node,_) ->
 
    Boolean=case net_adm:ping(Node) of
		pong->
		    timer:sleep(100),
		    false;
		pang->
		    true
	    end,
    check_stopped_node(N-1,Node,Boolean).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
check_started_node(Node)->
    N=50,
    check_started_node(N,Node,false).

check_started_node(_N,_Node,true)->
    true;
check_started_node(0,_Node,Boolean) ->
    Boolean;
check_started_node(N,Node,_) ->
    Boolean=case net_adm:ping(Node) of
		  pang->
		    timer:sleep(100),
		      false;
		pong->
		    true
	    end,
    check_started_node(N-1,Node,Boolean).

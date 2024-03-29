%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(ssh_vm).  
   
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
	 create_dir/2,
	 delete_dir/2	 
	]).
	 	 
-export([
	 delete/1,
	 delete/2,
	 create/5,
	 create/6,
	 create/7,

	 is_dir/2
	]).
	 

%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------	 

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------	


create(HostName,NodeName,Cookie,PaArgs,EnvArgs)->
    create(HostName,NodeName,Cookie,PaArgs,EnvArgs,7000).    

create(HostName,NodeName,Cookie,PaArgs,EnvArgs,TimeOut)->    
  %  io:format(" ~p~n",[{?MODULE,?LINE,?FUNCTION_NAME,HostName,Cookie,NodeName,PaArgs,EnvArgs,TimeOut}]),
    Ip=config_node:host_local_ip(HostName),
    SshPort=config_node:host_ssh_port(HostName),
    Uid=config_node:host_uid(HostName),
    Pwd=config_node:host_passwd(HostName),
    create(HostName,NodeName,Cookie,PaArgs,EnvArgs,
	   {Ip,SshPort,Uid,Pwd},TimeOut).
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------	
create(HostName,NodeName,Cookie,PaArgs,EnvArgs,
       {Ip,SshPort,Uid,Pwd},TimeOut)->

    CurrentCookie=erlang:get_cookie(),
    erlang:set_cookie(node(),list_to_atom(Cookie)), 
   
    Node=list_to_atom(NodeName++"@"++HostName),
    rpc:call(Node,init,stop,[],5000),
    true=check_stopped_node(100,Node,false),
    Args=PaArgs++" "++"-setcookie "++Cookie++" "++EnvArgs,
    Msg="erl -sname "++NodeName++" "++Args++" ",
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
    erlang:set_cookie(node(),CurrentCookie),
    Result.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
delete_dir(HostName,Dir)->
    Ip=config_node:host_local_ip(HostName),
    SshPort=config_node:host_ssh_port(HostName),
    Uid=config_node:host_uid(HostName),
    Pwd=config_node:host_passwd(HostName),
    TimeOut=5000,
    my_ssh:ssh_send(Ip,SshPort,Uid,Pwd,"rm -rf "++Dir,TimeOut),
    case ssh_vm:is_dir(Dir,{Ip,SshPort,Uid,Pwd,TimeOut}) of
	false->
	    {ok,Dir};
	true ->
	    {error,["failed to delete ",HostName,Dir,?MODULE,?FUNCTION_NAME,?LINE]}
    end.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
create_dir(HostName,Dir)->
    
    Ip=config_node:host_local_ip(HostName),
    SshPort=config_node:host_ssh_port(HostName),
    Uid=config_node:host_uid(HostName),
    Pwd=config_node:host_passwd(HostName),
    TimeOut=5000,
    my_ssh:ssh_send(Ip,SshPort,Uid,Pwd,"rm -rf "++Dir,TimeOut),
    my_ssh:ssh_send(Ip,SshPort,Uid,Pwd,"mkdir "++Dir,TimeOut),
    timer:sleep(2000),
    case ssh_vm:is_dir(Dir,{Ip,SshPort,Uid,Pwd,TimeOut}) of
	true->
	    {ok,Dir};
	false ->
	    {error,["failed to create ",Dir,?MODULE,?FUNCTION_NAME,?LINE]}
    end.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_dir(Dir,{Ip,SshPort,Uid,Pwd,TimeOut})->
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
%% -------------------------------------------------------------------	 
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
%% -------------------------------------------------------------------	 
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





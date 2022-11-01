%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(ssh_vm_test).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=setup(),

    {ok,HostName}=net:gethostname(),
    ok=t1_test(HostName),
    ok=t2_test(HostName),
    ok=t3_test(HostName), 
    ok=t4_test(HostName), 

    ok=hidden_test(HostName), 

    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    timer:sleep(1000),
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
hidden_test(HostName)->
    NodeName="my_hidden",
    Cookie="hidden_cookie",
    PaArgs=" ",
    EnvArgs=" -hidden ",
   
    N=list_to_atom(NodeName++"@"++HostName),
    {ok,N}= ssh_vm:create(HostName,NodeName,Cookie,PaArgs,EnvArgs),
    pong=net_adm:ping(N),
    ok=vm:delete(N),
    pang=net_adm:ping(N),
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

t4_test(HostName)->
    Ip=config:host_local_ip(HostName),
    Port=config:host_ssh_port(HostName),
    Uid=config:host_uid(HostName),
    Passwd=config:host_passwd(HostName),
    TimeOut=5000,
    NodeName="t",
    NodeDir="ssh_vm_test.dir",
    Cookie=atom_to_list(erlang:get_cookie()),  
    PaArgs="-pa erlang ",
    EnvArgs=" ",  
  
    ssh_vm:delete_dir(HostName,NodeDir),
    ssh_vm:create_dir(HostName,NodeDir),
   
    File="test.file",
    FilewPath="erlang/test.file",
    N=list_to_atom("t"++"@"++HostName),
    {ok,N}=ssh_vm:create(HostName,NodeName,Cookie,PaArgs,EnvArgs,
			 {Ip,Port,Uid,Passwd,TimeOut}),
    pong=net_adm:ping(N),
    non_existing=code:where_is_file(File),
    FilewPath=rpc:call(N,code,where_is_file,[File]),
    true=rpc:call(N,filelib,is_dir,[NodeDir]),
    ok=vm:delete(N,NodeDir),
    pang=net_adm:ping(N),
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),  
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

t3_test(HostName)->
    Ip=config:host_local_ip(HostName),
    Port=config:host_ssh_port(HostName),
    Uid=config:host_uid(HostName),
    Passwd=config:host_passwd(HostName),
    TimeOut=5000,
    NodeName="t",
    NodeDir="ssh_vm_test.dir",
     
    ssh_vm:delete_dir(HostName,NodeDir),
    ssh_vm:create_dir(HostName,NodeDir),
   
    N=list_to_atom("t"++"@"++HostName),
    {ok,N}=ssh_vm:create(HostName,NodeName,
			 {Ip,Port,Uid,Passwd,TimeOut}),
    pong=net_adm:ping(N),
    true=rpc:call(N,filelib,is_dir,[NodeDir]),
    ok=vm:delete(N,NodeDir),
    pang=net_adm:ping(N),
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),  
    ok.
    

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

t2_test(HostName)->
    Ip=config:host_local_ip(HostName),
    Port=config:host_ssh_port(HostName),
    Uid=config:host_uid(HostName),
    Passwd=config:host_passwd(HostName),
    TimeOut=5000,
    NodeName="t",
    Cookie=atom_to_list(erlang:get_cookie()),

    File="test.file",
    FilewPath="erlang/test.file",
    PaArgs="-pa erlang ",
    EnvArgs=" ",
    N=list_to_atom(NodeName++"@"++HostName),
    {ok,N}=ssh_vm:create(HostName,NodeName,Cookie,PaArgs,EnvArgs,
			 {Ip,Port,Uid,Passwd,TimeOut}),
    pong=net_adm:ping(N),
    non_existing=code:where_is_file(File),
    FilewPath=rpc:call(N,code,where_is_file,[File]),
    ok=vm:delete(N),
    pang=net_adm:ping(N),
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),  
    ok.
    

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

t1_test(HostName)->
    Ip=config:host_local_ip(HostName),
    Port=config:host_ssh_port(HostName),
    Uid=config:host_uid(HostName),
    Passwd=config:host_passwd(HostName),
    TimeOut=7000,
    NodeName="t",
    N=list_to_atom(NodeName++"@"++HostName),
    {ok,N}=ssh_vm:create(HostName,NodeName,{Ip,Port,Uid,Passwd,TimeOut}),
    pong=net_adm:ping(N),
    ok=vm:delete(N),
    pang=net_adm:ping(N),
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    ok=application:start(config),
   % gl=config:host_application_config("c202"),
  %  gl=config:host_all_filenames(),
  %  gl=config:host_all_info(),
  %  gl=config:host_all_hostnames(),
    ok.

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
-module(local_vm_test).   
 
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

    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    timer:sleep(1000),
    ok.



%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

t3_test(HostName)->
    File=filename:basename(?FILE),
    NodeDir="test",
    N=list_to_atom("t"++"@"++HostName),
    {ok,N}=local_vm:create_dir("t",NodeDir),
    pong=net_adm:ping(N),
    non_existing=code:where_is_file(File),
    ?FILE=rpc:call(N,code,where_is_file,[File]),
    ok=vm:delete(N),
    pang=net_adm:ping(N),
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),  
    ok.
    

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

t2_test(HostName)->
    File=filename:basename(?FILE),
    PaArgs="-pa test ",
    EnvArgs=" ",
    N=list_to_atom("t"++"@"++HostName),
    {ok,N}=local_vm:create("t",PaArgs,EnvArgs),
    pong=net_adm:ping(N),
    non_existing=code:where_is_file(File),
    ?FILE=rpc:call(N,code,where_is_file,[File]),
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

    % 1. Start/stop vm     
    N=list_to_atom("t"++"@"++HostName),
    {ok,N}=local_vm:create("t"),
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
  
    % Simulate host
  %  R=rpc:call(node(),test_nodes,start_nodes,[],2000),
%    [Vm1|_]=test_nodes:get_nodes(),

%    Ebin="ebin",
 %   true=rpc:call(Vm1,code,add_path,[Ebin],5000),
 
   % R.
    ok.

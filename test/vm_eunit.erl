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
-module(vm_eunit).   
 
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
    ok=local_vm:start(),

    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    timer:sleep(1000),
    ok.



%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
local_test()->
    {ok,HostName}=net:gethostname(),
    ok=l1_test(HostName),
    ok=l2_test(HostName),
    ok.



l2_test(HostName)->
    N=list_to_atom("t"++"@"++HostName),
    {ok,N}=vm:create_local("t"),
    pong=net_adm:ping(N),
    ok=vm:delete(N),
    pang=net_adm:ping(N),
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),  
    ok.
    
l1_test(HostName)->

    % 1. Start/stop vm     
    N=list_to_atom("t"++"@"++HostName),
    {ok,N}=vm:create_local("t"),
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
-define(Ip,"192.168.1.100").
-define(Port,22).
-define(User,"joq62").
-define(Password,"festum01").
-define(TimeOut,6000).

-define(HostName,"c100").
-define(NodeName,"TestVm").
-define(Node,'TestVm@c100').
-define(NodeDir,"test_vm_dir").
-define(Cookie,atom_to_list(erlang:get_cookie())).
-define(EnvArgs,"-common test_env test").
-define(PaArgsInit,"-pa /home/joq62/erlang/infra_2/common/ebin").


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
is_dir_ssh_test()->
    
    false=vm:is_dir_ssh("glurk",
			{?Ip,?Port,?User,?Password,?TimeOut}),
    true=vm:is_dir_ssh("erlang",
			{?Ip,?Port,?User,?Password,?TimeOut}),
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start_vm_local()->

    %% Create 
    os:cmd("rm -rf "++?NodeDir),
    file:make_dir(?NodeDir),
    PaArgs=" "++?PaArgsInit,
    {ok,Node}=vm:create(?HostName,?NodeDir,?NodeName,?Cookie,PaArgs,?EnvArgs),
    ?Node=Node,
    rpc:call(Node,application,start,[common]),
    pong= rpc:call(Node,common,ping,[]),
    {ok,test}=rpc:call(Node,application,get_env,[common,test_env]),
    timer:sleep(2000),
    {ok,Node,?NodeDir}.
 
stop_vm_local(NodeLocal,NodeDirLocal)->
    vm:delete(NodeLocal,NodeDirLocal),
    false=filelib:is_dir(NodeDirLocal), 
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

start_vm_ssh()->
   %% Create local 
    my_ssh:ssh_send(?Ip,?Port,?User,?Password,"rm -rf "++?NodeDir,?TimeOut),
    my_ssh:ssh_send(?Ip,?Port,?User,?Password,"mkdir "++?NodeDir,?TimeOut),
    
    PaArgs=" "++?PaArgsInit,
    {ok,Node}=vm:ssh_create(?HostName,?NodeName,?Cookie,PaArgs,?EnvArgs,
			    {?Ip,?Port,?User,?Password,?TimeOut}),

    ?Node=Node,
    rpc:call(Node,application,start,[common]),
    pong= rpc:call(Node,common,ping,[]),
    {ok,test}=rpc:call(Node,application,get_env,[common,test_env]),
    {ok,Node,?NodeDir}.


stop_vm_ssh(NodeSsh,NodeDirSsh)->
    vm:delete(NodeSsh),
    my_ssh:ssh_send(?Ip,?Port,?User,?Password,"rm -rf "++NodeDirSsh,?TimeOut),
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

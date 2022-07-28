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
-module(dbase_eunit).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
-define(TestAddGitPath,"https://github.com/joq62/test_add.git").
-define(TestAddGitDir,"test_add").
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
-define(EnvArgs," ").
-define(PaArgsInit,"-pa /home/joq62/erlang/infra_2/common/ebin").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    os:cmd("rm -rf Mnesia.dbase1@c100"),
    os:cmd("rm -rf Mnesia.dbase2@c100"),
    os:cmd("rm -rf Mnesia.dbase3@c100"),    

    {ok,N1}=vm:create("c100","dbase1",?Cookie,?PaArgsInit,?EnvArgs),
    {ok,N2}=vm:create("c100","dbase2",?Cookie,?PaArgsInit,?EnvArgs),
    {ok,N3}=vm:create("c100","dbase3",?Cookie,?PaArgsInit,?EnvArgs),
 
    %% Inital 
    ok=rpc:call(N1,dbase_lib,dynamic_db_init,[[N3,N2,N1]],5000),
    io:format("mnesia:system_info() ~p~n",[rpc:call(N1,mnesia,system_info,[])]),

  
    %% 
    io:format("TEST OK! ~p~n",[?MODULE]),
    timer:sleep(1000),
    ok.



t1()->
    {ok,N1}=vm:create("c100","dbase1",?Cookie,?PaArgsInit,?EnvArgs),
    {ok,N2}=vm:create("c100","dbase2",?Cookie,?PaArgsInit,?EnvArgs),
    {ok,N3}=vm:create("c100","dbase3",?Cookie,?PaArgsInit,?EnvArgs),
 
    %% Inital 
    ok=rpc:call(N1,dbase_lib,dynamic_install_start,[N1],5000),
    ok=rpc:call(N1,dbase_lib,dynamic_install,[[N2,N3],N1],5000),
    io:format("mnesia:system_info() ~p~n",[rpc:call(N1,mnesia,system_info,[])]),
    ok.

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

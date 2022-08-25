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
-module(copy_test).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(SourceDir,"/home/joq62/erlang/specifications/deployments").
-define(Ext,".depl_spec").
-define(DestDir,"dest_dir").
-define(TestFile,"LICENSE").
-define(DeploymentFile,"solis.depl_spec").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=setup(),
      
    ok=file_test(),
    ok=dir_test(),
  
    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    timer:sleep(1000),
    ok=cleanup(),
    init:stop(),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
dir_test()->
    os:cmd("rm -rf "++?DestDir),
    ok=file:make_dir(?DestDir),
    [Vm1,Vm2|_]=test_nodes:get_nodes(),
    false=filelib:is_file(filename:join(?DestDir,?DeploymentFile)),
    R=copy:copy_dir_ext(Vm1,?SourceDir,Vm2,?DestDir,?Ext),
    []=[Result||Result<-R,
		ok=/=Result],
    true=filelib:is_file(filename:join(?DestDir,?DeploymentFile)),
    os:cmd("rm -rf "++?DestDir),
    io:format("SUB_TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
file_test()->
    os:cmd("rm -rf "++?DestDir),
    ok=file:make_dir(?DestDir),
    [Vm1,Vm2|_]=test_nodes:get_nodes(),
    false=filelib:is_file(filename:join(?DestDir,?TestFile)),
    ok=copy:copy_file(Vm1,".",?TestFile,Vm2,?DestDir,?TestFile),
    true=filelib:is_file(filename:join(?DestDir,?TestFile)),
    os:cmd("rm -rf "++?DestDir),
    io:format("SUB_TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
cleanup()->
    os:cmd("rm -rf "++?DestDir),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    
    ok=test_nodes:start_nodes(),
  %  [Vm1,Vm2|_]=test_nodes:get_nodes(),
  
 
    ok.

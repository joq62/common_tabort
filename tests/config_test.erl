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
-module(config_test).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ConfigNodeName,"config").
-define(ConfigCookieStr,"config").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=setup(),
    
    "config"=common:config_nodename(),
    "config"=common:config_cookie(),
    
   

    io:format("TEST OK! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    timer:sleep(1000),
    ok=cleanup(),

    ok.



%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
cleanup()->
    application:stop(config),
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

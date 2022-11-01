%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is§
%%% -------------------------------------------------------------------
-module(basic_eunit).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/logger.hrl").
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    ok=config_server:appl_start([]),
    pong=config_server:ping(),
    ok=application_test(),
    ok=deployment_test(),
    ok=deployment_spec_test(),
    ok=host_test(),
    init:stop(),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
application_test()->
    
    ["nodelog.spec"|_]=config_server:application_all_filenames(),
    ["cluster1/application_info_specs/nodelog.spec"|_]=config_server:application_all_files(),
    
    [[{name,"nodelog"},{vsn,["0.1.0"]},{gitpath,"https://github.com/joq62/nodelog.git"},{cmd,{nodelog_server,appl_start,[[]]}}]|_]=config_server:application_all_info(),

    %% test one 
    ["0.1.0"]=config_server:application_vsn("nodelog.spec"),
    "https://github.com/joq62/nodelog.git"=config_server:application_gitpath("nodelog.spec"),
    {nodelog_server,appl_start,[[]]}=config_server:application_start_cmd("nodelog.spec"),

    %% negative test
    {error,[eexists,"glurk.spec"]}=config_server:application_vsn("glurk.spec"),
    {error,[eexists,"nodelog.glurk"]}=config_server:application_gitpath("nodelog.glurk"),
    {error,[eexists,34]}=config_server:application_start_cmd(34),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
deployment_test()->
    ["calculator.depl"|_]=config_server:deployment_all_filenames(),
    ["cluster1/deployment_info_specs/calculator.depl"|_]=config_server:deployment_all_files(),
    [[{name,"calculator"},
     {vsn,"0.1.0"},
     {appl_specs,[{"test_math","0.1.0"},
		  {"test_add","0.1.0"},
		  {"test_divi","0.1.0"},
		  {"test_sub","0.1.0"}]},
     {num_instances,3},
     {directive,[{all_or_nothing,false},{same_host,false},{specifict_host,[]}]}]|_]=config_server:deployment_all_info(),

    
    "calculator"=config_server:deployment_name("calculator.depl"),
    "0.1.0"=config_server:deployment_vsn("calculator.depl"),

    [{"common","0.1.0"},
     {"nodelog","0.1.0"},
     {"config","0.1.0"},
     {"sd","0.1.0"}]=config_server:deployment_appl_specs("controller_local.depl"),
    3=config_server:deployment_num_instances("controller_local.depl"),
    [{all_or_nothing,false},
     {same_host,true},
     {specifict_host,[]}]=config_server:deployment_directive("controller_local.depl"),

    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
deployment_spec_test()->
    ["cluster1.depl_spec"|_]=config_server:deployment_spec_all_filenames(),
    ["cluster1/deployments/cluster1.depl_spec"|_]=config_server:deployment_spec_all_files(),
    [[{name,"cluster1"},{controllers,3},{workers,5},
     {cookie,"cluster1_cookie"},{hosts,["c100","c202"]},
     {application_info_specs,[{dir,"cluster1/application_info_specs"},{gitpath,"https://github.com/joq62/application_info_specs.git"}]},
     {deployment_info_specs,[{dir,"cluster1/deployment_info_specs"},{gitpath,"https://github.com/joq62/deployment_info_specs.git"}]},{host_info_specs,[{dir,"host_info_specs"},{gitpath,"https://github.com/joq62/host_info_specs.git"}]},
     {deployments,["calculator.depl"]}]|_]=config_server:deployment_spec_all_info(),

    "cluster1"=config_server:deployment_spec_name("cluster1.depl_spec"),
    3=config_server:deployment_spec_controllers("cluster1.depl_spec"),
    5=config_server:deployment_spec_workers("cluster1.depl_spec"),
    "cluster1_cookie"=config_server:deployment_spec_cookie("cluster1.depl_spec"),
    ["c100","c202"]=config_server:deployment_spec_hosts("cluster1.depl_spec"),

    [{dir,"cluster1/application_info_specs"},
     {gitpath,"https://github.com/joq62/application_info_specs.git"}]=config_server:deployment_spec_application_info_dir_git("cluster1.depl_spec"),
    [{dir,"cluster1/deployment_info_specs"},
     {gitpath,"https://github.com/joq62/deployment_info_specs.git"}]=config_server:deployment_spec_deployment_info_dir_git("cluster1.depl_spec"),
    [{dir,"host_info_specs"},
     {gitpath,"https://github.com/joq62/host_info_specs.git"}]=config_server:deployment_spec_host_info_dir_git("cluster1.depl_spec"),
   
 ["calculator.depl"]=config_server:deployment_spec_deployments("cluster1.depl_spec"),
   

    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
host_test()->
    ["c202.host","c200.host","c201.host","c100.host"]=config_server:host_all_filenames(),
    ["cluster1/host_info_specs/c202.host"|_]=config_server:host_all_files(),
    [[{hostname,"c202"},{local_ip,"192.168.1.202"},{public_ip,_},{ssh_port,__},
      {uid,_},{passwd,_},{application_config,_}]|_]=config_server:host_all_info(),   
    ["c202"|_]=config_server:host_all_hostnames(),

    io:format("local_ip, ~p~n",[config_server:host_local_ip("c202")]),
    io:format("public_ip, ~p~n",[config_server:host_public_ip("c202")]),
    io:format("ssh_port, ~p~n",[config_server:host_ssh_port("c202")]),
    io:format("uid, ~p~n",[config_server:host_uid("c202")]), 
    io:format("passwd, ~p~n",[config_server:host_passwd("c202")]),
    io:format("application_config, ~p~n",[config_server:host_application_config("c202")]),

    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------

setup()->
  
    % Simulate host
    R=rpc:call(node(),test_nodes,start_nodes,[],2000),
%    [Vm1|_]=test_nodes:get_nodes(),

%    Ebin="ebin",
 %   true=rpc:call(Vm1,code,add_path,[Ebin],5000),
 
    R.

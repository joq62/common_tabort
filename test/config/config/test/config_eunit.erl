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
-module(config_eunit).   
 
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
    ok=config:appl_start([]),
    pong=config:ping(),
    ok=application_test(),
    ok=deployment_test(),
    ok=deployment_spec_test(),

    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
application_test()->
    
    ["common.spec"|_]=lists:sort(config:application_all_filenames()),
    ["./application_info_specs/common.spec"|_]=lists:sort(config:application_all_files()),
    
    [[{name,"common"},{vsn,["0.1.0"]},{gitpath,"https://github.com/joq62/common.git"},{cmd,{common,appl_start,[[]]}}]|_]=lists:sort(config:application_all_info()),

    %% test one 
    ["0.1.0"]=config:application_vsn("common.spec"),
    "https://github.com/joq62/common.git"=config:application_gitpath("common.spec"),
    {common,appl_start,[[]]}=config:application_start_cmd("common.spec"),

    %% negative test
    {error,[eexists,"glurk.spec"]}=config:application_vsn("glurk.spec"),
    {error,[eexists,"common.glurk"]}=config:application_gitpath("common.glurk"),
    {error,[eexists,34]}=config:application_start_cmd(34),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
deployment_test()->
    ["calculator.depl"|_]=lists:sort(config:deployment_all_filenames()),
    ["./deployment_info_specs/calculator.depl"|_]=lists:sort(config:deployment_all_files()),
    [[{name,"calculator"},
     {vsn,"0.1.0"},
     {appl_specs,[{"test_math","0.1.0"},
		  {"test_add","0.1.0"},
		  {"test_divi","0.1.0"},
		  {"test_sub","0.1.0"}]},
     {num_instances,3},
     {directive,[{all_or_nothing,false},{same_host,false},{specifict_host,[]}]}]|_]=lists:sort(config:deployment_all_info()),

    
    "calculator"=config:deployment_name("calculator.depl"),
    "0.1.0"=config:deployment_vsn("calculator.depl"),

    [{"common","0.1.0"},
     {"nodelog","0.1.0"},
     {"config","0.1.0"},
     {"sd","0.1.0"}]=config:deployment_appl_specs("controller_local.depl"),
    3=config:deployment_num_instances("controller_local.depl"),
    [{all_or_nothing,false},
     {same_host,true},
     {specifict_host,[]}]=config:deployment_directive("controller_local.depl"),

    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
deployment_spec_test()->
    ["cluster1.depl_spec"|_]=lists:sort(config:deployment_spec_all_filenames()),
    ["./deployments/cluster1.depl_spec"|_]=lists:sort(config:deployment_spec_all_files()),
    [[{name,"cluster1"},
      {controllers,3},
      {workers,5},
      {cookie,"cluster1_cookie"},
      {hosts,["c100","c202"]},
      {deployments,["calculator.depl"]}]|_]=lists:sort(config:deployment_spec_all_info()),

    "cluster1"=config:deployment_spec_name("cluster1.depl_spec"),
    3=config:deployment_spec_controllers("cluster1.depl_spec"),
    5=config:deployment_spec_workers("cluster1.depl_spec"),
    "cluster1_cookie"=config:deployment_spec_cookie("cluster1.depl_spec"),
    ["c100","c202"]=config:deployment_spec_hosts("cluster1.depl_spec"),

    ["calculator.depl"]=config:deployment_spec_deployments("cluster1.depl_spec"),
   

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

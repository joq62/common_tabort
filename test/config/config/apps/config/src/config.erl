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
-module(config).     
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
-define(SERVER,?MODULE).
%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state, {}).



%% --------------------------------------------------------------------
%% Definitions 
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

-export([ %application_info_specs

	  application_all_files/0,
	  application_all_filenames/0,
	  application_all_info/0,
	  application_vsn/1,
	  application_gitpath/1,
	  application_start_cmd/1,
	  application_member/1,
	  application_member/2,
	 %% host_info_specs
	  host_all_files/0,
	  host_all_filenames/0,
	  host_all_info/0,
	  host_all_hostnames/0,

	  host_local_ip/1,
	  host_public_ip/1,
	  host_ssh_port/1,
	  host_uid/1,
	  host_passwd/1,
	  host_application_config/1,
	  
	  %% deployment_specs
	  deployment_spec_all_files/0,
	  deployment_spec_all_filenames/0,
	  deployment_spec_all_info/0,
	  deployment_spec_name/1,
	  deployment_spec_controllers/1,
	  deployment_spec_workers/1,
	  deployment_spec_cookie/1,
	  deployment_spec_hosts/1,
	  deployment_spec_application_info_dir_git/1,
	  deployment_spec_deployment_info_dir_git/1,
	  deployment_spec_host_info_dir_git/1,
	  deployment_spec_deployments/1,

	
	 %% deployment_info_specs
	  deployment_all_files/0,
	  deployment_all_filenames/0,
	  deployment_all_info/0,

	  deployment_name/1,
	  deployment_vsn/1,
	  deployment_appl_specs/1,
	  deployment_num_instances/1,
	  deployment_directive/1

	]).

-export([
	 appl_start/1,
	 ping/0,
	 start/0,
	 stop/0
	]).

%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================
appl_start([])->
    application:start(?MODULE).
%%-----------------------------------------------------------------------

%%----------------------------------------------------------------------
%% Gen server functions
start()-> gen_server:start_link({local, ?SERVER}, ?SERVER, [], []).
stop()-> gen_server:call(?SERVER, {stop},infinity).


%% application_info_specs
application_all_filenames()->
    gen_server:call(?SERVER, {application_all_filenames},infinity).
application_all_files()->
    gen_server:call(?SERVER, {application_all_files},infinity).
application_all_info()->
    gen_server:call(?SERVER, {application_all_info},infinity).
application_vsn(AppId)->
    gen_server:call(?SERVER, {application_vsn,AppId},infinity).
application_gitpath(AppId)->
    gen_server:call(?SERVER, {application_gitpath,AppId},infinity).
application_start_cmd(AppId)->
    gen_server:call(?SERVER, {application_start_cmd,AppId},infinity).
application_member(AppId)->
    gen_server:call(?SERVER, {application_member,AppId},infinity).
application_member(AppId,Vsn)->
    gen_server:call(?SERVER, {application_member,AppId,Vsn},infinity).

%% host_info_specs
host_all_filenames()->
    gen_server:call(?SERVER, {host_all_filenames},infinity).
host_all_files()->
    gen_server:call(?SERVER, {host_all_files},infinity).
host_all_info()->
    gen_server:call(?SERVER, {host_all_info},infinity).
host_all_hostnames()->
    gen_server:call(?SERVER, {host_all_hostnames},infinity).

host_local_ip(HostName)->
    gen_server:call(?SERVER, {host_local_ip,HostName},infinity).
host_public_ip(HostName)->
    gen_server:call(?SERVER, {host_public_ip,HostName},infinity).
host_ssh_port(HostName)->
    gen_server:call(?SERVER, {host_ssh_port,HostName},infinity).
host_uid(HostName)->
    gen_server:call(?SERVER, {host_uid,HostName},infinity).
host_passwd(HostName)->
    gen_server:call(?SERVER, {host_passwd,HostName},infinity).
host_application_config(HostName)->
     gen_server:call(?SERVER, {host_application_config,HostName},infinity).

%% deployment_specs
deployment_spec_all_filenames()->
    gen_server:call(?SERVER, {deployment_spec_all_filenames},infinity).
deployment_spec_all_files()->
    gen_server:call(?SERVER, {deployment_spec_all_files},infinity).
deployment_spec_all_info()->
    gen_server:call(?SERVER, {deployment_spec_all_info},infinity).
deployment_spec_name(FileName)->
    gen_server:call(?SERVER, {deployment_spec_name,FileName},infinity).
deployment_spec_controllers(FileName)->
    gen_server:call(?SERVER, {deployment_spec_controllers,FileName},infinity).
deployment_spec_workers(FileName)->
    gen_server:call(?SERVER, {deployment_spec_workers,FileName},infinity).
deployment_spec_cookie(FileName)->
    gen_server:call(?SERVER, {deployment_spec_cookie,FileName},infinity).
deployment_spec_hosts(FileName)->
    gen_server:call(?SERVER, {deployment_spec_hosts,FileName},infinity).

deployment_spec_application_info_dir_git(FileName)->
    gen_server:call(?SERVER, {deployment_spec_application_info_dir_git,FileName},infinity).
deployment_spec_deployment_info_dir_git(FileName)->
    gen_server:call(?SERVER, {deployment_spec_deployment_info_dir_git,FileName},infinity).
deployment_spec_host_info_dir_git(FileName)->
    gen_server:call(?SERVER, {deployment_spec_host_info_dir_git,FileName},infinity).

deployment_spec_deployments(FileName)->
    gen_server:call(?SERVER, {deployment_spec_deployments,FileName},infinity).


%% deployment_info_specs
deployment_all_filenames()->
    gen_server:call(?SERVER, {deployment_all_filenames},infinity).
deployment_all_files()->
    gen_server:call(?SERVER, {deployment_all_files},infinity).
deployment_all_info()->
    gen_server:call(?SERVER, {deployment_all_info},infinity).


deployment_name(FileName)->
    gen_server:call(?SERVER, {deployment_name,FileName},infinity).
deployment_vsn(FileName)->
    gen_server:call(?SERVER, {deployment_vsn,FileName},infinity).
deployment_appl_specs(FileName)->
    gen_server:call(?SERVER, {deployment_appl_specs,FileName},infinity).
deployment_num_instances(FileName)->
    gen_server:call(?SERVER, {deployment_num_instances,FileName},infinity).
deployment_directive(FileName)->
    gen_server:call(?SERVER, {deployment_directive,FileName},infinity).


%%---------------------------------------------------------------
-spec ping()-> {atom(),node(),module()}|{atom(),term()}.
%% 
%% @doc:check if service is running
%% @param: non
%% @returns:{pong,node,module}|{badrpc,Reason}
%%
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: 
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------
init([]) ->
    
    {ok, #state{}}.
    
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------
%% deployment_specs
handle_call({deployment_spec_all_filenames},_From,State) ->
    Reply=deployment_spec_lib:all_filenames(),
    {reply, Reply, State};

handle_call({deployment_spec_all_files},_From,State) ->
    Reply=deployment_spec_lib:all_files(),
    {reply, Reply, State};

handle_call({deployment_spec_all_info},_From,State) ->
    Reply=deployment_spec_lib:all_info(),
    {reply, Reply, State};


handle_call({deployment_spec_name,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(name,FileName),
    {reply, Reply, State};
handle_call({deployment_spec_controllers,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(controllers,FileName),
    {reply, Reply, State};
handle_call({deployment_spec_workers,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(workers,FileName),
    {reply, Reply, State};
handle_call({deployment_spec_cookie,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(cookie,FileName),
    {reply, Reply, State};
handle_call({deployment_spec_hosts,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(hosts,FileName),
    {reply, Reply, State};

handle_call({deployment_spec_application_info_dir_git,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(application_info_specs,FileName),
    {reply, Reply, State};
handle_call({deployment_spec_deployment_info_dir_git,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(deployment_info_specs,FileName),
    {reply, Reply, State};
handle_call({deployment_spec_host_info_dir_git,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(host_info_specs,FileName),
    {reply, Reply, State};

handle_call({deployment_spec_deployments,FileName},_From,State) ->
    Reply=deployment_spec_lib:get(deployments,FileName),
    {reply, Reply, State};


%%----------------- deployment_info_specs
handle_call({deployment_all_filenames},_From,State) ->
    Reply=deployment_lib:all_filenames(),
    {reply, Reply, State};

handle_call({deployment_all_files},_From,State) ->
    Reply=deployment_lib:all_files(),
    {reply, Reply, State};

handle_call({deployment_all_info},_From,State) ->
    Reply=deployment_lib:all_info(),
    {reply, Reply, State};

handle_call({deployment_name,FileName},_From,State) ->
    Reply=deployment_lib:get(name,FileName),
    {reply, Reply, State};

handle_call({deployment_vsn,FileName},_From,State) ->
    Reply=deployment_lib:get(vsn,FileName),
    {reply, Reply, State};

handle_call({deployment_appl_specs,FileName},_From,State) ->
    Reply=deployment_lib:get(appl_specs,FileName),
    {reply, Reply, State};

handle_call({deployment_num_instances,FileName},_From,State) ->
    Reply=deployment_lib:get(num_instances,FileName),
    {reply, Reply, State};

handle_call({deployment_directive,FileName},_From,State) ->
    Reply=deployment_lib:get(directive,FileName),
    {reply, Reply, State};

%%----------------- application_info_specs
handle_call({application_all_filenames},_From,State) ->
    Reply=appl_lib:all_filenames(),
    {reply, Reply, State};

handle_call({application_all_files},_From,State) ->
    Reply=appl_lib:all_files(),
    {reply, Reply, State};

handle_call({application_all_info},_From,State) ->
    Reply=appl_lib:all_info(),
    {reply, Reply, State};


handle_call({application_vsn,AppId},_From,State) ->
    Reply=appl_lib:get(vsn,AppId),
    {reply, Reply, State};

handle_call({application_gitpath,AppId},_From,State) ->
    Reply=appl_lib:get(gitpath,AppId),
    {reply, Reply, State};

handle_call({application_start_cmd,AppId},_From,State) ->
    Reply=appl_lib:get(cmd,AppId),
    {reply, Reply, State};

handle_call({application_member,AppId},_From,State) ->
    Reply=appl_lib:member(AppId),
    {reply, Reply, State};

handle_call({application_member,AppId,Vsn},_From,State) ->
    Reply=appl_lib:member(AppId,Vsn),
    {reply, Reply, State};

%%--------------- host_info_specs
handle_call({host_all_filenames},_From,State) ->
    Reply=host_lib:all_filenames(),
    {reply, Reply, State};

handle_call({host_all_files},_From,State) ->
    Reply=host_lib:all_files(),
    {reply, Reply, State};

handle_call({host_all_info},_From,State) ->
    Reply=host_lib:all_info(),
    {reply, Reply, State};

handle_call({host_all_hostnames},_From,State) ->
    Reply=host_lib:all_hostnames(),
    {reply, Reply, State};

handle_call({host_local_ip,HostName},_From,State) ->
    Reply=host_lib:get(local_ip,HostName),
    {reply, Reply, State};

handle_call({host_public_ip,HostName},_From,State) ->
    Reply=host_lib:get(public_ip,HostName),
    {reply, Reply, State};

handle_call({host_ssh_port,HostName},_From,State) ->
    Reply=host_lib:get(ssh_port,HostName),
    {reply, Reply, State};

handle_call({host_uid,HostName},_From,State) ->
    Reply=host_lib:get(uid,HostName),
    {reply, Reply, State};

handle_call({host_passwd,HostName},_From,State) ->
    Reply=host_lib:get(passwd,HostName),
    {reply, Reply, State};

handle_call({host_application_config,HostName},_From,State) ->
    Reply=host_lib:get(application_config,HostName),
    {reply, Reply, State};

handle_call({ping},_From,State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call({stop}, _From, State) ->    
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% -------------------------------------------------------------------
    
handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------


handle_info({stop}, State) ->
    io:format("stop ~p~n",[{?MODULE,?LINE}]),
    exit(self(),normal),
    {noreply, State};

handle_info(Info, State) ->
    io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

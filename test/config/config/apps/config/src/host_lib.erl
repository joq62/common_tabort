-module(host_lib).

-export([
	 get/2,
	 all_filenames/0,
	 all_files/0,
	 all_info/0,
	 all_hostnames/0,

	 get_info/1
	]).


-define(DirSpecs,"host_info_specs").



%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
all_filenames()->
    case code:where_is_file(?DirSpecs) of
	non_existing->
	    {error,[non_existing,?DirSpecs]};
	InfoSpecDir->
	    {ok,Files}=file:list_dir(InfoSpecDir),
	    [Filename||Filename<-Files,
		       ".host"=:=filename:extension(Filename)]
    end.
 
all_files()->
    case code:where_is_file(?DirSpecs) of
	non_existing->
	    {error,[non_existing,?DirSpecs]};
       InfoSpecDir->
	   [filename:join([InfoSpecDir,Filename])||Filename<-all_filenames()]
   end.
all_info()->
    L1=[file:consult(DeplFile)||DeplFile<-all_files()],
%    io:format(" L1 ~p~n",[L1]),
    [Info||{ok,Info}<-L1].

all_hostnames()->
    [proplists:get_value(hostname,Info)||Info<-all_info()].

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
get(Key,HostName)->
    InfoList=[Info||Info<-all_info(),
		    HostName=:=proplists:get_value(hostname,Info)],
    Reply=case InfoList of
	      []->
		  {error,[eexists,HostName]};
	      [Info]->
		  {Key,Value}=lists:keyfind(Key,1,Info),
		  Value
	  end,
    Reply.		      

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
get_info(DeplFileName)->
    Reply=case [file:consult(DeplFile)||DeplFile<-all_files(),
					DeplFileName=:=filename:basename(DeplFile)] of
	      []->
		  {error,[eexists,DeplFileName]};
	      [{ok,Info}]->
		  {ok,Info}
	  end,
    Reply.
	   


    
    

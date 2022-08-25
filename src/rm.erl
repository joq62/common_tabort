-module(rm).



-export([r/2,
	 dir/2,
	 dir_r/2
	]).


%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
dir_r(Node,Dir)->
    
    ok.


%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
dir(Node,Dir)->
    r(Node,Dir).
%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
r(Node,Dir)->
    Result=case net_adm:ping(Node) of
	       pang->
		   {error,[node_not_available,Node,?MODULE,?FUNCTION_NAME,?LINE]};
	       pong->		   
		   case rpc:call(Node,file,list_dir_all,[Dir],5000) of
		       {badrpc,Reason}->
			   {error,[badrpc,Reason,?MODULE,?FUNCTION_NAME,?LINE]};
		       {error,Reason} ->
			   {error,[Reason,?MODULE,?FUNCTION_NAME,?LINE]};
		       {ok,FileNames}->
			   FullFileNames=[filename:join(Dir,FileName)||FileName<-FileNames],
			   DelFiles=[rpc:call(Node,file,delete,[FN],5000)||FN<-FullFileNames],
			   case [DelFileR||DelFileR<-DelFiles,
					   ok=/=DelFileR] of
			       [X|_]->
				   {error,[failed_to_delete,DelFiles,X]};
			       [] ->
				   rpc:call(Node,file,del_dir,[Dir],5000)
			   end
		   end
	   end,
    Result.

%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

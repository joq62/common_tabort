-module(copy).



-export([copy_file/6,
	 copy_dir_ext/5
	]).


%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
copy_dir_ext(SourceNode,SourceDir,DestNode,DestDir,Ext)->
    Result=case {net_adm:ping(SourceNode),net_adm:ping(DestNode)} of
	       {pang,pong}->
		   {error,[node_not_available,SourceNode,?MODULE,?FUNCTION_NAME,?LINE]};
	       {pong,pang} ->
		   {error,[node_not_available,DestNode,?MODULE,?FUNCTION_NAME,?LINE]};
	       {pang,pang}->
		   {error,[no_node_available,SourceNode,DestNode,?MODULE,?FUNCTION_NAME,?LINE]};
	       {pong,pong}->		   
		   case rpc:call(SourceNode,file,list_dir,[SourceDir],5000) of
		       {badrpc,Reason}->
			   {error,[badrpc,Reason,?MODULE,?FUNCTION_NAME,?LINE]};
		       {error,Reason} ->
			   {error,[Reason,?MODULE,?FUNCTION_NAME,?LINE]};
		       {ok,FileNames}->
			   [copy_file(SourceNode,SourceDir,FileName,DestNode,DestDir,FileName)||FileName<-FileNames,
												Ext=:=filename:extension(FileName)]
		   end
	   end,
    Result.

%% --------------------------------------------------------------------
%% Function:mapreduce/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
copy_file(SourceNode,SourceDir,SourceFileName,DestNode,DestDir,DestFileName)->
    Result=case {net_adm:ping(SourceNode),net_adm:ping(DestNode)} of
	       {pang,pong}->
		   {error,[node_not_available,SourceNode,?MODULE,?FUNCTION_NAME,?LINE]};
	       {pong,pang} ->
		   {error,[node_not_available,DestNode,?MODULE,?FUNCTION_NAME,?LINE]};
	       {pang,pang}->
		   {error,[no_node_available,SourceNode,DestNode,?MODULE,?FUNCTION_NAME,?LINE]};
	       {pong,pong}->
		   SourceFullName=filename:join(SourceDir,SourceFileName),
		   case rpc:call(SourceNode,file,read_file,[SourceFullName],5000) of
		       {badrpc,Reason}->
			   {error,[badrpc,Reason,?MODULE,?FUNCTION_NAME,?LINE]};
		       {error,Reason} ->
			   {error,[Reason,?MODULE,?FUNCTION_NAME,?LINE]};
		       {ok,Bin}->
			   DestFullName=filename:join(DestDir,DestFileName),
			   case rpc:call(DestNode,file,write_file,[DestFullName,Bin],5000) of
			       {badrpc,Reason}->
				   {error,[badrpc,Reason,?MODULE,?FUNCTION_NAME,?LINE]};
			       {error,Reason} ->
				   {error,[Reason,?MODULE,?FUNCTION_NAME,?LINE]};
			       ok->
				   ok
			   end
		   end
	   end,
    Result.

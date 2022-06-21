-module(node_to_id).


-export([start/1
	]).


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start(Node)->
    NodeStr=atom_to_list(Node),
    [VmId,HostId]=string:lexemes(NodeStr,"@"),
    {VmId,HostId}.

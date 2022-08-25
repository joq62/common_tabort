%%%-------------------------------------------------------------------
%% @doc config public API
%% @end
%%%-------------------------------------------------------------------

-module(config_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    config_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

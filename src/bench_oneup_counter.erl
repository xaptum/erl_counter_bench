%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 13. Mar 2018 12:37 PM
%%%-------------------------------------------------------------------
-module(bench_oneup_counter).
-author("iguberman").
-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  oneup:new_counter().

bench_iteration(Counter)->
  oneup:inc(Counter).
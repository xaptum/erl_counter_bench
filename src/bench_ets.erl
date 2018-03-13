%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 13. Mar 2018 11:53 AM
%%%-------------------------------------------------------------------
-module(bench_ets).
-author("iguberman").
-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([{tab_opts, TabOpts}])->
  erl_counter_bench:delete_ets_if_exists(tab),
  ets:new(tab, TabOpts),
  ets:insert(tab, {counter, 0}).

bench_iteration(_BenchSetup)->
  ets:update_counter(tab, counter, 1).

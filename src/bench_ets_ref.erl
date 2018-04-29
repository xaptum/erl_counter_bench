%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 29. Apr 2018 11:53 AM
%%%-------------------------------------------------------------------
-module(bench_ets_ref).
-author("iguberman").
-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([{tab_opts, TabOpts}])->
  erl_counter_bench:delete_ets_if_exists(tab),
  ets:new(tab, TabOpts),
  ets:insert(tab, {counter, make_ref()}).

bench_iteration(_BenchSetup)->
  ets:lookup(tab, counter).

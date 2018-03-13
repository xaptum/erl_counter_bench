%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 13. Mar 2018 1:03 PM
%%%-------------------------------------------------------------------
-module(bench_core_level_oneup_counter).
-author("iguberman").
-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  CountersList = [{SchedulerId, oneup:new_counter()} || SchedulerId <- lists:seq(1, erlang:system_info(schedulers))],
  maps:from_list(CountersList).

bench_iteration(CoreLevelCounterMap)->
  oneup:inc(maps:get(erlang:system_info(scheduler_id), CoreLevelCounterMap)).




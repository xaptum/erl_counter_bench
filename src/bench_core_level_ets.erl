%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 13. Mar 2018 12:23 PM
%%%-------------------------------------------------------------------
-module(bench_core_level_ets).
-author("iguberman").

-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([{tab_opts, TabOpts}])->
  NumSchedulers = erlang:system_info(schedulers),
  [ begin
      TabName = tab_name(Scheduler),
      erl_counter_bench:delete_ets_if_exists(TabName),
      ets:new(TabName, TabOpts),
      ets:insert(TabName, {counter, 0})
    end
    || Scheduler <- lists:seq(1, NumSchedulers) ].

bench_iteration(_BenchSetup)->
  ets:update_counter(tab_name(), counter, 1).

tab_name()->
  SchedulerId = erlang:system_info(scheduler_id),
  tab_name(SchedulerId).

tab_name(SchedulerId)->
  list_to_atom(integer_to_list(SchedulerId)).

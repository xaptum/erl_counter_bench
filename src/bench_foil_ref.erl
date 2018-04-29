%%%-------------------------------------------------------------------
%%% @author zhaoxingu
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 27. Mar 2018 1:36 PM
%%%-------------------------------------------------------------------
-module(bench_foil_ref).
-author("zhaoxingu").
-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  foil_app:start(),
  foil:new(table),
  Counter = oneup:new_counter(),
  foil:insert(table, counter, Counter),
  foil:load(table).

bench_iteration(_)->
  {ok, _Counter} = table_foil:lookup(counter).

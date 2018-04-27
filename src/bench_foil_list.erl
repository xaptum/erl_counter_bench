%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 26. Apr 2018 10:39 AM
%%%-------------------------------------------------------------------
-module(bench_foil_list).
-author("iguberman").

-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  foil_app:start(),
  foil:new(table),
  foil:insert(table, someones, [1, "one", one]),
  foil:load(table).

bench_iteration(_)->
  {ok, [1, "one", one]} = table_foil:lookup(someones).



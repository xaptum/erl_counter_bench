%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 26. Apr 2018 10:49 AM
%%%-------------------------------------------------------------------
-module(bench_foil_simple).
-author("iguberman").

-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  foil_app:start(),
  foil:new(table),
  foil:insert(table, moo, "MOOOO"),
  foil:load(table).

bench_iteration(_)->
  {ok, "MOOOO"} = table_foil:lookup(moo).


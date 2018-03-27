%%%-------------------------------------------------------------------
%%% @author zhaoxingu
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 27. Mar 2018 1:36 PM
%%%-------------------------------------------------------------------
-module(bench_foil).
-author("zhaoxingu").
-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  foil_app:start(),
  foil:new(table),
  Udp_count = oneup:new_counter(),
  Tcp_count = oneup:new_counter(),
  foil:insert(table, tcp, Tcp_count),
  foil:insert(table, udp, Udp_count),
  foil:load(table).

bench_iteration(_)->
  {ok, Udp_c} = foil:lookup(table, udp),
  oneup:inc(Udp_c).

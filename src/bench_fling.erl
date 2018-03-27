%%%-------------------------------------------------------------------
%%% @author zhaoxingu
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Mar 2018 3:07 PM
%%%-------------------------------------------------------------------
-module(bench_fling).
-author("zhaoxingu").


-behavior(erl_counter_bench).

-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  Tid = ets:new(example, []),
  ModName = fling:gen_module_name(),
  GetKey = fun({K, _V}) -> K end,
  GetValue = fun({_K, V}) -> V end,
  Pid = fling:manage(Tid, GetKey, GetValue, ModName),
  Udp_count = oneup:new_counter(),
  Tcp_count = oneup:new_counter(),
  fling:put(Pid, [{udp,Udp_count},{tcp,Tcp_count}]),
  ModeA = fling:mode(Tid, ModName).

bench_iteration(ModeA)->
  Tcp = fling:get(ModeA, tcp),
  onup:inc(Tcp).
%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2018, Xaptum, Inc.
%%% @doc
%%%
%%% @end
%%% Created : 26. Apr 2018 10:27 AM
%%%-------------------------------------------------------------------
-module(bench_foil_simple_tuple).
-author("iguberman").

-behavior(erl_counter_bench).

%% API
-export([bench_setup/1, bench_iteration/1]).

bench_setup([])->
  foil_app:start(),
  foil:new(table),
  LargeBin = list_to_binary(lists:seq(1,255)),
  HugeBin = <<LargeBin/binary, LargeBin/binary, LargeBin/binary>>,
  foil:insert(table, counter_tuple,
    {monster, "One",
      {1, 1.5, [{counter1, "Counter1"}, {counter2, "Counter2"}],
        {"Hello", "Nested", "List",
          [1, 2, 3,
            [4, 5, 6, seven,
              {"eight", "nine",
                [10, 10.0, ten, "ten", <<1, 2, 3, 4, 5, 6, 7, 8, 9, 10>>,
                  [moo, [{large, LargeBin}, {huge, HugeBin}]]
                ]
              }
            ]
          ]
        }
      }
    }),
  foil:load(table).

bench_iteration(_)->
  {ok, {monster, "One", _InnerTuple}} = table_foil:lookup(counter_tuple).

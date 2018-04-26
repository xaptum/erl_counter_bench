-module('erl_counter_bench').

%% API exports
-export([main/1, delete_ets_if_exists/1, do_iterate/2, bench/4, iterate/3]).

-define(DEFAULT_ETS_OPTS, [named_table, set, public, {write_concurrency, true}, {read_concurrency, true}]).

-define(ITERATIONS, [100]).
-define(NUM_PROCS, [10, 100, 1000, 10000, 100000]).

-define(MICROS_IN_SEC, 1000000).

-define(TEST_CONFIG, [
    {bench_foil_simple, []},
    {bench_foil_simple_tuple, []},
    {bench_foil_list, []}
%%    {bench_ets, [{tab_opts, ?DEFAULT_ETS_OPTS}]},
%%    {bench_core_level_ets, [{tab_opts, ?DEFAULT_ETS_OPTS}]},
%%    {bench_oneup_counter, []},
%%    {bench_core_level_oneup_counter, []}
]).

-callback bench_setup(PropList :: list()) -> Response :: atom().

%%====================================================================
%% API functions
%%====================================================================

main(_Args) ->
    io:format("ONEUP_PRIV_PATH: ~p~n", [os:getenv("ONEUP_PRIV_PATH")]),
    [begin
       {TotalRunTime, _Result} = timer:tc(erl_counter_bench, bench, [BenchModule, PropList, NumProcs, NumIterations]),
       io:format("[~10b][~10b][~p]: ~50fs~n", [NumProcs, NumIterations, BenchModule, TotalRunTime/?MICROS_IN_SEC])
     end
    || {BenchModule, PropList} <- ?TEST_CONFIG, NumProcs <- ?NUM_PROCS, NumIterations <- ?ITERATIONS],
    erlang:halt(0).


%%====================================================================
%% Common utils
%%====================================================================

delete_ets_if_exists(EtsTable)->
    case ets:info(EtsTable) of
        undefined -> ok;
        InfoList when is_list(InfoList) -> ets:delete(EtsTable)
    end.


%%====================================================================
%% Internal functions
%%====================================================================

bench(BenchModule, PropList, NumProcs, NumIterations)->
    BenchSetup = BenchModule:bench_setup(PropList),
    Self = self(),
    Seq = lists:seq(1, NumProcs),
    [spawn_link(fun() -> iterate({BenchModule, BenchSetup}, Self, NumIterations) end) || _ <- Seq],
    PerProcessTotals =
        [begin
             receive
               {results, RunTime}  -> RunTime
            end
         end || _ <- Seq].
%%    TotalPerProcessTime = lists:foldl(fun(ProcessRunTime, AllProcessesTotal) -> ProcessRunTime + AllProcessesTotal end, 0, PerProcessTotals),
%%    io:format("[~10b][~10b][~p]: ~50fs~n", [NumProcs, NumIterations, BenchModule, TotalPerProcessTime/?MICROS_IN_SEC]).

iterate({BenchModule, BenchSetup}, ParentPid, Iterations)->
    {TotalRunTime, _Result} = timer:tc(?MODULE, do_iterate, [{BenchModule, BenchSetup}, Iterations]),
    ParentPid ! {results, TotalRunTime}.

do_iterate(_, 0)->
    ok;
do_iterate({BenchModule, BenchSetup},  N) when N > 0 ->
    BenchModule:bench_iteration(BenchSetup),
    do_iterate({BenchModule, BenchSetup}, N-1).


%%
%%process_results({TotalRunTime, RunTimes}, BenchModule, NumProcs, NumIterations)
%%    when is_integer(TotalRunTime);is_list(RunTimes) ->
%%    BinResults = integer_list_to_binary(RunTimes),
%%    file:write_file(result_file_name(BenchModule, NumProcs, NumIterations), BinResults),
%%    TotalRunTime.
%%
%%result_file_name(BenchModule, NumProcs, NumIterations)->
%%    lists:flatten(io_lib:format("~p_~b_~b.result", [BenchModule, NumProcs, NumIterations])).
%%integer_list_to_binary(Results)->
%%  %%  Convert list to string i.e. [1,2,3] -> "[1,2,3]"
%%  FlatResults = lists:flatten(io_lib:format("~p", [Results])),
%%  %%  Strip square brackets and convert ot binary i.e. "[1,2,3]"->"1,2,3"
%%  StrResults = string:strip(string:strip(FlatResults, left, $[), right, $]),
%%  list_to_binary(StrResults).


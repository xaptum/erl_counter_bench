-module('erl_counter_bench').

%% API exports
-export([main/1, delete_ets_if_exists/1]).

-define(DEFAULT_ETS_OPTS, [named_table, set, public, {write_concurrency, true}, {read_concurrency, true}]).

-define(ITERATIONS, [100]).

-define(NUM_PROCS, [10]). %%, 100, 1000, 10000]). %%, 100000, 1000000]).
-define(MICROS_IN_SEC, 1000000).

-define(TEST_CONFIG, [
    {bench_ets, [{tab_opts, ?DEFAULT_ETS_OPTS}]},
    {bench_core_level_ets, [{tab_opts, ?DEFAULT_ETS_OPTS}]},
    {bench_oneup_counter, []},
    {bench_core_level_oneup_counter, []}]).

-callback bench_setup(PropList :: list()) -> Response :: atom().

%%====================================================================
%% API functions
%%====================================================================

main(_Args) ->
    [bench(BenchModule, PropList, NumProcs, NumIterations) || {BenchModule, PropList} <- ?TEST_CONFIG, NumProcs <- ?NUM_PROCS, NumIterations <- ?ITERATIONS],
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
    [spawn_link(fun() -> iterate({BenchModule, BenchSetup}, Self, NumIterations, {0, []}) end) || _ <- Seq],
    [begin receive
               {results, Results}  -> process_results(Results, BenchModule, NumProcs, NumIterations)
           end
     end || _ <- Seq].

iterate(_, ParentPid, 0, {TotalRunTime, RunTimes})->
    ParentPid ! {results, {TotalRunTime, RunTimes}};
iterate({BenchModule, BenchSetup}, ParentPid, N, {TotalRunTime, RunTimes}) when N > 0 ->
    {Time, _Result} = timer:tc(BenchModule, bench_iteration, [BenchSetup]),
    iterate({BenchModule, BenchSetup}, ParentPid, N-1, {TotalRunTime + Time, [Time | RunTimes]}).


process_results({TotalRunTime, RunTimes}, BenchModule, NumProcs, NumIterations)
    when is_integer(TotalRunTime);is_list(RunTimes) ->
    io:format("[~10b][~10b][~p]: ~50fs~n", [NumProcs, NumIterations, BenchModule, TotalRunTime/?MICROS_IN_SEC]),
    BinResults = integer_list_to_binary(RunTimes),
    file:write_file(result_file_name(BenchModule, NumProcs, NumIterations), BinResults).

result_file_name(BenchModule, NumProcs, NumIterations)->
    lists:flatten(io_lib:format("~p_~b_~b.result", [BenchModule, NumProcs, NumIterations])).

integer_list_to_binary(Results)->
    %%  Convert list to string i.e. [1,2,3] -> "[1,2,3]"
    FlatResults = lists:flatten(io_lib:format("~p", [Results])),
    %%  Strip square brackets and convert ot binary i.e. "[1,2,3]"->"1,2,3"
    StrResults = string:strip(string:strip(FlatResults, left, $[), right, $]),
    list_to_binary(StrResults).



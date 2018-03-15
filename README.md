# erl_counter_bench
Performance benchmarks for various counter updating strategies in Erlang.  Very useful when designing a metrics library.

### Usage

>make
>make run

### Output
```
Processes    Iterations  Strategy                                          Time
[        10][       100][bench_ets]:                                       0.000257s
[       100][       100][bench_ets]:                                       0.489725s
[      1000][       100][bench_ets]:                                       5.860437s
[    100000][       100][bench_ets]:                                       586.720715s

[        10][       100][bench_core_level_ets]:                            0.000506s
[       100][       100][bench_core_level_ets]:                            0.007089s
[      1000][       100][bench_core_level_ets]:                            0.073113s
[    100000][       100][bench_core_level_ets]:                            7.498121s

[        10][       100][bench_oneup_counter]:                             0.000127s
[       100][       100][bench_oneup_counter]:                             0.001215s
[      1000][       100][bench_oneup_counter]:                             0.014106s
[    100000][       100][bench_oneup_counter]:                             1.620629s

[        10][       100][bench_core_level_oneup_counter]:                  0.000116s
[       100][       100][bench_core_level_oneup_counter]:                  0.001627s
[      1000][       100][bench_core_level_oneup_counter]:                  0.018448s
[    100000][       100][bench_core_level_oneup_counter]:                  1.880834s
```
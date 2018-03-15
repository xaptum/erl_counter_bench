BASEDIR = $(shell pwd)
REBAR = rebar3
APPNAME = erl_counter_bench
BIN = _build/default/bin
LIB = _build/default/lib
ONEUP_PRIV  = $(LIB)/oneup/priv
DEBUG=1

all:
	$(REBAR) escriptize
	export ONEUP_PRIV_PATH="`pwd`/$(ONEUP_PRIV)"

run:
	$(BIN)/$(APPNAME)

clean:
	$(REBAR) clean
	rm -rf _build
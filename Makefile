BASEDIR = $(shell pwd)
REBAR = rebar3
APPNAME = erl_counter_bench
BIN = _build/default/bin
LIB = _build/default/lib
ONEUP_PRIV = $(LIB)/oneup/priv
ONEUP_PRIV_PATH = $(BASEDIR)/$(ONEUP_PRIV)
DEBUG=1

all:
	$(REBAR) escriptize
	echo $(ONEUP_PRIV_PATH)

run:
	export ONEUP_PRIV_PATH=$(ONEUP_PRIV_PATH)
	$(BIN)/$(APPNAME)

test_env_var:
	echo $(ONEUP_PRIV_PATH)

clean:
	$(REBAR) clean
	rm -rf _build

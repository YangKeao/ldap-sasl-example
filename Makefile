ldap-sasl-tidb:
ifdef TIDB_SRC
	if [ ! -d tidb ]; then rsync -aq $$TIDB_SRC . --exclude-from=tidb.exclude ; fi
	docker build -t "tidb-with-ldap:latest" --build-arg 'GOPROXY=$(shell go env GOPROXY),' -f Dockerfile .
else
	@echo TIDB_SRC not defined! You should first   export TIDB_SRC=<path to tidb source code>
endif
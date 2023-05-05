ldap-sasl-example:
	docker build . -t ldap-sasl-example:latest

ldap-sasl-gssapi-example: ldap-sasl-example
	docker build . -t ldap-sasl-gssapi-example -f ./Dockerfile.gssapi

ldap-sasl-total:
ifdef TIDB_SRC
	if [ ! -d tidb ]; then rsync -aq $$TIDB_SRC . --exclude-from=tidb.exclude ; fi
	docker build -t "tidb-with-ldap:latest" --build-arg 'GOPROXY=$(shell go env GOPROXY),' -f Dockerfile.total .
else
	@echo TIDB_SRC not defined! You should first   export TIDB_SRC=<path to tidb source code>
endif
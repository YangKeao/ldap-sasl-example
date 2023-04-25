ldap-sasl-example:
	docker build . -t ldap-sasl-example:latest

ldap-sasl-gssapi-example: ldap-sasl-example
	docker build . -t ldap-sasl-gssapi-example -f ./Dockerfile.gssapi

.PHONY: ldap-sasl-example ldap-sasl-gssapi-example
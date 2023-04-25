# Example LDAP / SASL / Percona Server

This docker image will setup an slapd and a percona server. Run the following command will create an interactive bash with the `slapd` and `percona` booted.

```
docker run -it --rm --network host yangkeao/ldap-sasl-example /bin/bash
```

## `slapd` configuration

1. The base dn of `slapd` is `dc=example,dc=org`. It includes two users: `admin` and `yangkeao`. The password of both of them are `123456`.
2. The `sasl` is configured to authenticate with `sasldb2`. The user `yangkeao@example.org` is added in the `sasldb2` with password `123456`, so you can login the user `yangkeao` with sasl2.
3. The TLS is also enabled. The CA certificate/key is under `/ssl/example.crt` and `/ssl/example.key`. The signed certificate is assigned with DNS `localhost` and IP `127.0.0.1` in `ssl/ldap.crt`/`ssl/ldap.key`. However the key of CA certificate is not included in the docker image, as it's not needed for the bootstrap of `slapd`.

## Percona server configuration

1. An user `yangkeao` is added to the percona database, authenticated with `LDAP_SASL` and the dn is `cn=yangkeao,dc=example,dc=org`.

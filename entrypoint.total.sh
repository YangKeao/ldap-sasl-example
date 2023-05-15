#!/bin/bash

ulimit -n 1024
service slapd start
# service krb5-kdc start

# # Updating the master key: https://web.mit.edu/kerberos/krb5-latest/doc/admin/database.html#updating-master-key
# printf "123456\n123456" | kdb5_util add_mkey -s
# kdb5_util use_mkey 2
# printf "123456\n123456" | kinit yangkeao

./tidb-server &
sleep 3
mysql -h 127.0.0.1 -u root -P 4000 -e "set global authentication_ldap_sasl_server_host='127.0.0.1';create user yangkeao IDENTIFIED WITH authentication_ldap_sasl as 'cn=yangkeao+uid=yangkeao,dc=example,dc=org';"

exec "$@"
#!/bin/bash

ulimit -n 1024
echo "127.0.0.1 localhost example.org" >> /etc/hosts
service slapd start
service krb5-kdc start

printf "123456" | kinit cbc

# # Updating the master key: https://web.mit.edu/kerberos/krb5-latest/doc/admin/database.html#updating-master-key
# printf "123456\n123456" | kdb5_util add_mkey -s
# kdb5_util use_mkey 2

# ./tidb-server &
# sleep 3
# mysql -h 127.0.0.1 -u root -P 4000 -e "set global authentication_ldap_sasl_server_host='127.0.0.1';"
# mysql -h 127.0.0.1 -u root -P 4000 -e "create user yangkeao IDENTIFIED WITH authentication_ldap_sasl as 'cn=yangkeao+uid=yangkeao,dc=example,dc=org';"
# mysql -h 127.0.0.1 -u root -P 4000 -e "create user cbc IDENTIFIED WITH authentication_ldap_sasl as 'cn=cbc+uid=cbc,dc=example,dc=org';"

exec "$@"
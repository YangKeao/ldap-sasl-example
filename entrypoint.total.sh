#!/bin/bash

ulimit -n 1024
service slapd start
# service krb5-kdc start

./tidb-server &

exec "$@"
#!/bin/bash

ulimit -n 1024
service slapd start
service mysql start
service krb5-kdc start

exec "$@"
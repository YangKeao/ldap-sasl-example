FROM ubuntu:22.04

COPY ./debconf-slapd.conf /tmp/debconf-slapd.conf
RUN cat /tmp/debconf-slapd.conf | DEBIAN_FRONTEND=noninteractive debconf-set-selections
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install slapd ldap-utils libldap-2.5-0 sasl2-bin slapd-contrib libsasl2-modules libsasl2-modules-gssapi-mit libsasl2-modules-ldap -y

COPY ./slapd.conf.ldif /tmp/slapd.conf.ldif
RUN service slapd start && ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/slapd.conf.ldif && service slapd stop

COPY ./user.ldif /tmp/user.ldif
RUN service slapd start && ldapadd -x -D "cn=admin,dc=example,dc=org" -w 123456 -H ldapi:/// -f /tmp/user.ldif && service slapd stop

RUN echo "123456" |saslpasswd2 -c yangkeao -u example.org -p
RUN usermod -aG sasl openldap

# install percona server
RUN apt-get update -y && apt-get install curl -y
RUN curl -L -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
RUN apt-get install gnupg2 lsb-release ./percona-release_latest.generic_all.deb -y

COPY ./debconf-percona.conf /tmp/debconf-percona.conf
RUN cat /tmp/debconf-percona.conf | DEBIAN_FRONTEND=noninteractive debconf-set-selections
RUN apt-get update -y && percona-release setup ps80 && DEBIAN_FRONTEND=noninteractive apt-get install percona-server-server -y

COPY ./my.cnf /etc/my.cnf

RUN service mysql start && mysql -u root -p123456 -e "create user yangkeao IDENTIFIED WITH authentication_ldap_sasl as 'cn=yangkeao,dc=example,dc=org';" && service mysql stop

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
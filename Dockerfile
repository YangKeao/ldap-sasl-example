FROM ubuntu:22.04

COPY debconf-slapd.conf /debconf-slapd.conf
RUN cat /debconf-slapd.conf | debconf-set-selections

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
RUN apt-get install slapd ldap-utils sasl2-bin slapd-contrib libsasl2-modules libsasl2-modules-gssapi-mit libsasl2-modules-ldap -y

# configure sasl
COPY slapd.conf /usr/lib/sasl2/slapd.conf
WORKDIR /
COPY modify-config.ldif /
RUN /etc/init.d/slapd start && ldapmodify -Y EXTERNAL -H ldapi:/// -f /modify-config.ldif && /etc/init.d/slapd stop

COPY user.ldif /
RUN /etc/init.d/slapd start && ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin -H ldapi:/// -f user.ldif && /etc/init.d/slapd stop
RUN echo 123456 | saslpasswd2 -c yangkeao -p
RUN chmod 777 /etc/sasldb2

# Then execute `service slapd start`, and try `ldapsearch -Y SCRAM-SHA-256 -U yangkeao -H ldapi:///`. You'll succeed with password 123456
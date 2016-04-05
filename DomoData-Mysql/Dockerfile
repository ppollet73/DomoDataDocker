# ARM Version
#FROM: hypriot/rpi-mysql

# X86 version
FROM mysql:latest


MAINTAINER Madoma73

COPY DomoData-mysql.cnf /etc/mysql/conf.d/.
COPY DomoData.sql /docker-entrypoint-initdb.d/domodata.sql

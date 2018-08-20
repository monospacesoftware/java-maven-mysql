FROM maven:3-jdk-10
# Based on https://github.com/sameersbn/docker-mysql

LABEL maintainer="paul@monospacesoftware.com"

ENV MYSQL_USER=mysql \
    MYSQL_VERSION=5.7 \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server=${MYSQL_VERSION}* netcat \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

COPY mysql-entrypoint.sh /sbin/mysql-entrypoint.sh
COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/mysql-entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3306/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["mvn"]

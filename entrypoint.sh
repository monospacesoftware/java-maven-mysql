#!/bin/bash
set -euo pipefail

wait_for_mysql() {
  timeout=30
  echo -n "Waiting for database server to accept connections"
  while ! /usr/bin/mysqladmin -u root status >/dev/null 2>&1
  do
    timeout=$(($timeout - 1))
    if [ $timeout -eq 0 ]; then
      echo -e "\nCould not connect to database server. Aborting..."
      exit 1
    fi
    sleep 1
  done
  echo
}

/usr/local/bin/mvn-entrypoint.sh
/usr/sbin/mysql-entrypoint.sh&
wait_for_mysql

exec "$@"

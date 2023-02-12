#!/bin/bash -e
#
# (c) 2023 Sam Caldwell.  (mail@samcaldwell.net)"
#

query(){
  echo "$1" | psql
}

echo "Starting (DB:${POSTGRESQL_DB_NAME})(Postgres version: ${POSTGRESQL_VERSION})..."
echo "DB Name: ${POSTGRESQL_DB_NAME}"
echo ""
if [[ ! -d /var/lib/postgresql/${POSTGRESQL_VERSION} ]]; then
  echo "initializing the database"
  pg_createcluster ${POSTGRESQL_VERSION} main
  /etc/init.d/postgresql start
  echo "host    all             all             0.0.0.0/0            scram-sha-256" >> /etc/postgresql/14/main/pg_hba.conf
  echo "listen_addresses = '*'" > /etc/postgresql/14/main/conf.d/listen.conf
  echo "autovacuum = on" > /etc/postgresql/14/main/conf.d/autovacuum.conf
  query "alter user postgres with password '${POSTGRESQL_DB_PASS}';"
  query "create user ${POSTGRESQL_DB_USER} with superuser login password '${POSTGRESQL_DB_PASS}';"
  query "grant connect on database postgres to ${POSTGRESQL_DB_USER};"
  echo "database is initialized"
else
  echo "database is already initialized"
fi
while true; do
  echo "starting database"
  /etc/init.d/postgresql restart
  sleep 86400
done

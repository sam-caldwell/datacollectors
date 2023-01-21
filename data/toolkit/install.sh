#!/bin/bash

echo "sql/toolkit is installing..."
(
  echo "drop the toolkit database"
  while true; do
    sleep 2; \
    echo "select 1;" | \
        PGPASSWORD=vitapro psql --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres && break; \
  done
  set -e
  echo "drop database toolkit;" | \
    PGPASSWORD=vitapro psql --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres || true

  echo "create the toolkit database"
  sleep 1
  echo "create database toolkit with is_template=true" | \
    PGPASSWORD=vitapro psql -v ON_ERROR_STOP=1 \
                            --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres

  echo "preparing to install toolkit schema"
  cd """$(dirname "$0")""" || exit 1
  echo "current directory: $(pwd)"

  echo "installing toolkit schema"
  for raw in $(find ./sql/ -type f -name "*.sql"|sort); do
    file="""$(echo "${raw}" | awk -F \\/ '{print $3}')"""
    echo "installing ${file}"
    PGPASSWORD=vitapro psql -v ON_ERROR_STOP=1 \
                            --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=toolkit \
                            --file="sql/${file}" || {
                              echo "failed to install ${file}"
                              exit 1
                            }
  done
) && echo "toolkit is installed"
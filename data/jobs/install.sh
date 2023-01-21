#!/bin/bash

echo "sql/jobs is installing..."
(
  echo "drop the jobs database"
  while true; do
    sleep 2; \
    echo "select 1;" | \
        PGPASSWORD=vitapro psql --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres && break; \
  done
  set -e
  echo "drop database jobs;" | \
    PGPASSWORD=vitapro psql --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres || true

  echo "create the jobs database"
  sleep 1
  echo "create database jobs with template toolkit;" | \
    PGPASSWORD=vitapro psql -v ON_ERROR_STOP=1 \
                            --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres

  echo "preparing to install jobs schema"
  cd """$(dirname "$0")""" || exit 1
  echo "current directory: $(pwd)"

  echo "installing jobs schema"
  for raw in $(find ./sql/ -type f -name "*.sql"|sort); do
    file="""$(echo "${raw}" | awk -F \\/ '{print $3}')"""
    echo "installing ${file}"
    PGPASSWORD=vitapro psql -v ON_ERROR_STOP=1 \
                            --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=jobs \
                            --file="sql/${file}" || {
                              echo "failed to install ${file}"
                              exit 1
                            }
  done
) && echo "jobs db is installed"
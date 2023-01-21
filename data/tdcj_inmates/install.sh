#!/bin/bash -e

echo "tdcj_inmates db is installing..."
(
  echo "create database tdcj_inmates..."
  echo "create database tdcj_inmates template toolkit;" | \
    PGPASSWORD=vitapro psql -v ON_ERROR_STOP=0 \
                            --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=toolkit || true
  echo "database is created"
  cd """$(dirname "$0")""" || exit 1
  for raw in $(find sql/ -type f -name "*.sql"|sort); do
    file="""$(basename "${raw}")"""
    echo "${file}"
    PGPASSWORD=vitapro psql -v ON_ERROR_STOP=1 \
                            --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=tdcj_inmates \
                            --file="sql/${file}" || exit 99
  done
)
echo "tdcj_inmates db is installed"

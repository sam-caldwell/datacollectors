#!/bin/bash

. /usr/local/pretty_print.sh

connect_db(){
  print_blue "connecting to server..."
  while true; do
    sleep 2; \
    echo "select 1 as connected;" | \
        PGPASSWORD=${DB_PASS} psql --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres && break; \
    print_yellow "...waiting on server."
  done
  print_green "server connected."
}

drop_database() {
  print_blue "drop the ${DB_NAME} database"
  echo "drop database ${DB_NAME};" | \
    PGPASSWORD=${DB_PASS} psql --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres &>/dev/null || {
      print_yellow "database does not exist."
    }
  print_green "pre-existing database dropped"
}

create_database(){
  print_blue "create the ${1} database"
  echo "create database ${1} with template ${2};" | \
    PGPASSWORD=${DB_PASS} psql -v ON_ERROR_STOP=1 \
                            --host "${DB_HOST}" \
                            --port 5432 \
                            --username="${DB_USER}" \
                            --dbname=postgres || {
      print_red "failed to create database ${DB_NAME}"
      exit 99
    }
  print_green "database creation done for ${1}"
}

register_version(){
  SCHEMA_NAME="$1"
  DB_NAME="$2"
  FILE_NAME="$3"
  FILE_HASH="$4"
  echo "register_version() FILE_NAME:${FILE_NAME} HASH:${FILE_HASH}"
  # shellcheck disable=SC2028
  SQL_FILE="/tmp/$(date +%s)"
  cat >> "${SQL_FILE}" << SQL_EOF
DO
\$\$
begin
  call toolkit.register_version('${FILE_NAME}','${SCHEMA_NAME}','${DB_NAME}','${FILE_HASH}','install schema');
end
\$\$ language plpgsql;
SQL_EOF
    PGPASSWORD=${DB_PASS} psql -v ON_ERROR_STOP=1 \
                               --host "${DB_HOST}" \
                               --port 5432 \
                               --username="${DB_USER}" \
                               --dbname="toolkit" < ${SQL_FILE} || {
        print_red "failed to register ${file}"
        rm "${SQL_FILE}"
        exit 1
    }
    rm "${SQL_FILE}" &
}

install_schema(){
  SCHEMA_NAME="$1"
  DB_NAME="$1"
  (
    print_blue "preparing to install $1 schema (currently in $(pwd))"
    for raw in $(find ./sql/ -type f -name "*.sql"|sort); do
      file="""$(echo "${raw}" | awk -F \\/ '{print $3}')"""
      print_blue "installing ${file}"
      PGPASSWORD=${DB_PASS} psql -v ON_ERROR_STOP=1 \
                              --host "${DB_HOST}" \
                              --port 5432 \
                              --username="${DB_USER}" \
                              --dbname="${DB_NAME}" \
                              --file="sql/${file}" || {
        print_red "failed to install ${file}"
        exit 1
      }
      FILE_HASH=$(shasum -a 256 sql/${file} | awk '{print $1}')
      register_version "${SCHEMA_NAME}" "${DB_NAME}" "${file}" "${FILE_HASH}"
    done
  ) || exit 1
  print_green "schema installed for $1"
}

install_database(){
  banner "installing database: $1"
  drop_database "$1"
  ( \
    cd "$1" || exit 1; \
    ./install.sh "$1" || {
      print_red "install_database() $1 failed"; \
      return 2
    }
  ) || exit 3
  print_green "install_database() $1 done"
}

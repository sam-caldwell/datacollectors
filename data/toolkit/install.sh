#!/bin/bash

. /usr/local/pretty_print.sh
. /usr/local/database.sh

DB_NAME="$1"

echo "${DB_NAME} is installing..."
create_database "${DB_NAME}" "template0"
install_schema ${DB_NAME}

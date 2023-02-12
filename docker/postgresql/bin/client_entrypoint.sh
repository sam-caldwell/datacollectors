#!/bin/bash -e
/usr/bin/python3 /usr/bin/db_installer --manifest /opt/sql/ \
                              --db_host ${POSTGRESQL_DB_HOST} \
                              --db_port ${POSTGRESQL_DB_PORT} \
                              --db_name ${POSTGRESQL_DB_NAME} \
                              --db_user ${POSTGRESQL_DB_USER} \
                              --db_pass ${POSTGRESQL_DB_PASS}

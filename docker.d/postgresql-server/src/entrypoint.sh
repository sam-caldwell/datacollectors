#!/bin/bash -e
#
# entrypoint.sh
#
[[ ! -d "${CLUSTER_ROOT}/${CLUSTER_VERSION}/${CLUSTER_NAME}" ]] && {
  echo "initializing database..."
  pg_createcluster ${CLUSTER_VERSION} ${CLUSTER_NAME}
}
echo "starting database..."
/usr/lib/postgresql/${CLUSTER_VERSION}/bin/postgres \
    -D ${CLUSTER_ROOT}/${CLUSTER_VERSION}/${CLUSTER_NAME} \
    -c config_file=/etc/postgresql/${CLUSTER_VERSION}/${CLUSTER_NAME}/postgresql.conf



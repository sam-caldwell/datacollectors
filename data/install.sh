#!/bin/bash -e

. /usr/local/pretty_print.sh
. /usr/local/database.sh

banner "Starting database setup..."
connect_db
#
# The core db toolkit
#
install_database "toolkit" || exit 10
#
# The configuration schema/db
#
install_database "config" || exit 11
#
# A sql-based event log handler
#
install_database "log" || exit 12
#
# Our job scheduler
#
install_database "jobs" || exit 13
# ----- BELOW THIS POINT ARE THE DATA COLLECTOR PERSISTENCE DBs -----
#
# Collect OSINT on current TDCJ inmates for recidivism/sentencing study.
#
#install_database "tdcj_inmates" || exit 14

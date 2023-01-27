package pgConnector

import "database/sql"

type Database struct {
	conn  *sql.DB
	ready bool
}

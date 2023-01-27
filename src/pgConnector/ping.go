package pgConnector

import (
	"log"
)

func (o *Database) Ping() {
	log.Println("Checking db connection.")
	if err := o.conn.Ping(); err != nil {
		o.ready = false
	} else {
		o.ready = true
	}
}

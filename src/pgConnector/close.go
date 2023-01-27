package pgConnector

import "log"

func (o *Database) Close() {
	o.ready = false
	if err := o.conn.Close(); err != nil {
		log.Fatalf("Error closing db connection: %s", err)
	}
}

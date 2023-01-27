package pgConnector

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
	"log"
	"time"
)

func (o *Database) Connect(dbHost string, dbPort string, dbName string, dbUser string, dbPass string) {
	o.ready = false
	var err error

	log.Println("Connecting to the database.")

	connStr := fmt.Sprintf(
		"host=%s "+
			"port=%s "+
			"user=%s "+
			"password=%s "+
			"dbname=%s "+
			"sslmode=disable",
		dbHost, dbPort, dbUser, dbPass, dbName)

	if o.conn, err = sql.Open("postgres", connStr); err != nil {
		log.Fatalf("Error opening database connection: %s", err)
	}
	for i := 0; i < 10; i++ {
		o.Ping()
		if o.ready {
			log.Println("Database is connected.")
			break
		}
		log.Println("Waiting on database connection...")
		time.Sleep(1 * time.Second)
	}
	if !o.ready {
		log.Fatalf("Database connection failed.\n"+
			"\tDB_HOST: '%s'\n"+
			"\tDB_PORT: '%s'\n"+
			"\tDB_NAME: '%s'\n", dbHost, dbPort, dbName)
	}
}

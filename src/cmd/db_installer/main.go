package main

/*
 *
 */
import (
	"files"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"pgConnector"
)

func main() {

	fmt.Println("Starting...")

	if len(os.Args) < 7 {
		log.Fatalf("Invalid number of arguments: %d", len(os.Args))
	}
	var (
		dbHost      = os.Args[1]
		dbPort      = os.Args[2]
		dbName      = os.Args[3]
		dbUser      = os.Args[4]
		dbPass      = os.Args[5]
		sqlBasePath = os.Args[6]
	)

	var db pgConnector.Database
	db.Connect(dbHost, dbPort, dbName, dbUser, dbPass)
	defer db.Close()

	createDatabase := func(dbName string, isTemplate bool) (err error) {
		//ToDo: finish this.
		return
	}

	lastDb := ""
	for _, p := range files.List(sqlBasePath) {
		//p is a list of strings:
		dbName := p[1]
		isTemplate := p[2] == "template"
		fileName := p[4]

		if lastDb != dbName {
			if err := createDatabase(dbName, isTemplate); err != nil {
				log.Fatalf("db creation failed for %s [template: %s]",
					dbName, isTemplate)
			}
			lastDb = dbName
		}
		err := db.Execute(func() string {
			var err error
			var data []byte
			if data, err = ioutil.ReadFile(fileName); err != nil {
				log.Fatalf("Failed to read file[%s]: %s", fileName, err)
			}
			return string(data)
		}())
		if err != nil {
			log.Fatalf("Query failed in [%s]: %s", fileName, err)
		}
	}
	//ToDo: iterate over the file set
}

package main

import (
	"env"
	"files"
	"log"
)

/*
 *
 */

func main() {
	var sqlBasePath string
	var err error
	log.Println("Starting...")

	if sqlBasePath, err = env.GetStrEnv("DB_SCHEMA_SOURCE_PATH", ".+"); err != nil {
		panic(err)
	}
	log.Printf("Listing files in %s\n", sqlBasePath)

	for _, p := range files.List(sqlBasePath) {
		log.Println(p)
	}
	log.Println("done")
}

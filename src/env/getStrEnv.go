package env

import (
	"log"
	"os"
	"strings"
)

func GetStrEnv(n string) (result string) {
	result = strings.TrimSpace(os.Getenv(n))
	log.Printf("%s: %s\n", n, result)

	if result == "" {
		log.Fatalf("Environment variable [%s] is empty", n)
	}
	return result
}

package files

import (
	"fmt"
	"log"
	"path/filepath"
	"strconv"
	"strings"
)

func List(path string) (result [][]string) {

	matches, err := filepath.Glob(fmt.Sprintf("%s/*/*/*.sql", path))
	if err != nil {
		log.Fatal(err)
	}
	pathDepth := len(strings.Split(path, "/"))
	for i, thisPath := range matches {

		this := strings.Split(thisPath, "/")[pathDepth:]

		enabled := func() bool {
			e := strings.Split(strings.Split(this[0], "-")[1], ".")
			if len(e) > 1 {
				return e[1] != "disabled"
			}
			return true
		}()

		if enabled {
			dbOrder := strings.Split(this[0], ".")[0]
			dbName := strings.Split(strings.Split(this[0], ".")[2], "-")[0]
			dbType := strings.Split(strings.Split(this[0], ".")[2], "-")[1]

			schemaOrder := strings.Split(this[1], ".")[0]
			schemaName := strings.Split(this[1], ".")[2]

			fileOrder := strings.Split(this[2], ".")[0]

			orderId := strings.Join([]string{dbOrder, schemaOrder, fileOrder, strconv.Itoa(i)}, "")

			result = append(
				result,
				[]string{
					orderId,
					dbName,
					dbType,
					schemaName,
					thisPath})
		}
	}
	return
}

package pgConnector

func (o *Database) Execute(query string) (err error) {
	_, err = o.conn.Exec(query)
	return err
}

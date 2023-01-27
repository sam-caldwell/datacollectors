package pgConnector

func (o *Database) Ready() bool {
	return o.ready
}

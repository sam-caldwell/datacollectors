/*
 * The log schema facilitates event tracking across various parts of the database.
 * Through the use of these log events, we can store high-cardinality tagged events
 * across various schemas and operations for better analysis.
 */
create schema if not exists log;
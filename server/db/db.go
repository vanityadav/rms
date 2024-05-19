package db

import (
	"database/sql"
	"os"

	_ "github.com/lib/pq"
)

func Init() (*sql.DB, error) {

	connStr := os.Getenv("GOOSE_DBSTRING")

	db, err := sql.Open("postgres", connStr)

	if err != nil {
		return nil, err
	}

	pingErr := db.Ping()

	if pingErr != nil {
		return nil, pingErr
	}

	return db, nil

}

func Close(db *sql.DB) error {

	return db.Close()

}

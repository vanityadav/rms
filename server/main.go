package main

import (
	"log"

	"github.com/vanityadav/rms/server/api"
	"github.com/vanityadav/rms/server/db"
)

func main() {
	sqlDb, dbError := db.Init()

	if dbError != nil {
		log.Fatal("could not init db connection - " + dbError.Error())
	}

	server := api.NewAPIServer(":8080", sqlDb)

	err := server.Run()

	if err != nil {
		db.Close(sqlDb)
		log.Fatal(err.Error())
	}

}

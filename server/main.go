package main

import (
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/vanityadav/rms/server/api"
)

func main() {

	port, _ := strconv.Atoi(os.Getenv("PORT"))
	Addr := fmt.Sprintf(":%d", port)

	server := api.NewServer(Addr)

	err := server.ListenAndServe()

	if err != nil {
		panic(fmt.Sprintf("cannot start server: %s", err))
	}

	log.Printf("Server is running at port :%s", Addr)

}

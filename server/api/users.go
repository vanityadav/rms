package api

import (
	"encoding/json"
	"log"
	"net/http"
)

type User struct {
	Name  string `json:"name"`
	Email string `json:"email"`
	Id    int    `json:"id"`
}

func (s *Server) getUserHandler(
	w http.ResponseWriter, r *http.Request) {

	payload := User{Name: "Vanit", Email: "vanityadav08@gmail.com", Id: 3}

	jsonResp, err := json.Marshal(payload)
	if err != nil {
		log.Fatalf("error handling JSON marshal. Err: %v", err)
	}

	w.Write(jsonResp)

}

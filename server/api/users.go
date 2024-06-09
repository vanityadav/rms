package api

import (
	"encoding/json"
	"net/http"
)

type User struct {
	name  string
	email string
	id    int
}

func (s *Server) getUserHandler(
	w http.ResponseWriter, r *http.Request) {

	jsonResp, _ := json.Marshal(&User{name: "Vanit", email: "vanityadav08@gmail.com", id: 3})

	w.Write(jsonResp)
}

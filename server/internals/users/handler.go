package users

import (
	"fmt"
	"net/http"
)

type Handler struct {
	service UserService
}

func NewHandler(service UserService) *Handler {
	return &Handler{
		service,
	}
}

func (h *Handler) RegisterRouter(router *http.ServeMux) {
	router.HandleFunc("POST /signup", h.SignUp)
}

func (h *Handler) SignUp(w http.ResponseWriter, r *http.Request) {
	name := r.FormValue("username")
	password := r.FormValue("password")

	fmt.Println(name, password)
}

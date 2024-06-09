package api

import (
	"encoding/json"
	"log"
	"net/http"
)

func (s *Server) RegisterRoutes() *http.ServeMux {

	mux := http.NewServeMux()
	router := http.NewServeMux()
	adminRouter := http.NewServeMux()
	router.Handle("/admin/", http.StripPrefix("/admin", adminRouter))
	mux.Handle("/api/v1/", http.StripPrefix("/api/v1", router))

	adminRouter.HandleFunc("GET /get", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World Admin"))
	})

	router.HandleFunc("GET /get", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World "))
	})

	router.HandleFunc("GET /user", s.getUserHandler)
	mux.HandleFunc("/health", s.healthHandler)

	return mux
}

func (s *Server) healthHandler(w http.ResponseWriter, r *http.Request) {
	jsonResp, err := json.Marshal(s.db.Health())

	if err != nil {
		log.Fatalf("error handling JSON marshal. Err: %v", err)
	}

	_, _ = w.Write(jsonResp)
}

package api

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/vanityadav/rms/server/internals/users"
	"github.com/vanityadav/rms/server/middleware"
)

type APIServer struct {
	Addr string
	*sql.DB
}

func NewAPIServer(Addr string, db *sql.DB) *APIServer {
	return &APIServer{
		Addr,
		db,
	}
}

func (s *APIServer) Run() error {

	router := http.NewServeMux()
	adminRouter := http.NewServeMux()
	v1 := http.NewServeMux()

	adminRouter.HandleFunc("GET /get", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World Admin"))
	})
	router.HandleFunc("GET /get", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World "))
	})

	router.Handle("/admin/", http.StripPrefix("/admin", adminRouter))
	v1.Handle("/api/v1/", http.StripPrefix("/api/v1", router))

	userStore := users.NewStore(s.DB)
	userService := users.NewService(userStore)
	userHandler := users.NewHandler(userService)

	userHandler.RegisterRouter(router)

	stack := middleware.CreateStack(middleware.RequestCtx, middleware.RequestLogs)

	server := http.Server{
		Addr:    s.Addr,
		Handler: stack(v1),
	}

	fmt.Println("Server is running on port " + s.Addr)

	serverError := server.ListenAndServe()

	return serverError
}

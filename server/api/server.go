package api

import (
	"net/http"
	"time"

	"github.com/vanityadav/rms/server/db"
	"github.com/vanityadav/rms/server/middleware"
)

type Server struct {
	db db.Service
}

func NewServer(Addr string) *http.Server {

	NewServer := &Server{
		db: db.New(),
	}

	stack := middleware.CreateStack(middleware.RequestCtx, middleware.Logs)

	server := &http.Server{
		Addr:         Addr,
		Handler:      stack(NewServer.RegisterRoutes()),
		IdleTimeout:  time.Minute,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	return server
}

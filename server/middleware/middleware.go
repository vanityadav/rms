package middleware

import (
	"context"
	"log"
	"net/http"
	"time"

	"github.com/google/uuid"
)

type Middleware func(http.Handler) http.Handler

type RequestContext struct {
	ID uuid.UUID
}

type WrapperWriter struct {
	http.ResponseWriter
	statusCode int
}

func (w *WrapperWriter) WriteHeader(statusCode int) {
	w.ResponseWriter.WriteHeader(statusCode)
	w.statusCode = statusCode
}

func CreateStack(middlewares ...Middleware) Middleware {

	return func(next http.Handler) http.Handler {
		for i := len(middlewares) - 1; i >= 0; i-- {
			mid := middlewares[i]
			next = mid(next)
		}
		return next
	}
}

func RequestCtx(next http.Handler) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ID, err := uuid.NewV7()
		if err != nil {
			log.Fatal("Failed to create uuid for incoming request")
		}
		ctx := context.WithValue(r.Context(), "ReqID", &RequestContext{ID})
		next.ServeHTTP(w, r.WithContext(ctx))
	})

}

func RequestLogs(next http.Handler) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		wrapped := &WrapperWriter{
			ResponseWriter: w,
			statusCode:     http.StatusOK,
		}

		next.ServeHTTP(wrapped, r)

		log.Println(r.Context().Value("ReqID"), r.Method, r.URL.Path, wrapped.statusCode, time.Since(start))
	})

}

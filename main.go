package main

import (
	"fmt"
	"net/http"

	"go.uber.org/zap"
)

func main() {
	logger, _ := zap.NewProduction()
	defer logger.Sync()

	http.HandleFunc("/", handler)

	port := "8080"
	logger.Info("starting server", zap.String("port", port))
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		logger.Error("error", zap.Error(err))
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	header := w.Header()
	header.Set("Content-Type", "application/json")
	fmt.Fprint(w, `{"hello": "world"}`)
}

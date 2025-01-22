package main

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
	"github.com/tamako8782/cloudtech-sprint2/handlers"
)

func main() {

	r := mux.NewRouter()

	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders: []string{"Content-Type", "Authorization"},
	})

	r.HandleFunc("/", handlers.HelloHandler).Methods("GET")
	r.HandleFunc("/testapi", handlers.ApiHandler).Methods("GET")
	r.HandleFunc("/dbapi", handlers.DbApiHandler).Methods("GET")

	handler := c.Handler(r)

	log.Println("server start at port 8080")
	err := http.ListenAndServe(":8080", handler)
	if err != nil {
		log.Fatal(err)
	}
}

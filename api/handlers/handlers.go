package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/tamako8782/cloudtech-sprint2/models"
	"github.com/tamako8782/cloudtech-sprint2/repositories"
)

func HelloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World!")
}

func ApiHandler(w http.ResponseWriter, r *http.Request) {

	Reservations := models.Res[0]

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Reservations)
}

func DbApiHandler(w http.ResponseWriter, r *http.Request) {

	queryMap := r.URL.Query()

	var page int

	if p, ok := queryMap["page"]; ok && len(p) > 0 {
		var err error
		page, err = strconv.Atoi(p[0])
		if err != nil {
			http.Error(w, "failed to convert page to int", http.StatusBadRequest)
			return
		}
	} else {
		page = 1
	}

	var Reservations []models.Reservation

	Reservations, err := repositories.RepoGetReservation(page)
	if err != nil {
		http.Error(w, "failed to get reservations", http.StatusInternalServerError)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Reservations)
}

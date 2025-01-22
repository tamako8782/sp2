package repositories

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
	"github.com/tamako8782/cloudtech-sprint2/models"
)

const (
	pageSize = 10
)

func RepoGetReservation(page int) ([]models.Reservation, error) {

	err := godotenv.Load(".env")
	if err != nil {
		log.Println("unabled to load .env file")
	}

	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASS")
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")
	dbConn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", dbUser, dbPass, dbHost, dbPort, dbName)

	db, err := sql.Open("mysql", dbConn)
	if err != nil {
		return nil, err
	}
	if err := db.Ping(); err != nil {
		log.Println(err)
		return nil, err
	}

	sqlStr := "SELECT * FROM Reservations LIMIT ? OFFSET ?"

	offset := (page - 1) * pageSize

	rows, err := db.Query(sqlStr, pageSize, offset)
	if err != nil {
		log.Println(err)
	}

	Reservations := make([]models.Reservation, 0)

	for rows.Next() {
		var reservation models.Reservation
		err := rows.Scan(&reservation.ID, &reservation.Name)
		if err != nil {
			log.Printf("Failed to scan row: %v", err)
			return nil, err

		}
		Reservations = append(Reservations, reservation)
	}

	defer db.Close()
	return Reservations, nil
}

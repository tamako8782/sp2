package models

type Reservation struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

var Res = []Reservation{
	{
		ID:   1,
		Name: "yamamoto",
	},
	{
		ID:   2,
		Name: "tamako",
	},
}

package main

//go:generate swagger generate spec -o ../../api/swagger/swagger.yaml --scan-models

import (
	_ "github.com/Chever-John/cas/api/swagger/docs"
)

func main() {
}

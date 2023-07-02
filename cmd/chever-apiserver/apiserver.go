package main

import (
	"math/rand"
	"time"

	"github.com/Chever-John/Chever-Apiserver/internal/apiserver"
)

// apiserver is the api server for the whole service.
// It is responsible for serving the platform RESTful resource management.

func main() {
	rand.Seed(time.Now().UTC().UnixNano())

	apiserver.NewApp("cas-apiserver").Run()
}

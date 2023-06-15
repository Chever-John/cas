package main

import (
	"github.com/Chever-John/Chever-Apiserver/internal/apiserver"
	"math/rand"
	"time"
)

// apiserver is the api server for the whole servie.
// It is responsible for serving the platform RESTful resource management.

func main() {
	rand.Seed(time.Now().UTC().UnixNano())

	apiserver.NewApp("chever-apiserver").Run()
}

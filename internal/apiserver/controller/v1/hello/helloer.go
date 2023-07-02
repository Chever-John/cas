package hello

import (
	srvv1 "github.com/Chever-John/cas/internal/apiserver/service/v1"
)

type HelloerController struct {
	srv srvv1.Service
}

// NewHelloerController creates a helloer handler.
func NewHelloerController() *HelloerController {
	return &HelloerController{
		srv: srvv1.NewService(),
	}
}

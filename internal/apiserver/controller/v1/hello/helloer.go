package hello

import (
	srvv1 "github.com/Chever-John/Chever-Apiserver/internal/apiserver/service/v1"
)

type HelloerController struct {
	srv srvv1.HelloerSrv
}

// NewHelloerController creates a helloer handler.
func NewHelloerController() *HelloerController {
	return &HelloerController{
		srv: srvv1.NewService(),
	}
}
